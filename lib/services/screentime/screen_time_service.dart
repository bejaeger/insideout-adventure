import 'dart:async';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/notifications/notification_controller.dart';
import 'package:afkcredits/notifications/notifications_service.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';

class ScreenTimeService {
  // ----------------------------
  // services
  final log = getLogger('ScreenTimeService');
  //final UserService _userService = locator<UserService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final NotificationsService _notificationService =
      locator<NotificationsService>();

  // -----------------------------
  // Return values and state

  bool get hasActiveScreenTime => screenTimeActiveSubject.length != 0;

  //? State connected to firestore!
  // quest history is added to user service (NOT IDEAL! cause we have a quest service)
  // map of explorerIds and screen time sessions (list with 1 entry!)
  Map<String, List<ScreenTimeSession>> supportedExplorerScreenTimeSessions = {};
  // map of explorerIds with screen time session
  Map<String, ScreenTimeSession> supportedExplorerScreenTimeSessionsActive = {};

  // ? State connected to local app!
  // map of uid and screen time that are over and we want to show
  // the stats
  Map<String, ScreenTimeSession> screenTimeExpired = {};
  // map of uid and screen time
  Map<String, BehaviorSubject<ScreenTimeSession>> screenTimeActiveSubject = {};
  Map<String, StreamSubscription?> screenTimeSubjectSubscription = {};
  Map<String, Timer> screenTimeTimer = {};

  // ? State for notifications
  Map<String, int> permanentNotificationId = {};
  Map<String, int> scheduledNotificationId = {};

  // set from user_service
  String? currentUserId;
  void setUserId(String id) {
    currentUserId = id;
  }

  // helper function
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
    if (session.startedAt is Timestamp) {
      int diff = now.difference(session.startedAt.toDate()).inSeconds;
      int timeLeft = session.minutes * 60 - diff;
      return timeLeft;
    } else {
      return -1;
    }
  }

  // ---------------------------------
  // Functions

  DateTime getScreenTimeStartTime({required ScreenTimeSession session}) {
    return session.startedAt.toDate();
  }

  ScreenTimeSession? getActiveScreenTimeInMemory(
      {required String? uid, String? sessionId}) {
    if (uid == null) return null;
    final session = screenTimeActiveSubject[uid]?.value;
    // if sessionId is set we only want to return the current object if
    // it is the one with 'sessionId'
    if (sessionId != null) {
      if (sessionId == session?.sessionId) {
        return session;
      } else {
        return null;
      }
    }
    return session;
  }

  ScreenTimeSession? getExpiredScreenTimeSessionInMemory(
      {required String? uid, String? sessionId}) {
    if (uid == null) return null;
    if (screenTimeExpired.containsKey(uid)) {
      final session = screenTimeExpired[uid];
      if (sessionId != null) {
        if (sessionId == session?.sessionId) {
          return session;
        } else {
          return null;
        }
      }
      return session;
    } else {
      return null;
    }
  }

  // ScreenTimeSession? getFirstExpiredScreenTimeSession() {
  //   if (screenTimeExpired.length > 0) {
  //     return screenTimeExpired.any;
  //   } else {
  //     return null;
  //   }
  // }

  Future<ScreenTimeSession?> loadAndGetScreenTimeSession(
      {required String sessionId}) async {
    final session =
        await _firestoreApi.getScreenTimeSession(sessionId: sessionId);
    if (session != null) {
      if (session.status == ScreenTimeSessionStatus.completed) {
        screenTimeExpired[session.uid] = session;
        return session;
      }
      if (session.status == ScreenTimeSessionStatus.active) {
        if (!screenTimeActiveSubject.containsKey(session.uid)) {
          screenTimeActiveSubject[session.uid] =
              BehaviorSubject.seeded(session);
        } else {
          screenTimeActiveSubject[session.uid]!.add(session);
        }
        return session;
      }
    }
    return null;
  }

  Future<bool> loadExpiredScreenTimeSession(
      {required String? uid, String? sessionId}) async {
    if (uid == null) return false;
    if (screenTimeExpired.containsKey(uid)) {
      return true;
    } else {
      if (sessionId != null) {
        final session =
            await _firestoreApi.getScreenTimeSession(sessionId: sessionId);
        if (session != null &&
            session.status == ScreenTimeSessionStatus.completed) {
          screenTimeExpired[uid] = session;
          return true;
        }
      }
      return false;
    }
  }

  Future<bool> loadActiveScreenTimeSession(
      {required String? uid, String? sessionId}) async {
    if (uid == null) return false;
    if (screenTimeActiveSubject.containsKey(uid)) {
      return true;
    } else {
      if (sessionId != null) {
        final session =
            await _firestoreApi.getScreenTimeSession(sessionId: sessionId);
        if (session != null) {
          screenTimeActiveSubject[uid]?.add(session);
          return true;
        }
      }
      return false;
    }
  }

  // Function to convert screen time into credits
  // Might need to be more sophisticated!
  Future startScreenTime(
      {required ScreenTimeSession session,
      required void Function() callback}) async {
    log.i("Starting screen time session");

    //TEST
    //session = session.copyWith(minutes: 1);

    if (!screenTimeActiveSubject.containsKey(session.uid)) {
      screenTimeActiveSubject[session.uid] = BehaviorSubject.seeded(session);
    } else {
      screenTimeActiveSubject[session.uid]!.add(session);
    }

    // listen to behavior subject with callback from where this function was called!
    if (!screenTimeSubjectSubscription.containsKey(session.uid) ||
        screenTimeSubjectSubscription[session.uid] == null) {
      screenTimeSubjectSubscription[session.uid] =
          screenTimeActiveSubject[session.uid]?.listen(
        (value) {
          callback();
        },
        onDone: () => callback(),
      );
    }

    // upload
    String id = await _firestoreApi.addScreenTimeSession(session: session);
    // add new session to subject which includes firestore ID!
    session = session.copyWith(sessionId: id);
    screenTimeActiveSubject[session.uid]?.add(session);

    // start periodic function to update UI (every 60 seconds)
    // cancels automatically.
    // start periodic function to update UI (every 60 seconds)
    // cancels automatically.
    screenTimeTimer[session.uid] =
        startTimer(session: session, callback: callback, previousDiff: 0);

    log.v("Fire notifications");
    // store unique ids for notifications to keep track
    await NotificationsService()
        .maybeCreatePermanentIsUsingScreenTimeNotification(session: session);
    await NotificationsService()
        .maybeCreateScheduledIsUsingScreenTimeNotification(session: session);

    // need to call callback here once so that UI reacts
    // on just added screenTimeActiveSubject!
    callback();

    // return updated session with firestore document id
    return session;
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

    // if there is a timer already active we don't need to listen to everything again. Return;
    if (screenTimeTimer.containsKey(session.uid)) {
      log.v(
          "Already listening to screen time session in local state. Returning.");
      return;
    }

    // start periodic function to update UI (every 60 seconds)
    // cancels automatically.
    int previousDiff = DateTime.now()
        .difference(getScreenTimeStartTime(session: session))
        .inSeconds;
    screenTimeTimer[session.uid] = startTimer(
        session: session, callback: callback, previousDiff: previousDiff);

    if (!screenTimeSubjectSubscription.containsKey(session.uid) ||
        screenTimeSubjectSubscription[session.uid] == null) {
      screenTimeSubjectSubscription[session.uid] =
          screenTimeActiveSubject[session.uid]?.listen(
        (value) {
          // log.v("Running callback of screenTimeActiveSubject!");
          callback();
        },
        onDone: () => callback(),
      );
    }

    // Maybe start notifications here.
    // Needed for 2-phone scenario!
    await NotificationsService()
        .maybeCreatePermanentIsUsingScreenTimeNotification(session: session);
    await NotificationsService()
        .maybeCreateScheduledIsUsingScreenTimeNotification(session: session);
    // need to call callback here once so that UI reacts
    // on just added screenTimeActiveSubject!
    callback();
  }

  // previous difference of timer as offset
  Timer startTimer(
      {required ScreenTimeSession session,
      required void Function() callback,
      required int previousDiff}) {
    return Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        int secondsLeft = session.minutes * 60 - previousDiff - timer.tick;
        // update every minute!
        if (secondsLeft % 60 == 0) {
          if (secondsLeft == 0) {
            await handleScreenTimeOverEvent(
                session: screenTimeActiveSubject[session.uid]!.value);
            callback();
            timer.cancel();
          } else {
            log.i(
                "Called periodic timer function and updated screen time session for user ${session.userName}. Seconds left: $secondsLeft");
            // adding it to the behavior subject can be used to listen to events in the views
            if (!screenTimeActiveSubject.containsKey(session.uid)) {
              screenTimeActiveSubject[session.uid] =
                  BehaviorSubject.seeded(session);
            } else {
              screenTimeActiveSubject[session.uid]!.add(session);
            }
            // since I listen to the behavior subject no need to call the callback here
            // callback();
          }
        }
      },
    );
  }

  Future handleScreenTimeOverEvent(
      {required ScreenTimeSession session, void Function()? callback}) async {
    log.i("Handle screen time over event");
    session = screenTimeActiveSubject[session.uid]?.value ?? session;
    // check if this function was already called
    if (session.status == ScreenTimeSessionStatus.completed) {
      log.i("Found that session is completed already. dismiss notifications");

      await _notificationService.dismissPermanentNotification(
          sessionId: session.sessionId);
      if (session.status == ScreenTimeSessionStatus.cancelled) {
        await _notificationService.cancelScheduledNotification(
            sessionId: session.sessionId);
      }
      return;
    }

    // else finish screen time session
    final currentSession = session.copyWith(
      status: ScreenTimeSessionStatus.completed,
      minutesUsed: session.minutes,
      afkCreditsUsed: session.afkCredits,
    );

    // this will make the view react to the finish event cause now the status is complete!
    screenTimeExpired[currentSession.uid] = currentSession;
    screenTimeActiveSubject[currentSession.uid]?.close();
    screenTimeActiveSubject.remove(currentSession.uid);

    // ? not sure if that is needed here.
    if (callback != null) {
      callback();
    }

    // runs a transaction
    await _firestoreApi.updateStatsAfterScreenTimeFinished(
      session: currentSession,
      deltaCredits: -currentSession.afkCredits,
      deltaScreenTime: currentSession.minutes,
    );

    await resetScreenTimeSession(session: currentSession);
  }

  Future stopScreenTime({required ScreenTimeSession session}) async {
    dynamic returnVal;
    // check how long session went on
    // delete and don't bookkeep if less than 30 seconds!
    if (DateTime.now()
            .difference(getScreenTimeStartTime(session: session))
            .inSeconds <
        31) {
      session = session.copyWith(status: ScreenTimeSessionStatus.cancelled);
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

      session = session.copyWith(
        status: ScreenTimeSessionStatus.cancelled,
        afkCreditsUsed: afkCreditsUsed,
        minutesUsed: minutesUsed,
      );

      screenTimeActiveSubject[session.uid]?.add(session);
      // run transaction
      await _firestoreApi.updateStatsAfterScreenTimeFinished(
        session: session,
        deltaCredits: -afkCreditsUsed,
        deltaScreenTime: minutesUsed,
      );
      returnVal = true;
    }
    await resetScreenTimeSession(session: session);
    return returnVal;
  }

  Future continueOrBookkeepScreenTimeSessionOnStartup(
      {required ScreenTimeSession session,
      required Function() callback}) async {
    // load screen time from firestore
    // check status
    // -> if completed:
    if (session.status == ScreenTimeSessionStatus.completed) {
      await handleScreenTimeOverEvent(session: session);
    } else {
      // -> if not completed
      // --> check if time is UP already?
      if (DateTime.now().difference(session.startedAt.toDate()).inSeconds >=
          session.minutes * 60) {
        await handleScreenTimeOverEvent(session: session, callback: callback);
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

  Future resetScreenTimeSession({required ScreenTimeSession session}) async {
    // store in local state the session that was expired
    screenTimeExpired[session.uid] = session;

    // cancel all state and listeners related to screen time session
    cancelActiveScreenTimeListeners(uid: session.uid);

    log.v("Cancelling scheduled notification");

    // dismiss nofifications
    await _notificationService.dismissPermanentNotification(
        sessionId: session.sessionId);
    if (session.status == ScreenTimeSessionStatus.cancelled) {
      await _notificationService.cancelScheduledNotification(
          sessionId: session.sessionId);
    }
  }

  Future listenToPotentialScreenTimes(
      {required void Function() callback}) async {
    log.v("Start listening to the screen times in memory");
    Completer<void> completer = Completer();
    int l = supportedExplorerScreenTimeSessionsActive.length;
    int counter = 0;

    if (supportedExplorerScreenTimeSessionsActive.isEmpty) {
      if (!completer.isCompleted) {
        completer.complete();
        return completer.future;
      }
    }

    supportedExplorerScreenTimeSessionsActive.forEach(
      (key, session) {
        counter = counter + 1;
        if (!screenTimeSubjectSubscription.containsKey(session.uid) ||
            screenTimeSubjectSubscription[session.uid] == null) {
          screenTimeSubjectSubscription[session.uid] =
              screenTimeActiveSubject[session.uid]?.listen(
            (value) {
              // log.v("Running callback of screenTimeActiveSubject!");
              callback();
              // wait until all screen time sessions were listened to!
              if (counter == l && !completer.isCompleted) {
                completer.complete();
              }
            },
            // important since we cancel the screenTimeActiveSubject at some point.
            // this should trigger another callback
            onDone: () => callback(),
          );
        } else {
          log.e("Already listening to screen time subject.");
          if (counter == l && !completer.isCompleted) {
            completer.complete();
          }
        }
      },
    );
    return completer.future;
  }

  Future<ScreenTimeSession?> getSpecificScreenTime(
      {required String? uid, required String? sessionId}) async {
    if (uid == null || sessionId == null) return null;
    // get latest status of active screen time
    ScreenTimeSession? session =
        getActiveScreenTimeInMemory(uid: uid, sessionId: sessionId);
    // if null see if it is an expired screen time session
    if (session == null) {
      session =
          getExpiredScreenTimeSessionInMemory(uid: uid, sessionId: sessionId);
    }
    // no screen time in memory, need to download it from firestore
    if (session == null) {
      session = await loadAndGetScreenTimeSession(sessionId: sessionId);
    }
    return session;
  }

  void cancelOnlyActiveScreenTimeSubjectListeners({required String uid}) {
    screenTimeSubjectSubscription[uid]?.cancel();
    screenTimeSubjectSubscription[uid] = null;
  }

  void cancelActiveScreenTimeListeners({required String uid}) async {
    // Don't cancel all of it!
    // screenTimeSubjectSubscription.forEach((key, value) {
    //   value?.cancel();
    //   screenTimeSubjectSubscription[key] = null;
    // });
    screenTimeSubjectSubscription[uid]?.cancel();
    screenTimeSubjectSubscription[uid] = null;
    screenTimeActiveSubject[uid]?.close();
    screenTimeActiveSubject.remove(uid);

    //
    supportedExplorerScreenTimeSessionsActive.remove(uid);

    // also cancel timer, otherwise screen time will be pushed over and over again
    screenTimeTimer[uid]?.cancel();
    screenTimeTimer.remove(uid);
  }

  void cancelAllActiveScreenTimes() {
    screenTimeSubjectSubscription.forEach(
      (key, value) {
        cancelActiveScreenTimeListeners(uid: key);
      },
    );
  }

  void clearData() async {
    cancelAllActiveScreenTimes();
    //cancelScreenTimeSubjectSubscription();
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
