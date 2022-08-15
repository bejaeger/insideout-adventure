import 'dart:async';
import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/users/user_service.dart';

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
  int get totalAvailableScreenTime => convertCreditsToScreenTime(
      credits: _userService.currentUserStats.afkCreditsBalance);

  ScreenTimeSession? _currentSession;
  ScreenTimeSession? get currentSession => _currentSession;
  DateTime? screenTimeStartTime;
  bool get hasActiveScreenTime => screenTimeStartTime != null;
  int? screenTimeLeftInSeconds;
  // int get screenTimeLeft =>
  //     hasActiveScreenTime ? getScreenTimeLeftInMinutes() : -1;

  // ---------------------------------
  // Functions

  // Function to convert screen time into credits
  // Might need to be more sophisticated!
  int convertCreditsToScreenTime({required num credits}) {
    double screenTimeFactor = 1;
    return (credits * screenTimeFactor).toInt();
  }

  // Function to convert screen time into credits
  // Might need to be more sophisticated!
  void startScreenTime(
      {required ScreenTimeSession session,
      required void Function() callback}) async {
    _currentSession = session;
    screenTimeStartTime = DateTime.now();
    screenTimeLeftInSeconds = session.minutes * 60;

    // Need to start a timer here
    // that counts down the screen time
    _stopWatchService.listenToSecondTime(callback: (int tick) {
      screenTimeLeftInSeconds = session.minutes * 60 - tick;
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
  void continueScreenTime(
      {required ScreenTimeSession session,
      required void Function() callback}) async {
    _currentSession = session;
    screenTimeStartTime = session.startedAt.toDate();
    final int diff = DateTime.now().difference(screenTimeStartTime!).inSeconds;
    screenTimeLeftInSeconds = session.minutes * 60 - diff;

    // Need to start a timer here
    // that counts down the screen time
    _stopWatchService.listenToSecondTime(callback: (int tick) {
      screenTimeLeftInSeconds = session.minutes * 60 - diff - tick;
      // Screen time expired normally!
      if (screenTimeLeftInSeconds == 0) {
        handleScreenTimeOverEvent();
        callback();
      }
      callback();
    });
  }

  Future handleScreenTimeOverEvent() async {
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
    if (_currentSession != null) {
      // check how long session went on
      // delete and don't bookkeep if less than 30 seconds!
      if (DateTime.now().difference(screenTimeStartTime!).inSeconds < 31) {
        _firestoreApi.deleteScreenTimeSession(session: _currentSession!);
        return false;
      } else {
        // calculate difference
        int minutesUsed =
            DateTime.now().difference(screenTimeStartTime!).inMinutes;
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
        return true;
      }
    }
    resetScreenTimeSession();
    return "No screen time active";
  }

  Future loadActiveScreenTimeSession({required String sessionId}) async {
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
  }

  void clearData() async {}

  // --------------------------
  // helpers
  int getScreenTimeLeftInMinutes() {
    return DateTime.now().difference(screenTimeStartTime!).inMinutes;
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
