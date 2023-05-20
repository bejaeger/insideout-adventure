import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/guardian_reference/guardian_reference.dart';
import 'package:afkcredits/datamodels/users/settings/user_settings.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/notifications/notifications_service.dart';
import 'package:afkcredits/services/local_secure_storage_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import 'afkcredits_authentication_result_service.dart';

class UserService {
  final _firestoreApi = locator<FirestoreApi>();
  final FirebaseAuthenticationService _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  final LocalSecureStorageService _localStorageService =
      locator<LocalSecureStorageService>();
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final NotificationsService _notificationsService =
      locator<NotificationsService>();
  final log = getLogger('UserService');

  User? get currentUserNullable => _currentUser;
  User get currentUser => _currentUser!;
  UserSettings get currentUserSettings =>
      currentUserNullable?.userSettings ?? UserSettings();
  UserStatistics get currentUserStats => _currentUserStats!;
  UserStatistics? get currentUserStatsNullable => _currentUserStats;
  bool get hasLoggedInUser => _firebaseAuthenticationService.hasUser;
  UserRole get getUserRole => currentUser.role;
  bool get isSuperUser => currentUser.role == UserRole.superUser;
  bool get isAdminUser => currentUser.role == UserRole.admin;
  bool get hasRole => currentUserNullable == null ? false : true;
  List<User> get supportedWardsList {
    List<User> list = [];
    supportedWards.forEach((key, value) {
      list.add(value);
    });
    return list;
  }

  User? _currentUser;
  UserStatistics? _currentUserStats;
  StreamSubscription? _currentUserStreamSubscription;
  StreamSubscription? _currentUserStatsStreamSubscription;
  GuardianReference? guardianReference;
  Map<String, User> supportedWards = {};
  Map<String, UserStatistics> supportedWardStats = {};
  // we add the quest history to the user service (THIS IS NOT IDEAL!)
  Map<String, List<ActivatedQuest>> supportedWardQuestsHistory = {};
  StreamSubscription? _wardsDataStreamSubscriptions;
  Map<String, StreamSubscription?> _wardStatsStreamSubscriptions = {};
  Map<String, StreamSubscription?> _wardHistoryStreamSubscriptions = {};
  Map<String, StreamSubscription?> _wardScreenTimeStreamSubscriptions = {};

  Future<void> syncUserAccount(
      {String? uid, bool fromLocalStorage = false, UserRole? role}) async {
    var userAccount;
    final actualUid =
        uid ?? _firebaseAuthenticationService.firebaseAuth.currentUser!.uid;

    log.v('Sync user $actualUid');
    userAccount = await _firestoreApi.getUser(uid: actualUid);

    if (userAccount != null) {
      log.v('User account exists. Save as _currentUser');

      _currentUser = userAccount!;

      _notificationsService.pushToken(
          uid: _currentUser!.uid, tokens: _currentUser!.tokens);
      maybeUpdateDeviceId(onlineDeviceId: _currentUser!.deviceId);

      if (fromLocalStorage) {
        log.v("Save current user id to disk");
        await _localStorageService.saveToDisk(
            key: kLocalStorageUidKey, value: _currentUser!.uid);
        await _localStorageService.saveRoleToDisk(
            key: kLocalStorageRoleKey, value: role);

        // ? Unclear why the following is needed.
        // Maybe if an ward logs in himself, the guardian reference
        // is loaded!
        String? id = await _localStorageService.getFromDisk(
            key: kLocalStorageGuardianReferenceKey);
        String? pin = await _localStorageService.getFromDisk(
            key: kLocalStorageGuardianPinKey);
        if (id != null) {
          guardianReference = GuardianReference(
            uid: id,
            withPasscode: pin != null,
          );
        }
      }
    } else {
      log.e("User account with id $actualUid does not exist! Can't sync user");
    }
  }

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
        wardIds: [],
        guardianIds: [],
        avatarIdx: 1,
        userSettings: UserSettings(),
      ),
    );
  }

  Future<User> createUserAccount({required User user}) async {
    try {
      log.v("Creating user account");
      List<String> keywords = getListOfKeywordsFromString(user.fullName);
      User newUser = user.copyWith(fullNameSearch: keywords);
      UserStatistics stats = getEmptyUserStatistics(uid: newUser.uid);
      await _firestoreApi.createUser(user: newUser, stats: stats);
      return newUser;
    } catch (e) {
      log.e(e);
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

  Future<AFKCreditsAuthenticationResultService> runLoginLogic(
      {required AuthenticationMethod method,
      String? emailOrName,
      String? stringPw,
      String? hashedPw,
      UserRole? role}) async {
    if (method == AuthenticationMethod.EmailOrGuardianCreatedWard) {
      log.i("Login with email or guardian created ward");
      // check whether account exists with emailOrName as name.
      // In that case we are dealing with an ward account
      // created by a guardian in the app. This account does
      // not have authentication set up but has a reference to the
      // guardian account with the createdByUserWithId field.
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
          // if user is not created by another user we talk about an ward with an own account
          // authenticate him with email
          log.i("User is NOT created by guardian, ward has its own account.");
          return await runLoginLogic(
              method: AuthenticationMethod.email,
              emailOrName: user.email,
              stringPw: stringPw,
              role: role);
        } else {
          // user is created by guardian
          if (user.password == null) {
            // something really bad happened
            log.wtf(
                "Should never end up here: This is because no password of ward was found.");
            return Future.value(AFKCreditsAuthenticationResultService.error(
                errorMessage:
                    "No permissions to login to user with name or email '$emailOrName'."));
          }
          if (isMatchingPasswords(
              hashedPw1: user.password,
              stringPw2: stringPw,
              hashedPw2: hashedPw)) {
            log.i(
                "Found AFK user that was created by a guardian inside the app");
            return AFKCreditsAuthenticationResultService.fromLocalStorage(
                uid: user.uid);
          } else {
            log.i(
                "Found AFK user that was created by a guardian inside the app but password is not valid!");
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
            .loginWithEmail(email: emailOrName!, password: stringPw!),
      );
    } else if (method == AuthenticationMethod.google) {
      log.i("Login with google");
      return AFKCreditsAuthenticationResultService
          .fromFirebaseAuthenticationResult(
        firebaseAuthenticationResult:
            await _firebaseAuthenticationService.signInWithGoogle(),
      );
    } else if (method == AuthenticationMethod.apple) {
      log.i("Login with apple");
      return AFKCreditsAuthenticationResultService
          .fromFirebaseAuthenticationResult(
        firebaseAuthenticationResult:
            await _firebaseAuthenticationService.signInWithApple(
          appleClientId: kAppleClientId,
          appleRedirectUri: kAppleRedirectUri,
        ),
      );
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
              "The authentication method you tried to use is not available."));
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
            wardIds: [],
            guardianIds: [],
            avatarIdx: 1,
            userSettings: UserSettings(),
          ),
        );
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

  bool isSupportedWard({required String uid}) {
    List<String> wardIds = currentUser.wardIds;
    return wardIds.contains(uid);
  }

  Future createWardAccount(
      {required String name,
      required String password,
      required AuthenticationMethod authMethod,
      required UserSettings userSettings}) async {
    if (await isUserAlreadyPresent(name: name)) {
      return "User with name $name already present. Please choose a different name.";
    }

    final docRef = _firestoreApi.createUserDocument();
    final newWard = User(
      authMethod: authMethod,
      fullName: name,
      password: hashPassword(password),
      uid: docRef.id,
      role: UserRole.ward,
      guardianIds: [currentUser.uid],
      createdByUserWithId: currentUser.uid,
      wardIds: [],
      newUser: true,
      deviceId: currentUser.deviceId,
      tokens: currentUser.tokens,
      avatarIdx: 1,
      userSettings: userSettings,
    );
    await createUserAccount(user: newWard);
    List<String> newWardIds = addToSupportedWardsList(uid: docRef.id);
    await updateUserData(user: currentUser.copyWith(wardIds: newWardIds));
  }

  Future removeWardFromSupportedWards({required String uid}) async {
    try {
      if (!currentUser.wardIds.contains(uid)) {
        return "Ward not supported";
      } else {
        log.i("Removing ward with id $uid from list of wards");
        List<String> newWardIds = removeFromWardLists(uid: uid);
        await Future.wait([
          updateUserData(user: currentUser.copyWith(wardIds: newWardIds)),
          removeGuardianIdFromOtherUser(
              otherUsersId: uid, guardianId: currentUser.uid),
        ]);
      }
    } catch (e) {
      log.e("Error when trying to add new ward to list of supported wards");
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
  /// 3. ward user data
  ///    -> handled with a query snapshot to look for all users that
  ///       have the currentUser's id in the guardianIds arraay
  ///
  /// 4. ward statistics documents / quest history of each ward
  ///   -> handled manually in the listener of 3. by adding and removing
  ///      listeneres to the summary stats documents whenever the ward
  ///      changes
  ///

  void setupUserDataListeners(
      {required Completer<void> completer,
      void Function()? callback,
      void Function()? screenTimeRequestDialogCallback}) async {
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

    // set up listener for ward user data
    if (_wardsDataStreamSubscriptions == null) {
      _wardsDataStreamSubscriptions =
          _firestoreApi.getWardsDataStream(uid: currentUser.uid).listen(
        (users) async {
          // remove wards if not present anymore
          List<String> newUids = users.map((e) => e.uid).toList();
          List<String> currentUids =
              supportedWardsList.map((e) => e.uid).toList();
          currentUids.forEach(
            (element) {
              if (!newUids.contains(element)) {
                removeFromWardLists(uid: element);
              }
            },
          );
          // update existing wards
          users.forEach(
            (user) {
              supportedWards[user.uid] = user;
            },
          );

          // adds listener to stats document and quest history of each ward
          await addWardListeners(
              wardIds: newUids,
              callback: callback,
              screenTimeRequestDialogCallback: screenTimeRequestDialogCallback);

          if (!completer.isCompleted) {
            completer.complete();
          }
          if (callback != null) {
            callback();
          }
          log.v("Listened to ${supportedWards.length} supportedWards");
          log.v("Listened to ${supportedWardStats.length} supportedWardStats");
        },
      );
    } else {
      log.w("Already listening to list of wards");
      completer.complete();
    }
  }

  // listens to the user document as well as the user stats document
  // of all wards.
  Future<void> addWardListeners(
      {required List<String> wardIds,
      void Function()? callback,
      void Function()? screenTimeRequestDialogCallback}) async {
    Completer<void> completer = Completer();
    int i = 0;
    if (wardIds.length == 0) {
      completer.complete();
      return completer.future;
    }
    wardIds.forEach((wardId) async {
      await addWardStatListener(wardId: wardId, callback: callback);
      await addWardHistoryListener(wardId: wardId, callback: callback);
      await addWardScreenTimeListener(
          wardId: wardId,
          callback: callback,
          screenTimeRequestDialogCallback: screenTimeRequestDialogCallback);
      i += 1;
      if (i == wardIds.length) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });
    return completer.future;
  }

  Future addWardStatListener(
      {required String wardId, void Function()? callback}) async {
    Completer<void> completer = Completer();
    if (!_wardStatsStreamSubscriptions.containsKey(wardId) ||
        _wardStatsStreamSubscriptions[wardId] == null) {
      _wardStatsStreamSubscriptions[wardId] = _firestoreApi
          .getUserSummaryStatisticsStream(uid: wardId)
          .listen((stats) {
        supportedWardStats[wardId] = stats;
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
      });
    } else {
      log.w("Stats stream of user with id $wardId already listened to!");
      completer.complete();
    }
    return completer.future;
  }

  Future addWardHistoryListener(
      {required String wardId, void Function()? callback}) async {
    Completer<void> completer = Completer();
    if (!_wardHistoryStreamSubscriptions.containsKey(wardId) ||
        _wardHistoryStreamSubscriptions[wardId] == null) {
      _wardHistoryStreamSubscriptions[wardId] =
          _firestoreApi.getPastQuestsStream(uid: wardId).listen((snapshot) {
        supportedWardQuestsHistory[wardId] = snapshot
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
          "Quest history stream of user with id $wardId already listened to!");
      completer.complete();
    }
    return completer.future;
  }

  Future addWardScreenTimeListener(
      {required String wardId,
      void Function()? callback,
      void Function()? screenTimeRequestDialogCallback}) async {
    Completer<void> completer = Completer();
    if (!_wardScreenTimeStreamSubscriptions.containsKey(wardId) ||
        _wardScreenTimeStreamSubscriptions[wardId] == null) {
      _wardScreenTimeStreamSubscriptions[wardId] =
          _firestoreApi.getScreenTimeSessionStream(uid: wardId).listen(
        (snapshot) async {
          _screenTimeService.supportedWardScreenTimeSessions[wardId] = snapshot;

          // Need to remove active screen time here when it
          // is stopped on another phone!
          List<ScreenTimeSession> completedOrCancelled = snapshot
              .where((element) =>
                  (element.status == ScreenTimeSessionStatus.completed) ||
                  (element.status == ScreenTimeSessionStatus.cancelled))
              .toList();
          if (completedOrCancelled.any((element) =>
              element.sessionId ==
              _screenTimeService
                  .supportedWardScreenTimeSessionsActive[wardId]?.sessionId)) {
            // this means an active screen time session was stopped manually!
            _screenTimeService.cancelActiveScreenTimeListeners(uid: wardId);
            log.v("Cancelling screen time event for ward with id $wardId");
            if (callback != null) {
              callback();
            }
          }
          log.v(
              "Listened to new screen time session event fired from firestore listener.");

          // potentially add to active screen time map
          ScreenTimeSession? prevActiveSessions =
              _screenTimeService.supportedWardScreenTimeSessionsActive[wardId];

          // Check for any active screen times!
          try {
            ScreenTimeSession session = snapshot.firstWhere(
                (element) => element.status == ScreenTimeSessionStatus.active);
            _screenTimeService.supportedWardScreenTimeSessionsActive[wardId] =
                session;
            // there is an active session for ward with id wardId
            // need to start local screen time listeners if they are not yet started!
            await _screenTimeService
                .continueOrBookkeepScreenTimeSessionOnStartup(
              session: session,
              callback: () {
                if (callback != null) {
                  callback();
                }
              },
            );
          } catch (e) {
            if (e is StateError) {
              log.v("No active screen time for ward with id $wardId");
              if (prevActiveSessions != null) {
                // THIS means a screen time session was cancelled prematurely after X
                // seconds (30 seconds per default) and was deleted from firestore!
                // See stopScreenTime function in screen_time_service.dart
                _screenTimeService.cancelActiveScreenTimeListeners(uid: wardId);
                log.v(
                    "Cancelling screen time event because it was deleted for ward with id $wardId");
                if (callback != null) {
                  callback();
                }
              }
              // since there is no active session we should not forget to remove it from the state!
              _screenTimeService.supportedWardScreenTimeSessionsActive
                  .remove(wardId);
            } else {
              rethrow;
            }
          }

          try {
            ScreenTimeSession session = snapshot.firstWhere((element) =>
                element.status == ScreenTimeSessionStatus.requested);
            _screenTimeService
                .supportedWardScreenTimeSessionsRequested[wardId] = session;
            if (screenTimeRequestDialogCallback != null) {
              screenTimeRequestDialogCallback();
            }
          } catch (e) {
            if (e is StateError) {
              log.v(
                  "No requested screen time for ward with id $wardId anymore");
              _screenTimeService.supportedWardScreenTimeSessionsRequested
                  .remove(wardId);
            }
          }

          if (!completer.isCompleted) {
            completer.complete();
          }
          if (callback != null) {
            callback();
          }
        },
      );
    } else {
      log.w(
          "Screen time session stream of user with id $wardId already listened to!");
      completer.complete();
    }
    return completer.future;
  }

  dynamic getAfkCreditsBalance({String? childId}) {
    if (childId == null) {
      return currentUserStats.afkCreditsBalance;
    } else {
      return supportedWardStats[childId]!.afkCreditsBalance;
    }
  }

  int getTotalAvailableScreenTime({String? childId}) {
    return convertCreditsToScreenTime(
        credits: getAfkCreditsBalance(childId: childId));
  }

  int convertCreditsToScreenTime({required num credits}) {
    double screenTimeFactor = 1;
    return (credits * screenTimeFactor).toInt();
  }

  Future validateGuardianPin({required String pin}) async {
    final hashedPin = await _localStorageService.getFromDisk(
        key: kLocalStorageGuardianPinKey);
    return isMatchingPasswords(hashedPw1: hashedPin, stringPw2: pin);
  }

  Future saveGuardianReference(
      {required String uid,
      AuthenticationMethod? authMethod,
      String? pin}) async {
    if (pin != null) {
      await _localStorageService.saveToDisk(
          key: kLocalStorageGuardianPinKey, value: hashPassword(pin));
    }
    await _localStorageService.saveToDisk(
        key: kLocalStorageGuardianReferenceKey, value: uid);
    guardianReference = GuardianReference(
        uid: uid,
        authMethod: authMethod,
        withPasscode: pin != null,
        deviceId: currentUser.deviceId);
  }

  Future clearGuardianReference() async {
    log.v("Clearing guardian reference from local disk");
    await _localStorageService.deleteFromDisk(key: kLocalStorageGuardianPinKey);
    await _localStorageService.deleteFromDisk(
        key: kLocalStorageGuardianReferenceKey);
    guardianReference = null;
  }

  Future maybeUpdateDeviceId({required String? onlineDeviceId}) async {
    // we update the device id in the database in case it is different
    // We want to keep track of this to decide on which and if we should
    // show push notifications for the screen time feature
    String currentDeviceId = await _getDeviceId();
    if (onlineDeviceId != currentDeviceId) {
      _firestoreApi.updateDeviceId(
          uid: currentUser.uid, deviceId: currentDeviceId);
    }
  }

  Future _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) return;
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  List<ActivatedQuest> sortedChildQuestHistory({String? uid}) {
    List<ActivatedQuest> sortedQuests = [];
    if (uid == null) {
      supportedWardQuestsHistory.forEach((key, quests) {
        sortedQuests.addAll(quests);
      });
    } else {
      if (supportedWardQuestsHistory.containsKey(uid)) {
        sortedQuests = supportedWardQuestsHistory[uid]!;
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
      _screenTimeService.supportedWardScreenTimeSessions.forEach((key, quests) {
        sortedSessions.addAll(quests);
      });
    } else {
      if (supportedWardQuestsHistory.containsKey(uid)) {
        sortedSessions =
            _screenTimeService.supportedWardScreenTimeSessions[uid]!;
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
      if (_screenTimeService.supportedWardScreenTimeSessions.containsKey(uid)) {
        list = list + sortedChildScreenTimeSessions(uid: uid);
      }
      if (supportedWardQuestsHistory.containsKey(uid)) {
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

    _screenTimeService.supportedWardScreenTimeSessions.forEach((key, session) {
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
    supportedWardQuestsHistory.forEach((key, session) {
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

  String wardNameFromUid(String uid) {
    for (User user in supportedWardsList) {
      if (user.uid == uid) {
        return user.fullName;
      }
    }
    return "";
  }

  bool hasGuardian({required String uid}) {
    return supportedWardsList.any((element) => element.uid == uid);
  }

  bool hasCompletedQuest({required String? questId}) {
    if (questId == null) return false;
    return currentUserStats.completedQuestIds.contains(questId);
  }

  Future setNewUserPropertyToFalse({required User user}) async {
    User newUser = user.copyWith(newUser: false);
    _firestoreApi.updateUserData(user: newUser);
  }

  Future setNewAvatarId({required int id, required User user}) async {
    User newUser = user.copyWith(avatarIdx: id);
    await _firestoreApi.updateUserData(user: newUser);
  }

  List<String> removeFromWardLists({required String uid}) {
    supportedWards.remove(uid);
    supportedWardStats.remove(uid);
    cancelWardListener(uid: uid);
    List<String> newWardIds = [];
    supportedWards.forEach((key, value) {
      newWardIds.add(value.uid);
    });
    return newWardIds;
  }

  List<String> addToSupportedWardsList({required String uid}) {
    List<String> newWardIds = [];
    newWardIds.addAll(currentUser.wardIds);
    newWardIds.add(uid);
    return newWardIds;
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

  bool get isShowingCompletedQuests =>
      currentUserSettings.isShowingCompletedQuests;
  Future setIsShowingCompletedQuests({required bool value}) async {
    updateUserData(
      user: currentUser.copyWith(
        userSettings:
            currentUserSettings.copyWith(isShowingCompletedQuests: value),
      ),
    );
  }

  bool get isUsingAR => currentUserSettings.isUsingAR;
  Future setIsUsingAr({required bool value}) async {
    updateUserData(
      user: currentUser.copyWith(
        userSettings: currentUserSettings.copyWith(isUsingAR: value),
      ),
    );
  }

  // On older phones the lottie effects lead to huge lags.
  // This provides an option to avoid showing the lottie effects!
  bool get isShowAvatarAndMapEffects =>
      currentUserSettings.isShowAvatarAndMapEffects;
  Future setIsShowingAvatarAndMapEffects({required bool value}) async {
    updateUserData(
      user: currentUser.copyWith(
        userSettings:
            currentUserSettings.copyWith(isShowAvatarAndMapEffects: value),
      ),
    );
  }

  // USED to make settings from guardian account to user account
  bool get isAcceptScreenTimeFirst =>
      currentUserSettings.isAcceptScreenTimeFirst;
  Future setIsAcceptScreenTimeFirst(
      {required String uid, required bool value}) async {
    // This is a bit critical: Check UserSettings class if the key is correct
    await _firestoreApi.updateUserSettings(
        uid: uid, key: "isAcceptScreenTimeFirst", value: value);
  }

  // USED to make settings from guardian account to user account
  bool get isUsingOwnPhone => currentUserSettings.ownPhone;
  Future setIsUsingOwnPhone({required String uid, required bool value}) async {
    // This is a bit critical: Check UserSettings class if the key is correct
    await _firestoreApi.updateUserSettings(
        uid: uid, key: "ownPhone", value: value);
  }

  Future updateUserData({required User user}) async {
    _currentUser = user;
    _firestoreApi.updateUserData(user: user);
  }

  Future removeGuardianIdFromOtherUser(
      {required String otherUsersId, required String guardianId}) async {
    _firestoreApi.removeGuardianIdFromUser(
        uid: otherUsersId, guardianId: guardianId);
  }

  Future isUserAlreadyPresent({required name}) async {
    final uid = await _firestoreApi.getUserWithName(name: name);
    return uid != null;
  }

  void cancelWardListener({required String uid}) {
    log.v("Cancel transfer data listener with config: '$uid'");
    _wardStatsStreamSubscriptions[uid]?.cancel();
    _wardStatsStreamSubscriptions[uid] = null;
    _wardHistoryStreamSubscriptions[uid]?.cancel();
    _wardHistoryStreamSubscriptions[uid] = null;
    _wardScreenTimeStreamSubscriptions[uid]?.cancel();
    _wardScreenTimeStreamSubscriptions[uid] = null;
  }

  Future handleLogoutEvent(
      {bool logOutFromFirebase = true,
      bool doNotClearGuardianReference = false}) async {
    if (!kIsWeb) {
      await _localStorageService.deleteFromDisk(key: kLocalStorageUidKey);
    }
    _currentUser = null;
    _currentUserStats = null;

    _currentUserStreamSubscription?.cancel();
    _currentUserStreamSubscription = null;
    _currentUserStatsStreamSubscription?.cancel();
    _currentUserStatsStreamSubscription = null;

    _wardStatsStreamSubscriptions.forEach((key, value) {
      cancelWardListener(uid: key);
    });
    _wardHistoryStreamSubscriptions.forEach((key, value) {
      cancelWardListener(uid: key);
    });
    _wardScreenTimeStreamSubscriptions.forEach((key, value) {
      cancelWardListener(uid: key);
    });
    _wardsDataStreamSubscriptions?.cancel();
    _wardsDataStreamSubscriptions = null;

    supportedWards = {};
    supportedWardStats = {};

    if (!doNotClearGuardianReference) clearGuardianReference();

    if (logOutFromFirebase) {
      await _firebaseAuthenticationService.logout();
    }
  }
}
