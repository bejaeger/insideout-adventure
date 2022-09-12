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
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/admin/user_admin.dart';
import 'package:afkcredits/datamodels/users/favorite_places/user_fav_places.dart';
import 'package:afkcredits/datamodels/users/sponsor_reference/sponsor_reference.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'afkcredits_authentication_result_service.dart'; // for the utf8.encode method

class UserService {
  // -----------------------------------
  // services
  final _firestoreApi = locator<FirestoreApi>();
  final FirebaseAuthenticationService _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final log = getLogger('UserService');

  // ---------------------------------------
  // state / member variables and exposed objects
  User? _currentUser;
  UserAdmin? _currentUserAdmin;
  User? get currentUserNullable => _currentUser;
  User get currentUser => _currentUser!;
  UserStatistics? _currentUserStats;
  UserStatistics get currentUserStats => _currentUserStats!;
  StreamSubscription? _currentUserStreamSubscription;
  StreamSubscription? _currentUserStatsStreamSubscription;

  UserAdmin? get getCurrentUserAdmin => _currentUserAdmin!;
  SponsorReference? sponsorReference;

  bool get hasLoggedInUser => _firebaseAuthenticationService.hasUser;

  UserRole get getUserRole => currentUser.role;
  bool get isSuperUser => currentUser.role == UserRole.superUser;
  bool get isAdminMaster => currentUser.role == UserRole.adminMaster;
  bool get hasRole => currentUserNullable == null ? false : true;

  // state
  // store list of supportedExplorers
  // map of list of money pools with money Pool id as key
  Map<String, User> supportedExplorers = {};
  Map<String, UserStatistics> supportedExplorerStats = {};

  // quest history is added to user service (NOT IDEAL!)
  Map<String, List<ActivatedQuest>> supportedExplorerQuestsHistory = {};

  // quest history is added to user service (NOT IDEAL! cause we have a quest service)
  Map<String, List<ScreenTimeSession>> supportedExplorerScreenTimeSessions = {};
  List<ScreenTimeSession> supportedExplorerScreenTimeSessionsActive = [];

  StreamSubscription? _explorersDataStreamSubscriptions;
  List<User> get supportedExplorersList {
    List<User> list = [];
    supportedExplorers.forEach((key, value) {
      list.add(value);
    });
    return list;
  }

  Map<String, StreamSubscription?> _explorerStatsStreamSubscriptions = {};
  Map<String, StreamSubscription?> _explorerHistoryStreamSubscriptions = {};
  Map<String, StreamSubscription?> _explorerScreenTimeStreamSubscriptions = {};

  Future<void> syncUserAccount(
      {String? uid, bool fromLocalStorage = false, UserRole? role}) async {
    var userAccount;
    final actualUid =
        uid ?? _firebaseAuthenticationService.firebaseAuth.currentUser!.uid;

    log.v('Sync user $actualUid');
    // if (role == UserRole.adminMaster) {
    //   userAccount = await _firestoreApi.getUserAdmin(uid: actualUid);
    // } else {
    userAccount = await _firestoreApi.getUser(uid: actualUid);
    // }

    if (userAccount != null) {
      log.v('User account exists. Save as _currentUser');
      // if (UserRole.adminMaster == role) {
      //   _currentUserAdmin = userAccount;
      // } else {
      _currentUser = userAccount;
      // }
      if (fromLocalStorage) {
        log.v("Save current user id to disk");
        await _localStorageService.saveToDisk(
            key: kLocalStorageUidKey, value: userAccount.uid);
        await _localStorageService.saveRoleToDisk(
            key: kLocalStorageRoleKey, value: role);

        String? id = await _localStorageService.getFromDisk(
            key: kLocalStorageSponsorReferenceKey);
        String? pin = await _localStorageService.getFromDisk(
            key: kLocalStorageSponsorPinKey);
        if (id != null) {
          sponsorReference =
              SponsorReference(uid: id, withPasscode: pin != null);
        }
      }
    } else {
      log.e("User account with id $actualUid does not exist! Can't sync user");
    }
  }

  Future<void> syncOrCreateUserAdminAccount(
      {required UserAdmin userAdmin,
      required AuthenticationMethod method,
      bool fromLocalStorate = false}) async {
    // create a new user profile on firestore
    log.i("user created by Harguilar: $userAdmin");
    await syncUserAccount(
        fromLocalStorage: fromLocalStorate, role: userAdmin.role);
    try {
      if (_currentUserAdmin == null) {
        await _firestoreApi.createUserAdmin(userAdmin: userAdmin);
        _currentUserAdmin = userAdmin;
        log.v('User Information Has Been Saved $_currentUserAdmin');
      }
      //return await _firestoreApi.createUserAdmin(userAdmin: userAdmin);
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

//BackOffice Ends Here.

  Future<User> createUserAccountFromFirebaseUser(
      {required UserRole role,
      required AuthenticationMethod authMethod}) async {
    final user = _firebaseAuthenticationService.firebaseAuth.currentUser!;
    return await createUserAccount(
        user: User(
      authMethod: authMethod,
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

  Future<void> createUserFavouritePlaces(
      {required String userId, required UserFavPlaces favouritePlaces}) async {
    await _firestoreApi.createUserFavouritePlaces(
        userId: userId, favouritePlaces: favouritePlaces);
  }

//Get User Favourite Places
  Future<List<UserFavPlaces>?> getUserFavouritePlaces(
      {required String userId}) async {
    return await _firestoreApi.getUserFavouritePlaces(userId: userId);
  }

  Future<String?> getLocallyLoggedInUserId() async {
    final id = await _localStorageService.getFromDisk(key: kLocalStorageUidKey);
    return id;
  }

  Future<UserRole?> getLocallyLoggedUserRole() async {
    final id =
        await _localStorageService.getFromDisk(key: kLocalStorageRoleKey);
    return id;
  }

  Future<AFKCreditsAuthenticationResultService> runLoginLogic(
      {required AuthenticationMethod method,
      String? emailOrName,
      String? stringPw,
      String? hashedPw,
      UserRole? role}) async {
    if (method == AuthenticationMethod.EmailOrSponsorCreatedExplorer) {
      log.i("Login with email or sponsor created explorer");
      // check whether account exists with emailOrName as name.
      // In that case we are dealing with an explorer account
      // created by a sponsor in the app. This account does
      // not have authentication set up but has a reference to the
      // sponsor account with the createdByUserWithId field.
      // We just return the id of that user here.
      final user = await _firestoreApi.getUserWithName(name: emailOrName);
      if (user == null) {
        // if no user is present it's probably the first time someone is logging in.
        // login with standard email flow
        log.i("User is null, running standard email login logic");
        return await runLoginLogic(
            method: AuthenticationMethod.email,
            emailOrName: emailOrName,
            stringPw: stringPw,
            role: role);
      } else {
        if (user.createdByUserWithId == null) {
          // if user is not created by another user we talk about an explorer with an own account
          // authenticate him with email
          log.i(
              "User is NOT created by sponsor, running standard email login logic");
          return await runLoginLogic(
              method: AuthenticationMethod.email,
              emailOrName: user.email,
              stringPw: stringPw,
              role: role);
        } else {
          // user is created by sponsor
          if (user.password == null) {
            // something really bad happened
            log.wtf(
                "Should never end up here: This is because no password of explorer was found.");
            return Future.value(AFKCreditsAuthenticationResultService.error(
                errorMessage:
                    "No permissions to login to user with name or email '$emailOrName'."));
          }
          if (isMatchingPasswords(
              hashedPw1: user.password,
              stringPw2: stringPw,
              hashedPw2: hashedPw)) {
            // && password == user.password) {
            log.i(
                "Found AFK user that was created by a sponsor inside the app");
            return AFKCreditsAuthenticationResultService.fromLocalStorage(
                uid: user.uid);
          } else {
            log.i(
                "Found AFK user that was created by a sponsor inside the app but password is not valid!");
            return Future.value(AFKCreditsAuthenticationResultService.error(
                errorMessage:
                    "Password for user with name $emailOrName is not correct."));
          }
        }
      }
    } else if (method == AuthenticationMethod.email) {
      log.i("Login with e-mail");
      return AFKCreditsAuthenticationResultService
          .fromFirebaseAuthenticationResult(
              firebaseAuthenticationResult: await _firebaseAuthenticationService
                  .loginWithEmail(email: emailOrName!, password: stringPw!));
    } else if (method == AuthenticationMethod.google) {
      log.i("Login with google");
      return AFKCreditsAuthenticationResultService
          .fromFirebaseAuthenticationResult(
              firebaseAuthenticationResult:
                  await _firebaseAuthenticationService.signInWithGoogle());
    } else if (method == AuthenticationMethod.dummy) {
      return AFKCreditsAuthenticationResultService
          .fromFirebaseAuthenticationResult(
              firebaseAuthenticationResult:
                  await _firebaseAuthenticationService.loginWithEmail(
                      email: _flavorConfigProvider.getTestUserEmail(role),
                      password: _flavorConfigProvider.getTestUserPassword()));
    } else {
      log.e(
          "The authentication method you tried to use is not implemented yet. Use E-mail, Google, or Apple to authenticate");
      return Future.value(AFKCreditsAuthenticationResultService.error(
          errorMessage:
              "Authentification method you try to use is not available."));
    }
  }

  Future<AFKCreditsAuthenticationResultService> runCreateAccountLogic(
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
      return AFKCreditsAuthenticationResultService.error(
          errorMessage: "Authentication method not valid!");
    }
    if (result.hasError) {
      return AFKCreditsAuthenticationResultService.error(
          errorMessage: result.errorMessage);
    } else {
      // create user in data bank
      try {
        final user = result.user!;
        await createUserAccount(
            user: User(
          authMethod: method,
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
          return AFKCreditsAuthenticationResultService.error(
              errorMessage: e.prettyDetails ??
                  "Something went wrong when creating a new user in our databank. Please try again later or contact support!");
        } else {
          return AFKCreditsAuthenticationResultService.error(
              errorMessage:
                  "Something went wrong when creating a new user in our databank. Please try again later or contact support!");
        }
      }
      return AFKCreditsAuthenticationResultService.authenticatedUser(
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
      {required String name,
      required String password,
      required AuthenticationMethod authMethod}) async {
    if (await isUserAlreadyPresent(name: name)) {
      return "User with name $name already present. Please choose a different name.";
    }

    final docRef = _firestoreApi.createUserDocument();
    final newExplorer = User(
      authMethod: authMethod,
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

  Future removeExplorerFromSupportedExplorers({required String uid}) async {
    try {
      if (!currentUser.explorerIds.contains(uid)) {
        return "Explorer not supported";
      } else {
        log.i("Removing explorer with id $uid from list of explorers");
        List<String> newExplorerIds = removeFromExplorerLists(uid: uid);
        // Ideal way would be to add a transaction here!
        await Future.wait([
          updateUserData(
              user: currentUser.copyWith(explorerIds: newExplorerIds)),
          removeSponsorIdFromOtherUser(
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
  /// 4. explorer statistics documents / quest history of each explorer
  ///   -> handled manually in the listener of 3. by adding and removing
  ///      listeneres to the summary stats documents whenever the explorer
  ///      changes
  ///

  void setupUserDataListeners(
      {required Completer<void> completer, void Function()? callback}) async {
    if (_currentUserStreamSubscription == null) {
      Stream<User> userStream =
          _firestoreApi.getUserStream(uid: currentUser.uid);
      _currentUserStreamSubscription = userStream.listen(
        (user) async {
          _currentUser = user;
          if (callback != null) {
            callback();
          }
        },
      );
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

    // set up listener for explorer user data
    if (_explorersDataStreamSubscriptions == null) {
      _explorersDataStreamSubscriptions =
          _firestoreApi.getExplorersDataStream(uid: currentUser.uid).listen(
        (users) async {
          // remove explorers if not present anymore
          List<String> newUids = users.map((e) => e.uid).toList();
          List<String> currentUids =
              supportedExplorersList.map((e) => e.uid).toList();
          currentUids.forEach(
            (element) {
              if (!newUids.contains(element)) {
                removeFromExplorerLists(uid: element);
              }
            },
          );
          // update existing explorers
          users.forEach(
            (user) {
              supportedExplorers[user.uid] = user;
            },
          );

          // adds listener to stats document and quest history of each explorer
          await addExplorerListeners(explorerIds: newUids, callback: callback);

          if (!completer.isCompleted) {
            completer.complete();
          }
          if (callback != null) {
            callback();
          }
          log.v("Listened to ${supportedExplorers.length} supportedExplorers");
          log.v(
              "Listened to ${supportedExplorerStats.length} supportedExplorerStats");
        },
      );
    } else {
      log.w("Already listening to list of explorers");
      completer.complete();
    }
  }

  // listens to the user document as well as the user stats document
  // of all explorers.
  Future<void> addExplorerListeners(
      {required List<String> explorerIds, void Function()? callback}) async {
    Completer<void> completer = Completer();
    int i = 0;
    if (explorerIds.length == 0) {
      completer.complete();
      return completer.future;
    }
    explorerIds.forEach((explorerId) async {
      await addExplorerStatListener(explorerId: explorerId, callback: callback);
      await addExplorerHistoryListener(
          explorerId: explorerId, callback: callback);
      await addExplorerScreenTimeListener(
          explorerId: explorerId, callback: callback);
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

  Future addExplorerHistoryListener(
      {required String explorerId, void Function()? callback}) async {
    Completer<void> completer = Completer();
    if (!_explorerHistoryStreamSubscriptions.containsKey(explorerId) ||
        _explorerHistoryStreamSubscriptions[explorerId] == null) {
      _explorerHistoryStreamSubscriptions[explorerId] =
          _firestoreApi.getPastQuestsStream(uid: explorerId).listen((snapshot) {
        supportedExplorerQuestsHistory[explorerId] = snapshot
            .where((element) => element.status == QuestStatus.success)
            .toList();
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
      });
    } else {
      log.w(
          "Quest history stream of user with id $explorerId already listened to!");
      completer.complete();
    }
    return completer.future;
  }

  Future addExplorerScreenTimeListener(
      {required String explorerId, void Function()? callback}) async {
    Completer<void> completer = Completer();
    if (!_explorerScreenTimeStreamSubscriptions.containsKey(explorerId) ||
        _explorerScreenTimeStreamSubscriptions[explorerId] == null) {
      _explorerScreenTimeStreamSubscriptions[explorerId] = _firestoreApi
          .getScreenTimeSessionStream(uid: explorerId)
          .listen((snapshot) {
        supportedExplorerScreenTimeSessions[explorerId] = snapshot;
        supportedExplorerScreenTimeSessionsActive = snapshot
            .where(
                (element) => element.status == ScreenTimeSessionStatus.active)
            .toList();
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
      });
    } else {
      log.w(
          "Screen time session stream of user with id $explorerId already listened to!");
      completer.complete();
    }
    return completer.future;
  }

  Future validateSponsorPin({required String pin}) async {
    final hashedPin =
        await _localStorageService.getFromDisk(key: kLocalStorageSponsorPinKey);
    return isMatchingPasswords(hashedPw1: hashedPin, stringPw2: pin);
  }

  Future saveSponsorReference(
      {required String uid,
      AuthenticationMethod? authMethod,
      String? pin}) async {
    if (pin != null) {
      await _localStorageService.saveToDisk(
          key: kLocalStorageSponsorPinKey, value: hashPassword(pin));
    }
    await _localStorageService.saveToDisk(
        key: kLocalStorageSponsorReferenceKey, value: uid);
    log.wtf("PIN => $pin");
    sponsorReference = SponsorReference(
        uid: uid, authMethod: authMethod, withPasscode: pin != null);
  }

  Future clearSponsorReference() async {
    log.v("Clearing sponsor reference from local disk");
    await _localStorageService.deleteFromDisk(key: kLocalStorageSponsorPinKey);
    await _localStorageService.deleteFromDisk(
        key: kLocalStorageSponsorReferenceKey);
    sponsorReference = null;
  }

  /////////////////////////////////////////////
  /// Functions used in parents area for displaying child statistics
  ///
  List<ActivatedQuest> sortedChildQuestHistory({String? uid}) {
    // TODO: Also add screen time into the mix!
    List<ActivatedQuest> sortedQuests = [];
    if (uid == null) {
      supportedExplorerQuestsHistory.forEach((key, quests) {
        sortedQuests.addAll(quests);
      });
    } else {
      if (supportedExplorerQuestsHistory.containsKey(uid)) {
        sortedQuests = supportedExplorerQuestsHistory[uid]!;
      }
    }
    sortedQuests.sort((a, b) {
      if (b.createdAt is String) {
        return -1;
      }
      if (a.createdAt is String) {
        return -1;
      }
      return b.createdAt.toDate().compareTo(a.createdAt.toDate());
    });
    return sortedQuests;
  }

  List<ScreenTimeSession> sortedChildScreenTimeSessions({String? uid}) {
    List<ScreenTimeSession> sortedSessions = [];
    if (uid == null) {
      supportedExplorerScreenTimeSessions.forEach((key, quests) {
        sortedSessions.addAll(quests);
      });
    } else {
      if (supportedExplorerQuestsHistory.containsKey(uid)) {
        sortedSessions = supportedExplorerScreenTimeSessions[uid]!;
      }
    }
    sortedSessions.sort((a, b) {
      if (b.startedAt is String) {
        return -1;
      }
      if (a.startedAt is String) {
        return -1;
      }
      return b.startedAt.toDate().compareTo(a.startedAt.toDate());
    });
    return sortedSessions;
  }

  List<dynamic> sortedHistory({String? uid}) {
    List<dynamic> list = [];
    if (uid == null) {
      list = [...sortedChildScreenTimeSessions(), ...sortedChildQuestHistory()];
    } else {
      if (supportedExplorerScreenTimeSessions.containsKey(uid)) {
        list = list + sortedChildScreenTimeSessions(uid: uid);
      }
      if (supportedExplorerQuestsHistory.containsKey(uid)) {
        list = list + sortedChildQuestHistory(uid: uid);
      }
    }
    list.sort((a, b) {
      dynamic date1;
      dynamic date2;
      if (a is ActivatedQuest)
        date1 = a.createdAt;
      else
        date1 = a.startedAt;
      if (b is ActivatedQuest)
        date2 = b.createdAt;
      else
        date2 = b.startedAt;
      if (date1 is String || date2 is String) {
        return -1;
      } else {
        date1 = date1.toDate();
        date2 = date2.toDate();
      }
      return date2!.compareTo(date1!);
    });
    return list;
  }

  Map<String, int> totalChildScreenTimeLastDays(
      {int deltaDays = 7, int daysAgo = 0, String? uid}) {
    Map<String, int> screenTime = {};

    supportedExplorerScreenTimeSessions.forEach((key, session) {
      session.forEach((element) {
        if (element.startedAt is Timestamp) {
          if (DateTime.now().difference(element.startedAt.toDate()).inDays >=
                  daysAgo &&
              DateTime.now().difference(element.startedAt.toDate()).inDays <
                  daysAgo + deltaDays &&
              (uid == null || uid == key)) {
            if (screenTime.containsKey(element.uid)) {
              screenTime[element.uid] = screenTime[element.uid]! +
                  (element.minutesUsed ?? element.minutes);
            } else {
              screenTime[element.uid] =
                  (element.minutesUsed ?? element.minutes);
            }
          }
        }
      });
    });

    return screenTime;
  }

  Map<String, int> totalChildActivityLastDays(
      {int deltaDays = 7, int daysAgo = 0, String? uid}) {
    Map<String, int> activity = {};
    supportedExplorerQuestsHistory.forEach((key, session) {
      session.forEach((element) {
        if (DateTime.now().difference(element.createdAt.toDate()).inDays >=
                daysAgo &&
            DateTime.now().difference(element.createdAt.toDate()).inDays <
                daysAgo + deltaDays &&
            (uid == null || uid == key)) {
          if (activity.containsKey(element.uids![0])) {
            // still multiple uids supported
            activity[element.uids![0]] = activity[element.uids![0]]! +
                (element.timeElapsed / 60).round();
          } else {
            activity[element.uids![0]] = (element.timeElapsed / 60).round();
          }
        }
      });
    });
    return activity;
  }

  Map<String, int> totalChildScreenTimeTrend(
      {int deltaDays = 7, int daysAgo = 7, String? uid}) {
    Map<String, int> lastWeek = totalChildScreenTimeLastDays(
        deltaDays: deltaDays, daysAgo: 0, uid: uid);
    Map<String, int> previousWeek = totalChildScreenTimeLastDays(
        deltaDays: deltaDays, daysAgo: 7, uid: uid);
    Map<String, int> delta = {};
    for (String k in lastWeek.keys) {
      delta[k] = (lastWeek[k] ?? 0) - (previousWeek[k] ?? 0);
    }
    return delta;
  }

  Map<String, int> totalChildActivityTrend(
      {int deltaDays = 7, int daysAgo = 7, String? uid}) {
    Map<String, int> lastWeek =
        totalChildActivityLastDays(deltaDays: deltaDays, daysAgo: 0, uid: uid);
    Map<String, int> previousWeek =
        totalChildActivityLastDays(deltaDays: deltaDays, daysAgo: 7, uid: uid);
    Map<String, int> delta = {};
    for (String k in lastWeek.keys) {
      delta[k] = (lastWeek[k] ?? 0) - (previousWeek[k] ?? 0);
    }
    return delta;
  }

  String explorerNameFromUid(String uid) {
    for (User user in supportedExplorersList) {
      if (user.uid == uid) {
        return user.fullName;
      }
    }
    return "";
  }

  //////////////////////////////////////////
  /// Some smaller helper functions
  bool isSponsored({required String uid}) {
    return supportedExplorersList.any((element) => element.uid == uid);
  }

  List<String> removeFromExplorerLists({required String uid}) {
    supportedExplorers.remove(uid);
    supportedExplorerStats.remove(uid);
    cancelExplorerListener(uid: uid);
    List<String> newExplorerIds = [];
    supportedExplorers.forEach((key, value) {
      newExplorerIds.add(value.uid);
    });
    return newExplorerIds;
  }

  List<String> addToSupportedExplorersList({required String uid}) {
    List<String> newExplorerIds = [];
    newExplorerIds.addAll(currentUser.explorerIds);
    newExplorerIds.add(uid);
    return newExplorerIds;
  }

  bool isMatchingPasswords(
      {required String? hashedPw1, String? stringPw2, String? hashedPw2}) {
    if (hashedPw1 == null || (stringPw2 == null && hashedPw2 == null)) {
      return false;
    }
    final hash = hashedPw2 ?? hashPassword(stringPw2!);
    return hash.compareTo(hashedPw1) == 0;
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

  Future removeSponsorIdFromOtherUser(
      {required String otherUsersId, required String sponsorId}) async {
    _firestoreApi.removeSponsorIdFromUser(
        uid: otherUsersId, sponsorId: sponsorId);
  }

  Future isUserAlreadyPresent({required name}) async {
    final uid = await _firestoreApi.getUserWithName(name: name);
    return uid != null;
  }

  ///////////////////////////////////////////////////
  // Clean up

  // pause the listener
  void cancelExplorerListener({required String uid}) {
    log.v("Cancel transfer data listener with config: '$uid'");
    _explorerStatsStreamSubscriptions[uid]?.cancel();
    _explorerStatsStreamSubscriptions[uid] = null;
    _explorerHistoryStreamSubscriptions[uid]?.cancel();
    _explorerHistoryStreamSubscriptions[uid] = null;
    _explorerScreenTimeStreamSubscriptions[uid]?.cancel();
    _explorerScreenTimeStreamSubscriptions[uid] = null;
  }

  // clear all data when user logs out!
  Future handleLogoutEvent(
      {bool logOutFromFirebase = true,
      bool doNotClearSponsorReference = false}) async {
    if (!kIsWeb) {
      // remove uid from local storage
      await _localStorageService.deleteFromDisk(key: kLocalStorageUidKey);
    }
    // set current user to null
    _currentUser = null;
    _currentUserStats = null;

    // remove user listeners
    _currentUserStreamSubscription?.cancel();
    _currentUserStreamSubscription = null;
    _currentUserStatsStreamSubscription?.cancel();
    _currentUserStatsStreamSubscription = null;

    _explorerStatsStreamSubscriptions.forEach((key, value) {
      cancelExplorerListener(uid: key);
    });
    _explorerHistoryStreamSubscriptions.forEach((key, value) {
      cancelExplorerListener(uid: key);
    });
    _explorerScreenTimeStreamSubscriptions.forEach((key, value) {
      cancelExplorerListener(uid: key);
    });
    _explorersDataStreamSubscriptions?.cancel();
    _explorersDataStreamSubscriptions = null;

    supportedExplorers = {};
    supportedExplorerStats = {};

    // remove sponsor reference
    if (!doNotClearSponsorReference) clearSponsorReference();

    // actually log out from firebase
    if (logOutFromFirebase) {
      await _firebaseAuthenticationService.logout();
    }
  }
}
