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
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

class UserService {
  final _firestoreApi = locator<FirestoreApi>();
  final FirebaseAuthenticationService _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final log = getLogger('UserService');

  User? _currentUser;
  User? get currentUserNullable => _currentUser;
  User get currentUser => _currentUser!;

  bool get hasLoggedInUser => _firebaseAuthenticationService.hasUser;

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

  Future<void> syncOrCreateUserAccount({required User user}) async {
    log.i('user:$user');

    await syncUserAccount();

    if (_currentUser == null) {
      log.v('We have no user account. Create a new user ...');
      _currentUser = await createUser(user: user);
      log.v('_currentUser has been saved');
    }
  }

  // create user documents (user info, statistics) in firestore
  Future<User> createUser({required User user}) async {
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

  ///////////////////////////////////////////////////
  // Clean up

  // clear all data when user logs out!
  Future handleLogoutEvent() async {
    // cancel user stream subscription
    // userStreamSubscription?.cancel();
    // userStreamSubscription = null;

    // set current user to null
    _currentUser = getEmptyUser();
    // actually log out from firebase
    await _firebaseAuthenticationService.logout();
  }
}
