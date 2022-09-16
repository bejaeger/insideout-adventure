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
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();

  // -----------------------------
  // Return values and state

  bool get hasActiveScreenTime => screenTimeActiveSubject.length != 0;

  // map of uid and screen time that are over and we want to show
  // the stats
  Map<String, ScreenTimeSession> screenTimeExpired = {};
  // map of uid and screen time
  Map<String, BehaviorSubject<ScreenTimeSession>> screenTimeActiveSubject = {};
  Map<String, StreamSubscription?> screenTimeSubjectSubscription = {};
  int getMinSreenTimeLeftInSeconds() {
    DateTime now = DateTime.now();
    int min = -1;
    screenTimeActiveSubject.forEach(
      (_, element) {
        int diff = now.difference(element.value.startedAt.toDate()).inSeconds;
        int timeLeft = element.value.minutes * 60 - diff;
        if (timeLeft < min || min < 0) {
          min = timeLeft;
        }
      },
    );
    return min;
  }

  int getTimeLeftInSeconds({required ScreenTimeSession session}) {
    DateTime now = DateTime.now();
    int diff = now.difference(session.startedAt.toDate()).inSeconds;
    int timeLeft = session.minutes * 60 - diff;
    return timeLeft;
  }

  int previousDiff = 0;

  // ---------------------------------
  // Functions

  // Function to convert screen time into credits
  // Might need to be more sophisticated!
  int convertCreditsToScreenTime({required num credits}) {
    double screenTimeFactor = 1;
    return (credits * screenTimeFactor).toInt();
  }

  DateTime getScreenTimeStartTime({required ScreenTimeSession session}) {
    return session.startedAt.toDate();
  }

  ScreenTimeSession? getScreenTimeSession({required String? uid}) {
    if (uid == null) return null;
    return screenTimeActiveSubject[uid]?.value;
  }

  ScreenTimeSession? getScreenTime({required String uid}) {
    return screenTimeActiveSubject[uid]?.value;
  }

  // Function to convert screen time into credits
  // Might need to be more sophisticated!
  Future startScreenTime(
      {required ScreenTimeSession session,
      required void Function() callback}) async {
    log.i("Starting screen time session");
    if (!screenTimeActiveSubject.containsKey(session.uid)) {
      screenTimeActiveSubject[session.uid] = BehaviorSubject.seeded(session);
    } else {
      screenTimeActiveSubject[session.uid]!.add(session);
    }

    // start periodic function to update UI (every 60 seconds)
    // cancels automatically.
    // start periodic function to update UI (every 60 seconds)
    // cancels automatically.
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        int secondsLeft = session.minutes * 60 - timer.tick;
        if (secondsLeft % 60 == 0) {
          if (secondsLeft == 0) {
            handleScreenTimeOverEvent(session: session);
            callback();
            timer.cancel();
          } else {
            log.i(
                "Called periodic timer function and updated screen time session for user ${session.uid}");
            // adding it to the behavior subject can be used to listen to events in the views
            screenTimeActiveSubject[session.uid]?.add(session);
            callback();
          }
        }
      },
    );
    if (!screenTimeSubjectSubscription.containsKey(session.uid) ||
        screenTimeSubjectSubscription[session.uid] == null) {
      screenTimeSubjectSubscription[session.uid] =
          screenTimeActiveSubject[session.uid]?.listen((value) {
        callback();
      });
    }

    // upload
    String id = await _firestoreApi.addScreenTimeSession(session: session);
    await _localStorageService.saveToDisk(
        key: kLocalStorageScreenTimeSessionKey, value: id);
    screenTimeActiveSubject[session.uid]?.add(session.copyWith(sessionId: id));
  }

  // function called when screen time is active that
  // we want to listen to again
  Future continueScreenTime(
      {required ScreenTimeSession session,
      required void Function() callback}) async {
    log.i("Continuing screen time session");
    if (!screenTimeActiveSubject.containsKey(session.uid)) {
      screenTimeActiveSubject[session.uid] = BehaviorSubject.seeded(session);
    } else {
      screenTimeActiveSubject[session.uid]!.add(session);
    }

    // start periodic function to update UI (every 60 seconds)
    // cancels automatically.
    int previousDiff = DateTime.now()
        .difference(getScreenTimeStartTime(session: session))
        .inSeconds;
    Timer.periodic(
      const Duration(seconds: 1), // test with 1 second
      (timer) {
        int secondsLeft = session.minutes * 60 - timer.tick - previousDiff;
        if (secondsLeft % 60 == 0) {
          if (secondsLeft == 0) {
            handleScreenTimeOverEvent(session: session);
            callback();
            timer.cancel();
          } else {
            log.i(
                "Called periodic timer function and updated screen time session for user ${session.uid}");
            // adding it to the behavior subject can be used to listen to events in the views
            // screenTimeActiveSubject[session.uid]?.add(session);
            if (!screenTimeActiveSubject.containsKey(session.uid)) {
              screenTimeActiveSubject[session.uid] =
                  BehaviorSubject.seeded(session);
            } else {
              screenTimeActiveSubject[session.uid]!.add(session);
            }
            callback();
          }
        }
      },
    );
    if (!screenTimeSubjectSubscription.containsKey(session.uid) ||
        screenTimeSubjectSubscription[session.uid] == null) {
      screenTimeSubjectSubscription[session.uid] =
          screenTimeActiveSubject[session.uid]?.listen((value) {
        callback();
      });
    }
  }

  Future handleScreenTimeOverEvent({required ScreenTimeSession session}) async {
    log.i("Handle screen time over event");
    // check if this function was already called
    if (session.status == ScreenTimeSessionStatus.completed) return;

    // else finish screen time session
    final currentSession = session.copyWith(
      status: ScreenTimeSessionStatus.completed,
      minutesUsed: session.minutes,
      afkCreditsUsed: session.afkCredits,
    );
    _firestoreApi.updateScreenTimeSession(session: currentSession);
    _firestoreApi.changeAfkCreditsBalanceCheat(
      deltaCredits: -currentSession.afkCredits,
      uid: currentSession.uid,
    );
    resetScreenTimeSession(session: currentSession);
  }

  Future stopScreenTime({required ScreenTimeSession session}) async {
    dynamic returnVal;
    // check how long session went on
    // delete and don't bookkeep if less than 30 seconds!
    if (DateTime.now()
            .difference(getScreenTimeStartTime(session: session))
            .inSeconds <
        31) {
      _firestoreApi.deleteScreenTimeSession(session: session);
      resetScreenTimeSession(session: session);
      returnVal = false;
    } else {
      // calculate difference
      int minutesUsed = (DateTime.now()
                  .difference(getScreenTimeStartTime(session: session))
                  .inSeconds /
              60)
          .round();
      int secondsUsed = DateTime.now()
          .difference(getScreenTimeStartTime(session: session))
          .inSeconds;
      double fraction = secondsUsed / (session.minutes * 60);
      num afkCreditsUsed = (fraction * session.afkCredits).round();

      final currentSession = session.copyWith(
        status: ScreenTimeSessionStatus.cancelled,
        afkCreditsUsed: afkCreditsUsed,
        minutesUsed: minutesUsed,
      );

      screenTimeActiveSubject[session.uid]?.add(currentSession);
      _firestoreApi.cancelScreenTimeSession(session: currentSession);
      _firestoreApi.changeAfkCreditsBalanceCheat(
        deltaCredits: -afkCreditsUsed,
        uid: currentSession.uid,
      );
      _firestoreApi.changeTotalScreenTime(
        deltaScreenTime: minutesUsed,
        uid: currentSession.uid,
      );
      returnVal = true;
    }
    resetScreenTimeSession(session: session);
    return returnVal;
  }

  Future continueOrBookkeepScreenTimeSessionOnStartup(
      {required ScreenTimeSession session,
      required Function() callback}) async {
    // load screen time from firestore
    // check status
    // -> if completed:
    if (session.status == ScreenTimeSessionStatus.completed) {
      handleScreenTimeOverEvent(session: session);
    } else {
      // -> if not completed
      // --> check if time is UP already?
      if (DateTime.now().difference(session.startedAt.toDate()).inMinutes >
          session.minutes) {
        await handleScreenTimeOverEvent(session: session);
      } else {
        // --> if NOT: create session with remaining minutes!
        await continueScreenTime(session: session, callback: callback);
      }
    }
    return session;
  }

  Future checkForActiveScreenTimeSession(
      {String? uid, required String sessionId}) async {
    if (uid != null) {
      // there might already be a screen time session in memory!
      // Take that and no need to download anything
      // This, e.g., happens when the user navigates through the app and comes back to the active screen time screen
      if (screenTimeActiveSubject[uid]?.value != null) {
        return screenTimeActiveSubject[uid]?.value;
      }
    }
    final ScreenTimeSession? session =
        await _firestoreApi.getScreenTimeSession(sessionId: sessionId);
    if (uid != null && session != null) {
      screenTimeActiveSubject[uid] = BehaviorSubject.seeded(session);
    }
    return session;
  }

  void resetScreenTimeSession({required ScreenTimeSession session}) async {
    await _localStorageService.deleteFromDisk(
        key: kLocalStorageScreenTimeSessionKey);
    cancelScreenTimeSubjectSubscription();
    previousDiff = 0;
    screenTimeExpired[session.uid] = session;
    screenTimeActiveSubject[session.uid]?.close();
    screenTimeActiveSubject.remove(session.uid);
    _userService.cancelActiveScreenTimeSession(session: session);
  }

  void cancelScreenTimeSubjectSubscription() {
    screenTimeSubjectSubscription.forEach((key, value) {
      value?.cancel();
      screenTimeSubjectSubscription[key] = null;
    });
  }

  void clearData() async {
    //cancelScreenTimeSubjectSubscription();
  }

  // --------------------------
  // helpers
  // int getScreenTimeLeftInMinutes() {
  //   return DateTime.now().difference(screenTimeStartTime!).inMinutes;
  // }

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
