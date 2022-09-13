import 'dart:async';
import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/notifications/notifications.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:rxdart/subjects.dart';

class ScreenTimeService {
  // ----------------------------
  // services
  final log = getLogger('ScreenTimeService');
  final UserService _userService = locator<UserService>();
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();

  // -----------------------------
  // Return values and state

  ScreenTimeSession? _currentSession;
  ScreenTimeSession? get currentSession => _currentSession;
  DateTime? screenTimeStartTime;
  bool get hasActiveScreenTime => screenTimeStartTime != null;
  int? screenTimeLeftInSeconds;
  bool justStartedListeningToScreenTime = false;
  // int get screenTimeLeft =>
  //     hasActiveScreenTime ? getScreenTimeLeftInMinutes() : -1;
  BehaviorSubject<int> screenTimeLeftInSecondsSubject =
      BehaviorSubject<int>.seeded(0);
  int get screenTimeLeftInSecondsListener =>
      screenTimeLeftInSecondsSubject.value;
  StreamSubscription? _screenTimeLeftInSecondsSubjectSubscription;
  int previousDiff = 0;

  // ---------------------------------
  // Functions

  // Function to convert screen time into credits
  // Might need to be more sophisticated!
  int convertCreditsToScreenTime({required num credits}) {
    double screenTimeFactor = 1;
    return (credits * screenTimeFactor).toInt();
  }

  void setupScreenTimeListener({required void Function() callback}) {
    if (_screenTimeLeftInSecondsSubjectSubscription == null) {
      _screenTimeLeftInSecondsSubjectSubscription =
          screenTimeLeftInSecondsSubject.listen((_) => callback());
    }
  }

  // Function to convert screen time into credits
  // Might need to be more sophisticated!
  Future startScreenTime(
      {required ScreenTimeSession session,
      required void Function() callback}) async {
    log.i("Starting screen time session");
    _currentSession = session;
    screenTimeStartTime = session.startedAt.toDate();
    screenTimeLeftInSeconds = session.minutes * 60;

    // Need to start a timer here
    // that counts down the screen time
    _stopWatchService.listenToSecondTime(callback: (int tick) {
      screenTimeLeftInSeconds = session.minutes * 60 - tick;

      if ((screenTimeLeftInSeconds!).round() % 60 == 0) {
        screenTimeLeftInSecondsSubject.add(screenTimeLeftInSeconds!);
      }

      // Screen time expired normally!
      if (screenTimeLeftInSeconds == 0) {
        handleScreenTimeOverEvent();
        callback();
      }
      callback();
    });
    String id =
        await _firestoreApi.addScreenTimeSession(session: _currentSession!);
    await _localStorageService.saveToDisk(
        key: kLocalStorageScreenTimeSessionKey, value: id);
    _currentSession = _currentSession!.copyWith(sessionId: id);
  }

  // Function to convert screen time into credits
  // Might need to be more sophisticated!
  Future continueScreenTime(
      {required ScreenTimeSession session,
      required void Function() callback}) async {
    log.i("Continuing screen time session");

    // Need to start a timer here
    // that counts down the screen time
    // Only listen again and subtract difference if timer is
    // not already running!

    if (!_stopWatchService.isRunning) {
      screenTimeStartTime = session.startedAt.toDate();
      previousDiff = DateTime.now().difference(screenTimeStartTime!).inSeconds;
      log.i("Seconds that were already used: $previousDiff");
      justStartedListeningToScreenTime = true;
    } else {
      screenTimeLeftInSeconds =
          session.minutes * 60 - previousDiff - _stopWatchService.getSecondTime;
    }
    _stopWatchService.listenToSecondTime(callback: (int tick) {
      screenTimeLeftInSeconds = session.minutes * 60 - previousDiff - tick;

      if ((screenTimeLeftInSeconds!).round() % 60 == 0) {
        screenTimeLeftInSecondsSubject.add(screenTimeLeftInSeconds!);
        // Notifications().dismissPermanentNotifications();
        // Notifications().dismissUpdatedScreenTimeNotifications();
        // Notifications().createUpdatedScreenTimeNotification(
        //     title: "Screen time left " +
        //         secondsToMinuteTime(screenTimeLeftInSeconds) +
        //         "in",
        //     message: _userService.explorerNameFromUid(session.uid) +
        //         " is using screen time until " +
        //         formatDateToShowTime(
        //             DateTime.now().add(Duration(minutes: session.minutes))));
      }
      // Screen time expired normally!
      if (screenTimeLeftInSeconds == 0) {
        handleScreenTimeOverEvent();
        callback();
      }
      callback();
    });
  }

  Future handleScreenTimeOverEvent() async {
    log.i("Handle screen time over event");
    // check if this function was already called
    if (_currentSession == null ||
        _currentSession?.status == ScreenTimeSessionStatus.completed) return;

    // else finish screen time session
    _currentSession = _currentSession!.copyWith(
      status: ScreenTimeSessionStatus.completed,
      minutesUsed: _currentSession!.minutes,
      afkCreditsUsed: _currentSession!.afkCredits,
    );
    _firestoreApi.updateScreenTimeSession(session: _currentSession!);
    _firestoreApi.changeAfkCreditsBalanceCheat(
      deltaCredits: -_currentSession!.afkCredits,
      uid: _currentSession!.uid,
    );
    resetScreenTimeSession();
  }

  Future stopScreenTime() async {
    dynamic returnVal;
    if (_currentSession != null) {
      // check how long session went on
      // delete and don't bookkeep if less than 30 seconds!
      if (DateTime.now().difference(screenTimeStartTime!).inSeconds < 31) {
        _firestoreApi.deleteScreenTimeSession(session: _currentSession!);
        resetScreenTimeSession();
        returnVal = false;
      } else {
        // calculate difference
        int minutesUsed =
            (DateTime.now().difference(screenTimeStartTime!).inSeconds / 60)
                .round();
        int secondsUsed =
            DateTime.now().difference(screenTimeStartTime!).inSeconds;
        double fraction = secondsUsed / (_currentSession!.minutes * 60);
        num afkCreditsUsed = (fraction * _currentSession!.afkCredits).round();
        _currentSession = _currentSession!.copyWith(
          status: ScreenTimeSessionStatus.cancelled,
          afkCreditsUsed: afkCreditsUsed,
          minutesUsed: minutesUsed,
        );
        _firestoreApi.cancelScreenTimeSession(session: _currentSession!);
        _firestoreApi.changeAfkCreditsBalanceCheat(
          deltaCredits: -afkCreditsUsed,
          uid: _currentSession!.uid,
        );
        _firestoreApi.changeTotalScreenTime(
          deltaScreenTime: minutesUsed,
          uid: _currentSession!.uid,
        );
        returnVal = true;
      }
    }
    resetScreenTimeSession();
    return returnVal == null ? "No screen time active" : returnVal!;
  }

  Future continueOrBookkeepScreenTimeSessionOnStartup(
      {required String sessionId, required Function() callback}) async {
    // load screen time from firestore
    justStartedListeningToScreenTime = false;
    ScreenTimeSession? session;
    try {
      session = await loadActiveScreenTimeSession(sessionId: sessionId);
    } catch (e) {
      log.e(
          "Could not load active screen time from firestore although it is on disk!");
    }
    // check status
    // -> if completed:
    if (session?.status == ScreenTimeSessionStatus.completed ||
        session == null) {
      handleScreenTimeOverEvent();
    } else {
      // -> if not completed
      // --> check if time is UP already?
      if (DateTime.now().difference(session.startedAt.toDate()).inMinutes >
          session.minutes) {
        await handleScreenTimeOverEvent();
      } else {
        // --> if NOT: create session with remaining minutes!
        await continueScreenTime(session: session, callback: callback);
      }
    }
    return session;
  }

  Future loadActiveScreenTimeSession({required String sessionId}) async {
    if (_currentSession != null) {
      // there is already a screen time session in memory!
      // Take that and no need to download anything
      // This, e.g., happens when the user navigates through the app and comes back to the active screen time screen
      return _currentSession;
    }
    final ScreenTimeSession session =
        await _firestoreApi.getScreenTimeSession(sessionId: sessionId);
    _currentSession = session;
    return session;
  }

  void resetScreenTimeSession() async {
    _stopWatchService.resetTimer();
    await _localStorageService.deleteFromDisk(
        key: kLocalStorageScreenTimeSessionKey);
    screenTimeStartTime = null;
    screenTimeLeftInSeconds = null;
    _currentSession = null;
    _screenTimeLeftInSecondsSubjectSubscription?.cancel();
    _screenTimeLeftInSecondsSubjectSubscription = null;
    previousDiff = 0;
  }

  void clearData() async {}

  // --------------------------
  // helpers
  int getScreenTimeLeftInMinutes() {
    return DateTime.now().difference(screenTimeStartTime!).inMinutes;
  }

  dynamic getAfkCreditsBalance({String? childId}) {
    if (childId == null) {
      return _userService.currentUserStats.afkCreditsBalance;
    } else {
      return _userService.supportedExplorerStats[childId]!.afkCreditsBalance;
    }
  }

  int getTotalAvailableScreenTime({String? childId}) {
    return convertCreditsToScreenTime(
        credits: getAfkCreditsBalance(childId: childId));
  }
}
  // ///////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////
  // //////////////////////////////////////////////////////////////////
  // // !!! BELOW IS DEPRECATED CODE!

  // final _firestoreApi = locator<FirestoreApi>();
  // final CloudFunctionsApi _cloudFunctionsApi = locator<CloudFunctionsApi>();
  // StreamSubscription? _purchasedScreenTimesStreamSubscription;
  // List<ScreenTimeSession> purchasedScreenTimeVouchers = [];

  // ////////////////////////////////////////////
  // /// History of screen time
  // // adds listener to money pools the user is contributing to
  // // allows to wait for the first emission of the stream via the completer
  // Future<void>? setupPurchasedScreenTimeListener(
  //     {required Completer<void> completer,
  //     required String uid,
  //     void Function()? callback}) async {
  //   if (_purchasedScreenTimesStreamSubscription == null) {
  //     bool listenedOnce = false;
  //     _purchasedScreenTimesStreamSubscription = _firestoreApi
  //         .getPurchasedScreenTimesStream(uid: uid)
  //         .listen((snapshot) {
  //       listenedOnce = true;
  //       purchasedScreenTimeVouchers = snapshot;
  //       if (!completer.isCompleted) {
  //         completer.complete();
  //       }
  //       if (callback != null) {
  //         callback();
  //       }
  //       log.v("Listened to ${purchasedScreenTimeVouchers.length} screen time");
  //     });
  //     if (!listenedOnce) {
  //       if (!completer.isCompleted) {
  //         completer.complete();
  //       }
  //     }
  //     return completer.future;
  //   } else {
  //     log.w(
  //         "Already listening to list of purchased screen time, not adding another listener");
  //     completer.complete();
  //   }
  // }

  // Future switchScreenTimeStatus({
  //   required ScreenTimeSession screenTimePurchase,
  //   required ScreenTimeSessionStatus newStatus,
  //   required String uid,
  // }) async {
  //   log.i("Switching status of screen time to $newStatus");
  //   ScreenTimeSession newScreenTimePurchase =
  //       screenTimePurchase.copyWith(status: newStatus);
  //   await _firestoreApi.updateScreenTimePurchase(
  //       screenTimePurchase: newScreenTimePurchase,
  //       newStatus: newStatus,
  //       uid: uid);
  // }

  // Future purchaseScreenTime(
  //     {required ScreenTimeSession screenTimePurchase}) async {
  //   return await _cloudFunctionsApi.purchaseScreenTime(
  //       screenTimePurchase: screenTimePurchase);
  // }
  // ////////////////////////////////////////////////////////////
  // // Clean-up

  // void clearData() {
  //   log.i("Clear purchased screen time vouchers");
  //   purchasedScreenTimeVouchers = [];
  //   _purchasedScreenTimesStreamSubscription?.cancel();
  //   _purchasedScreenTimesStreamSubscription = null;
  // }

  // void cancelPurchasedScreenTimeSubscription() {
  //   _purchasedScreenTimesStreamSubscription?.cancel();
  //   _purchasedScreenTimesStreamSubscription = null;
  // }
// }
