// Intermediary between Firestore and Viewmodels

// Functionalities
// - initializing current User (id, e-mail, fullname, wallet balances)
// - exposing currentUser
// - exposing stream of statistics

import 'dart:async';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/datamodels/users/user_statistics.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class UserService {
  final _firestoreApi = locator<FirestoreApi>();
  final FirebaseAuthenticationService _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final log = getLogger('UserService');

  User? _currentUser;
  User? get currentUserNullable => _currentUser;
  User get currentUser => _currentUser!;

  bool get hasLoggedInUser => _firebaseAuthenticationService.hasUser;

  UserRole get getUserRole => currentUser.role;

  bool get hasRole => currentUserNullable == null ? false : true;

  // store list of supportedExplorers
  // map of list of money pools with money Pool id as key
  List<User> supportedExplorers = [];
  StreamSubscription? _supportedExplorersStreamSubscription;

  Future<void> syncUserAccount(
      {String? uid, bool fromLocalStorage = false}) async {
    final actualUid =
        uid ?? _firebaseAuthenticationService.firebaseAuth.currentUser!.uid;

    log.v('Sync user $actualUid');

    final userAccount = await _firestoreApi.getUser(uid: actualUid);

    if (userAccount != null) {
      log.v('User account exists. Save as _currentUser');
      _currentUser = userAccount;
      if (fromLocalStorage) {
        log.v("Save current user id to disk");
        await _localStorageService.saveToDisk(
            key: kLocalStorageUidKey, value: userAccount.uid);
      }
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
      log.v("Creating user account");
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

  Future<String?> getLocallyLoggedInUserId() async {
    final id = await _localStorageService.getFromDisk(key: kLocalStorageUidKey);
    return id;
  }

  Future<AFKCreditsAuthenticationResult> runLoginLogic(
      {required AuthenticationMethod method,
      String? emailOrName,
      String? password,
      UserRole? role}) async {
    if (method == AuthenticationMethod.EmailOrSponsorCreatedExplorer) {
      // check whether account exists with emailOrName as name.
      // In that case we are dealing with an explorer account
      // created by a sponsor in the app. This account does
      // not have authentication set up but has a reference to the
      // sponsor account with the createdByUserWithId field.
      // We just return the id of that user here.
      final user = await _firestoreApi.getUserWithName(name: emailOrName);
      if (user != null) {
        if (user.password != null &&
            isMatchingPasswords(hashedPw: user.password, stringPw: password)) {
          // && password == user.password) {
          log.i("Found AFK user that was created by a sponsor inside the app");
          return AFKCreditsAuthenticationResult.fromLocalStorage(uid: user.uid);
        } else {
          log.i(
              "Found AFK user that was created by a sponsor inside the app but password is not valid!");
          return Future.value(AFKCreditsAuthenticationResult.error(
              errorMessage:
                  "Password for user with name $emailOrName is not correct."));
        }
      } else {
        log.i("Login with e-mail");
        return AFKCreditsAuthenticationResult.fromFirebaseAuthenticationResult(
            firebaseAuthenticationResult: await _firebaseAuthenticationService
                .loginWithEmail(email: emailOrName!, password: password!));
      }
    } else if (method == AuthenticationMethod.email) {
      log.i("Login with e-mail");
      return AFKCreditsAuthenticationResult.fromFirebaseAuthenticationResult(
          firebaseAuthenticationResult: await _firebaseAuthenticationService
              .loginWithEmail(email: emailOrName!, password: password!));
    } else if (method == AuthenticationMethod.google) {
      log.i("Login with google");
      return AFKCreditsAuthenticationResult.fromFirebaseAuthenticationResult(
          firebaseAuthenticationResult:
              await _firebaseAuthenticationService.signInWithGoogle());
    } else if (method == AuthenticationMethod.dummy) {
      return AFKCreditsAuthenticationResult.fromFirebaseAuthenticationResult(
          firebaseAuthenticationResult:
              await _firebaseAuthenticationService.loginWithEmail(
                  email: _flavorConfigProvider.getTestUserEmail(role),
                  password: _flavorConfigProvider.getTestUserPassword()));
    } else {
      log.e(
          "The authentication method you tried to use is not implemented yet. Use E-mail, Google, or Apple to authenticate");
      return Future.value(AFKCreditsAuthenticationResult.error(
          errorMessage:
              "Authentification method you try to use is not available."));
    }
  }

  Future<AFKCreditsAuthenticationResult> runCreateAccountLogic(
      {required AuthenticationMethod method,
      required UserRole role,
      String? fullName,
      String? email,
      String? password}) async {
    FirebaseAuthenticationResult result;
    if (method == AuthenticationMethod.email) {
      log.i("Creating account with e-mail");
      // use actual firebase auth here because stacked's version does
      // not expose the user in the result
      result = await _firebaseAuthenticationService.createAccountWithEmail(
          email: email!, password: password!);
    } else {
      log.e(
          "The authentication method you tried to use is not implemented yet. Use E-mail, Google, Facebook, or Apple to authenticate");
      return AFKCreditsAuthenticationResult.error(
          errorMessage: "Authentication method not valid!");
    }
    if (result.hasError) {
      return AFKCreditsAuthenticationResult.error(
          errorMessage: result.errorMessage);
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
          return AFKCreditsAuthenticationResult.error(
              errorMessage: e.prettyDetails ??
                  "Something went wrong when creating a new user in our databank. Please try again later or contact support!");
        } else {
          return AFKCreditsAuthenticationResult.error(
              errorMessage:
                  "Something went wrong when creating a new user in our databank. Please try again later or contact support!");
        }
      }
      return AFKCreditsAuthenticationResult.authenticatedUser(
          firebaseUser: result.user);
    }
  }

  /////////////////////////////////////////////////
  /// Functions to add explorer accounts!

  bool isSupportedExplorer({required String uid}) {
    List<String> explorerIds = currentUser.explorerIds;
    return explorerIds.contains(uid);
  }

  Future createExplorerAccount(
      {required String name, required String password}) async {
    if (await isUserAlreadyPresent(name: name)) {
      return "User with name $name already present. Please choose a different name.";
    }

    final docRef = _firestoreApi.createUserDocument();
    final newExplorer = User(
      fullName: name,
      password: hashPassword(password),
      uid: docRef.id,
      role: UserRole.explorer,
      sponsorIds: [currentUser.uid],
      createdByUserWithId: currentUser.uid,
      explorerIds: [],
      newUser: true,
    );
    await createUserAccount(user: newExplorer);
    List<String> newExplorerIds = addToSupportedExplorersList(uid: docRef.id);
    await updateUserData(
        user: currentUser.copyWith(explorerIds: newExplorerIds));
  }

  Future addExplorerToSupportedExplorers({required String uid}) async {
    try {
      if (currentUser.explorerIds.contains(uid)) {
        return "Explorer already supported";
      } else {
        log.i("Adding explorer with id $uid to list of explorers");
        List<String> newExplorerIds = addToSupportedExplorersList(uid: uid);
        // Ideal way would be to add a transaction here!
        await Future.wait([
          updateUserData(
              user: currentUser.copyWith(explorerIds: newExplorerIds)),
          addSponsorIdToOtherUser(
              otherUsersId: uid, sponsorId: currentUser.uid),
        ]);
        await Future.delayed(Duration(seconds: 3));
      }
    } catch (e) {
      log.e(
          "Error when trying to add new explorer to list of supported explorers");
      rethrow;
    }
  }

  // Stream of current user with list with explorer Ids.
  // Whenevee that updates the stream holding the list of friends will update too.
  void addExplorerListener(
      {required Completer<void> completer, void Function()? callback}) async {
    if (_supportedExplorersStreamSubscription == null) {
      Stream<User> userStream =
          _firestoreApi.getUserStream(uid: currentUser.uid);
      _supportedExplorersStreamSubscription = userStream.listen((user) async {
        _currentUser = user;
        await updateSupportedExplorersList(newUser: user);
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
        log.v("Listened to ${supportedExplorers.length} supportedExplorers");
      });
    } else {
      log.w("Already listening to list of explorers");
      completer.complete();
    }
  }

  Future updateSupportedExplorersList({required User newUser}) async {
    List<String>? explorerIds = newUser.explorerIds;
    List<User> tmpSupportedExplorers = [];
    List<String> previousExplorerIds =
        supportedExplorers.map((e) => e.uid).toList();
    // add supportedExplorers but only read documents of new supportedExplorers
    for (var id in explorerIds) {
      if (!previousExplorerIds.contains(id)) {
        log.i("getting user data with id $id");
        User? tmpUser = await _firestoreApi.getUser(uid: id);
        if (tmpUser != null) {
          tmpSupportedExplorers.add(tmpUser);
        }
      }
    }
    // remove supportedExplorers
    for (var id in previousExplorerIds) {
      if (!explorerIds.contains(id)) {
        supportedExplorers.removeWhere((element) => element.uid == id);
      }
    }
    supportedExplorers.addAll(tmpSupportedExplorers);
  }

  /////////////////////////////////////////////////
  /// Some helper functions

  List<String> addToSupportedExplorersList({required String uid}) {
    List<String> newExplorerIds = [];
    newExplorerIds.addAll(currentUser.explorerIds);
    newExplorerIds.add(uid);
    return newExplorerIds;
  }

  bool isMatchingPasswords(
      {required String? hashedPw, required String? stringPw}) {
    if (hashedPw == null || stringPw == null) return false;
    final hash1 = hashPassword(stringPw);
    return hash1.compareTo(hashedPw) == 0;
  }

  String hashPassword(String pw) {
    final bytes1 = utf8.encode(pw); // data being hashed
    return sha1.convert(bytes1).toString();
  }

  //////////////////////////////////////////////////
  // Calls to database

  Future updateUserData({required User user}) async {
    _currentUser = user;
    _firestoreApi.updateUserData(user: user);
  }

  Future addSponsorIdToOtherUser(
      {required String otherUsersId, required String sponsorId}) async {
    _firestoreApi.addSponsorIdToUser(uid: otherUsersId, sponsorId: sponsorId);
  }

  Future isUserAlreadyPresent({required name}) async {
    final uid = await _firestoreApi.getUserWithName(name: name);
    return uid != null;
  }

  ///////////////////////////////////////////////////
  // Clean up

  // clear all data when user logs out!
  Future handleLogoutEvent() async {
    // remove uid from local storage
    await _localStorageService.deleteFromDisk(key: kLocalStorageUidKey);

    // set current user to null
    _currentUser = null;

    // remove exploers listener
    _supportedExplorersStreamSubscription?.cancel();
    _supportedExplorersStreamSubscription = null;
    supportedExplorers = [];

    // actually log out from firebase
    await _firebaseAuthenticationService.logout();
  }
}

////////////////////////////////////////////////////
/// AFK Credits authentication result
/// We need this abstraction because we
/// can have users not authenticated with
/// firebase authentication (explorer accounts
/// added from sponsors)
class AFKCreditsAuthenticationResult {
  /// AFK Credits user
  final User? user;

  /// Firebase user
  final firebase.User? firebaseUser;

  /// Firebase user
  final String? uid;

  final bool fromLocalStorage;

  /// Firebase user
  final FirebaseAuthenticationResult? firebaseAuthenticationResult;

  /// Contains the error message for the request
  final String? errorMessage;

  AFKCreditsAuthenticationResult.authenticatedUser({this.firebaseUser})
      : errorMessage = null,
        user = null,
        fromLocalStorage = false,
        uid = firebaseUser?.uid,
        firebaseAuthenticationResult = null;

  AFKCreditsAuthenticationResult.fromFirebaseAuthenticationResult(
      {this.firebaseAuthenticationResult})
      : errorMessage = firebaseAuthenticationResult?.errorMessage,
        firebaseUser = firebaseAuthenticationResult?.user,
        uid = firebaseAuthenticationResult?.user?.uid,
        fromLocalStorage = false,
        user = null;

  AFKCreditsAuthenticationResult.explorerCreatedFromSponsor({this.user})
      : errorMessage = null,
        firebaseUser = null,
        uid = user?.uid,
        fromLocalStorage = false,
        firebaseAuthenticationResult = null;

  AFKCreditsAuthenticationResult.fromLocalStorage({this.uid})
      : errorMessage = null,
        firebaseUser = null,
        user = null,
        fromLocalStorage = true,
        firebaseAuthenticationResult = null;

  AFKCreditsAuthenticationResult.error({this.errorMessage})
      : user = null,
        firebaseUser = null,
        uid = null,
        fromLocalStorage = false,
        firebaseAuthenticationResult = null;

  /// Returns true if the response has an error associated with it
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  bool get isExplorerCreatedFromSponsor =>
      (firebaseUser == null && user != null) ||
      (firebaseUser == null && user == null && uid != null);
}
