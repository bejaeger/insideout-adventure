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
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
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
  UserStatistics? _currentUserStats;
  UserStatistics get currentUserStats => _currentUserStats!;
  StreamSubscription? _currentUserStreamSubscription;
  StreamSubscription? _currentUserStatsStreamSubscription;

  bool get hasLoggedInUser => _firebaseAuthenticationService.hasUser;

  UserRole get getUserRole => currentUser.role;

  bool get hasRole => currentUserNullable == null ? false : true;

  // store list of supportedExplorers
  // map of list of money pools with money Pool id as key
  Map<String, User> supportedExplorers = {};
  Map<String, UserStatistics> supportedExplorerStats = {};

  StreamSubscription? _explorersDataStreamSubscriptions;

  List<User> get supportedExplorersList {
    List<User> list = [];
    supportedExplorers.forEach((key, value) {
      list.add(value);
    });
    return list;
  }

  Map<String, StreamSubscription?> _explorerStatsStreamSubscriptions = {};

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
      UserStatistics stats = getEmptyUserStatistics(uid: newUser.uid);
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
      }
    } catch (e) {
      log.e(
          "Error when trying to add new explorer to list of supported explorers");
      rethrow;
    }
  }

  //////////////////////////////////////////////////////////
  /// Listener setup
  ///
  /// The following function adds all necessary listeners
  ///
  /// 1. currentUser
  /// 2. currentUser stats
  ///
  /// 3. explorer user data
  ///    -> handled with a query snapshot to look for all users that
  ///       have the currentUser's id in the sponsorIds arraay
  ///
  /// 4. explorer statistics documents
  ///   -> handled manually in the listener of 3. by adding and removing
  ///      listeneres to the summary stats documents whenever the explorer
  ///      changes
  ///

  void setupUserDataListeners(
      {required Completer<void> completer, void Function()? callback}) async {
    // set up listener for explorer user data
    if (_explorersDataStreamSubscriptions == null) {
      _explorersDataStreamSubscriptions = _firestoreApi
          .getExplorersDataStream(uid: currentUser.uid)
          .listen((users) async {
        // remove explorers if not present anymore
        List<String> newUids = users.map((e) => e.uid).toList();
        List<String> currentUids =
            supportedExplorersList.map((e) => e.uid).toList();
        currentUids.forEach((element) {
          if (!newUids.contains(element)) {
            removeFromExplorerLists(uid: element);
          }
        });
        // update existing explorers
        users.forEach((user) {
          supportedExplorers[user.uid] = user;
        });

        await addExplorerStatsListeners(
            explorerIds: newUids, callback: callback);

        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
        log.v("Listened to ${supportedExplorers.length} supportedExplorers");
        log.v(
            "Listened to ${supportedExplorerStats.length} supportedExplorerStats");
      });
    } else {
      log.w("Already listening to list of explorers");
      completer.complete();
    }

    if (_currentUserStreamSubscription == null) {
      Stream<User> userStream =
          _firestoreApi.getUserStream(uid: currentUser.uid);
      _currentUserStreamSubscription = userStream.listen((user) async {
        _currentUser = user;
        if (callback != null) {
          callback();
        }
      });
    } else {
      log.w("Already listening to current User document");
    }

    if (_currentUserStatsStreamSubscription == null) {
      Stream<UserStatistics> userStream =
          _firestoreApi.getUserSummaryStatisticsStream(uid: currentUser.uid);
      _currentUserStatsStreamSubscription = userStream.listen((stats) async {
        _currentUserStats = stats;
        if (callback != null) {
          callback();
        }
      });
    } else {
      log.w("Already listening to current User document");
    }
  }

  // listens to the user document as well as the user stats document
  // of all explorers.
  Future<void> addExplorerStatsListeners(
      {required List<String> explorerIds, void Function()? callback}) async {
    Completer<void> completer = Completer();
    int i = 0;
    if (explorerIds.length == 0) {
      completer.complete();
      return completer.future;
    }
    explorerIds.forEach((explorerId) async {
      await addExplorerStatListener(explorerId: explorerId, callback: callback);
      i += 1;
      if (i == explorerIds.length) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });
    return completer.future;
  }

  Future addExplorerStatListener(
      {required String explorerId, void Function()? callback}) async {
    Completer<void> completer = Completer();
    if (!_explorerStatsStreamSubscriptions.containsKey(explorerId) ||
        _explorerStatsStreamSubscriptions[explorerId] == null) {
      _explorerStatsStreamSubscriptions[explorerId] = _firestoreApi
          .getUserSummaryStatisticsStream(uid: explorerId)
          .listen((stats) {
        supportedExplorerStats[explorerId] = stats;
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
      });
    } else {
      log.w("Stats stream of user with id $explorerId already listened to!");
      completer.complete();
    }
    return completer.future;
  }

  //////////////////////////////////////////
  /// Some smaller helper functions

  void removeFromExplorerLists({required String uid}) {
    supportedExplorers.remove(uid);
    supportedExplorerStats.remove(uid);
    cancelExplorerStatsListener(uid: uid);
  }

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

  // pause the listener
  void cancelExplorerStatsListener({required String uid}) {
    log.v("Cancel transfer data listener with config: '$uid'");
    _explorerStatsStreamSubscriptions[uid]?.cancel();
    _explorerStatsStreamSubscriptions[uid] = null;
  }

  // clear all data when user logs out!
  Future handleLogoutEvent() async {
    // remove uid from local storage
    await _localStorageService.deleteFromDisk(key: kLocalStorageUidKey);

    // set current user to null
    _currentUser = null;
    _currentUserStats = null;

    // remove user listeners
    _currentUserStreamSubscription?.cancel();
    _currentUserStreamSubscription = null;
    _currentUserStatsStreamSubscription?.cancel();
    _currentUserStatsStreamSubscription = null;

    _explorerStatsStreamSubscriptions.forEach((key, value) {
      cancelExplorerStatsListener(uid: key);
    });
    _explorersDataStreamSubscriptions?.cancel();
    log.wtf("Setting list of explorers stream subscription to null!");
    _explorersDataStreamSubscriptions = null;

    supportedExplorers = {};
    supportedExplorerStats = {};

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
