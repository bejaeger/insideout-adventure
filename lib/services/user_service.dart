// Intermediary between Firestore and Viewmodels

// Functionalities
// - initializing current User (id, e-mail, fullname, wallet balances)
// - exposing currentUser
// - exposing stream of statistics

import 'dart:async';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/datamodels/users/user_statistics.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserService {
  final _firestoreApi = locator<FirestoreApi>();
  final FirebaseAuthenticationService _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();
  final log = getLogger('UserService');

  User? _currentUser;
  User? get currentUserNullable => _currentUser;
  User get currentUser => _currentUser!;

  bool get hasLoggedInUser => _firebaseAuthenticationService.hasUser;

  UserRole get getUserRole => currentUser.role;

  bool get hasRole => currentUserNullable == null ? false : true;

  Future<void> syncUserAccount() async {
    final String firebaseUserId =
        _firebaseAuthenticationService.firebaseAuth.currentUser!.uid;

    log.v('Sync user $firebaseUserId');

    final userAccount = await _firestoreApi.getUser(uid: firebaseUserId);

    if (userAccount != null) {
      log.v('User account exists. Save as _currentUser');
      _currentUser = userAccount;
    }
  }

  Future<User> createUserAccountFromFirebaseUser(
      {required UserRole role}) async {
    final user = _firebaseAuthenticationService.firebaseAuth.currentUser!;
    return await createUserAccount(
        user: User(
      uid: user.uid,
      role: role,
      fullName: user.displayName ?? "",
      email: user.email ?? "",
      newUser: true,
      explorerIds: [],
      sponsorIds: [],
    ));
  }

  // create user documents (user info, statistics) in firestore
  Future<User> createUserAccount({required User user}) async {
    // create a new user profile on firestore
    try {
      List<String> keywords = getListOfKeywordsFromString(user.fullName);
      User newUser = user.copyWith(fullNameSearch: keywords);
      UserStatistics stats = getEmptyUserStatistics();
      await _firestoreApi.createUser(user: newUser, stats: stats);
      return newUser;
    } catch (e) {
      log.e("Error in createUser(): ${e.toString()}");
      throw UserServiceException(
        message: "Creating user data failed with message",
        devDetails: e.toString(),
        prettyDetails:
            "User data could not be created in our databank. Please try again later or contact support with error messaage: ${e.toString()}",
      );
    }
  }

  Future<FirebaseAuthenticationResult> runLoginLogic(
      {required AuthenticationMethod method,
      String? email,
      String? password,
      UserRole? role}) async {
    if (method == AuthenticationMethod.Email) {
      log.i("Login with e-mail");
      return _firebaseAuthenticationService.loginWithEmail(
          email: email!, password: password!);
    } else if (method == AuthenticationMethod.google) {
      log.i("Login with google");
      return _firebaseAuthenticationService.signInWithGoogle();
    } else if (method == AuthenticationMethod.dummy) {
      return _firebaseAuthenticationService.loginWithEmail(
          email: _flavorConfigProvider.getTestUserEmail(role),
          password: _flavorConfigProvider.getTestUserPassword());
    } else {
      log.e(
          "The authentication method you tried to use is not implemented yet. Use E-mail, Google, or Apple to authenticate");
      return Future.value(FirebaseAuthenticationResult.error(
          errorMessage:
              "Authentification method you try to use is not available."));
    }
  }

  Future<FirebaseAuthenticationResult> runCreateAccountLogic(
      {required AuthenticationMethod method,
      required UserRole role,
      String? fullName,
      String? email,
      String? password}) async {
    FirebaseAuthenticationResult result;
    if (method == AuthenticationMethod.Email) {
      log.i("Creating account with e-mail");
      // use actual firebase auth here because stacked's version does
      // not expose the user in the result
      result = await _firebaseAuthenticationService.createAccountWithEmail(
          email: email!, password: password!);
    } else {
      log.e(
          "The authentication method you tried to use is not implemented yet. Use E-mail, Google, Facebook, or Apple to authenticate");
      return FirebaseAuthenticationResult.error(
          errorMessage: "Authentication method not valid!");
    }
    if (result.hasError) {
      return result;
    } else {
      // create user in data bank
      try {
        final user = result.user!;
        await createUserAccount(
            user: User(
          uid: user.uid,
          role: role,
          fullName: fullName ?? (user.displayName ?? ""),
          email: user.email ?? "",
          newUser: true,
          explorerIds: [],
          sponsorIds: [],
        ));
      } catch (e) {
        log.e("Error: $e");
        if (e is FirestoreApiException) {
          return FirebaseAuthenticationResult.error(
              errorMessage: e.prettyDetails ??
                  "Something went wrong when creating a new user in our databank. Please try again later or contact support!");
        } else {
          return FirebaseAuthenticationResult.error(
              errorMessage:
                  "Something went wrong when creating a new user in our databank. Please try again later or contact support!");
        }
      }
      return FirebaseAuthenticationResult(user: result.user);
    }
  }
  ///////////////////////////////////////////////////
  // Clean up

  // clear all data when user logs out!
  Future handleLogoutEvent() async {
    // cancel user stream subscription
    // userStreamSubscription?.cancel();
    // userStreamSubscription = null;

    // set current user to null
    _currentUser = null;

    // actually log out from firebase
    await _firebaseAuthenticationService.logout();
  }
}
