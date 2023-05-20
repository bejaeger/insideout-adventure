import 'dart:async';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/notifications/notifications_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';

class ScreenTimeService {
  final log = getLogger('ScreenTimeService');
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final NotificationsService _notificationService =
      locator<NotificationsService>();

  bool get hasActiveScreenTime => screenTimeActiveSubject.length != 0;

  //? State synced with firestore!
  // quest history is added to user service (NOT IDEAL! cause we have a quest service)
  // map of wardIds and screen time sessions (list with 1 entry!)
  Map<String, List<ScreenTimeSession>> supportedWardScreenTimeSessions = {};
  // map of wardIds with screen time session, filled from firestore
  Map<String, ScreenTimeSession> supportedWardScreenTimeSessionsActive = {};

  // when ward asks for screen time, this map will be filled
  Map<String, ScreenTimeSession> supportedWardScreenTimeSessionsRequested = {};

  // ? State synced with local app!
  // map of uid and screen time that are over and we want to show
  // the stats of
  Map<String, ScreenTimeSession> screenTimeExpired = {};
  Map<String, BehaviorSubject<ScreenTimeSession>> screenTimeActiveSubject = {};
  Map<String, StreamSubscription?> screenTimeSubjectSubscription = {};
  Map<String, Timer> screenTimeTimer = {};

  // ? State for notifications
  Map<String, int> permanentNotificationId = {};
  Map<String, int> scheduledNotificationId = {};

  // for start screen time counter view
  int counter = 10;
  ScreenTimeSession? scheduledScreenTimeSession;

  String getScreenTimeSessionDocId() {
    return _firestoreApi.getScreenTimeSessionDocId();
  }

  Future startScreenTime(
      {required ScreenTimeSession session,
      required void Function() callback}) async {
    log.i("Starting screen time session");

    session = session.copyWith(status: ScreenTimeSessionStatus.active);

    if (!screenTimeActiveSubject.containsKey(session.uid)) {
      screenTimeActiveSubject[session.uid] = BehaviorSubject.seeded(session);
    } else {
      screenTimeActiveSubject[session.uid]!.add(session);
    }

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

    await _firestoreApi.addScreenTimeSession(session: session);

    // start periodic function to update UI (every 60 seconds)
    // cancels automatically.
    screenTimeTimer[session.uid] =
        startTimer(session: session, callback: callback, previousDiff: 0);

    await NotificationsService()
        .maybeCreatePermanentIsUsingScreenTimeNotification(session: session);
    await NotificationsService()
        .maybeCreateScheduledIsUsingScreenTimeNotification(session: session);

    // need to call callback here once so that UI reacts
    // on just added screenTimeActiveSubject!
    callback();

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

    if (screenTimeTimer.containsKey(session.uid)) {
      log.i(
          "Already listening to screen time session in local state. Returning.");
      return;
    }

    // start periodic function to update UI (every 60 seconds)
    // This is the main loop that will handle a screen time completion event
    int previousDiff = DateTime.now()
        .difference(getScreenTimeStartTime(session: session))
        .inSeconds;
    screenTimeTimer[session.uid] = startTimer(
        session: session, callback: callback, previousDiff: previousDiff);

    // TODO: Not sure if this is still needed
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

    // Needed for 2-phone scenario!
    await NotificationsService()
        .maybeCreatePermanentIsUsingScreenTimeNotification(session: session);
    await NotificationsService()
        .maybeCreateScheduledIsUsingScreenTimeNotification(session: session);
    // need to call callback here once so that UI reacts
    // on just added screenTimeActiveSubject!
    callback();
  }

  Timer startTimer(
      {required ScreenTimeSession session,
      required void Function() callback,
      required int previousDiff}) {
    return Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        int secondsLeft = session.minutes * 60 - previousDiff - timer.tick;
        if (secondsLeft % 60 == 0) {
          if (secondsLeft == 0) {
            if (screenTimeActiveSubject[session.uid] == null) {
              callback();
              timer.cancel();
            }
            await handleScreenTimeOverEvent(
                session: screenTimeActiveSubject[session.uid]!.value);
            callback();
            timer.cancel();
          } else {
            log.i(
                "Called periodic timer function and updated screen time session for user ${session.userName}. Seconds left: $secondsLeft");
            if (!screenTimeActiveSubject.containsKey(session.uid)) {
              screenTimeActiveSubject[session.uid] =
                  BehaviorSubject.seeded(session);
            } else {
              screenTimeActiveSubject[session.uid]!.add(session);
            }
          }
        }
      },
    );
  }

  Future handleScreenTimeOverEvent(
      {required ScreenTimeSession session, void Function()? callback}) async {
    log.i("Handle screen time over event");
    log.i("${session.status}");
    session = screenTimeActiveSubject[session.uid]?.value ?? session;
    log.i("${session.status}");
    if (session.status == ScreenTimeSessionStatus.completed) {
      log.i(
          "Found that session is completed already. dismiss notifications and return");
      if (callback != null) {
        callback();
      }
      await _notificationService.dismissPermanentNotification(
          sessionId: session.sessionId);
      if (session.status == ScreenTimeSessionStatus.cancelled) {
        await _notificationService.cancelScheduledNotification(
            sessionId: session.sessionId);
      }
      return;
    }

    final currentSession = session.copyWith(
      status: ScreenTimeSessionStatus.completed,
      minutesUsed: session.minutes,
      afkCreditsUsed: session.afkCredits,
    );

    // this will make the UI react to the finish event cause now the status is complete!
    screenTimeExpired[currentSession.uid] = currentSession;
    screenTimeActiveSubject[currentSession.uid]?.close();
    screenTimeActiveSubject.remove(currentSession.uid);

    // TODO: not sure if that is needed here.
    if (callback != null) {
      callback();
    }

    await _firestoreApi.updateStatsAfterScreenTimeFinished(
      session: currentSession,
      deltaCredits: -currentSession.afkCredits,
      deltaScreenTime: currentSession.minutes,
    );

    await resetScreenTimeSession(session: currentSession);
  }

  Future stopScreenTime({required ScreenTimeSession session}) async {
    dynamic returnVal;
    bool cancelledPrematurely =
        getScreenTimeDurationInSeconds(session: session) <= 30;
    if (cancelledPrematurely) {
      // we don't want to take record if screen time was cancelled prematurely after a few seconds
      session = session.copyWith(status: ScreenTimeSessionStatus.cancelled);
      _firestoreApi.deleteScreenTimeSession(session: session);
      resetScreenTimeSession(session: session);
      returnVal = false;
    } else {
      int minutesUsed = getScreenTimeDurationInMinutes(session: session);
      int secondsUsed = getScreenTimeDurationInSeconds(session: session);
      double fraction = secondsUsed / (session.minutes * 60);
      num afkCreditsUsed = (fraction * session.afkCredits).round();
      session = session.copyWith(
        status: ScreenTimeSessionStatus.cancelled,
        afkCreditsUsed: afkCreditsUsed,
        minutesUsed: minutesUsed,
      );
      screenTimeActiveSubject[session.uid]?.add(session);
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
    if (session.status == ScreenTimeSessionStatus.completed) {
      await handleScreenTimeOverEvent(session: session);
    } else {
      bool isTimeUp = getScreenTimeDurationInSeconds(session: session) >=
          session.minutes * 60;
      if (isTimeUp) {
        await handleScreenTimeOverEvent(session: session, callback: callback);
      } else {
        await continueScreenTime(session: session, callback: callback);
      }
    }
    return session;
  }

  Future resetScreenTimeSession({required ScreenTimeSession session}) async {
    screenTimeExpired[session.uid] = session;
    cancelActiveScreenTimeListeners(uid: session.uid);
    await _notificationService.dismissPermanentNotification(
        sessionId: session.sessionId);
    if (session.status == ScreenTimeSessionStatus.cancelled) {
      await _notificationService.cancelScheduledNotification(
          sessionId: session.sessionId);
    }
  }

  // this listener is meant for the guardian_home_view and the ward_home_view
  // So whenever these views get disposed, we should cancel the screenTimeSubjectSubscription
  // so it starts again here!
  Future listenToPotentialScreenTimes(
      {required void Function() callback}) async {
    log.v("Start listening to the screen times in memory (if there are any)");
    Completer<void> completer = Completer();
    int l = supportedWardScreenTimeSessionsActive.length;
    int counter = 0;
    if (supportedWardScreenTimeSessionsActive.isEmpty) {
      if (!completer.isCompleted) {
        completer.complete();
        return completer.future;
      }
    }

    for (ScreenTimeSession session
        in supportedWardScreenTimeSessionsActive.values) {
      await continueOrBookkeepScreenTimeSessionOnStartup(
        session: session,
        callback: () {},
      );

      counter = counter + 1;
      if (!screenTimeSubjectSubscription.containsKey(session.uid) ||
          screenTimeSubjectSubscription[session.uid] == null) {
        screenTimeSubjectSubscription[session.uid] =
            screenTimeActiveSubject[session.uid]?.listen(
          (value) {
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
    }
    return completer.future;
  }

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

  int getTimeLeftInSeconds({required ScreenTimeSession session}) {
    DateTime now = DateTime.now();
    if (session.startedAt is Timestamp) {
      int diff = now.difference(session.startedAt.toDate()).inSeconds;
      int timeLeft = session.minutes * 60 - diff;
      return timeLeft;
    } else {
      int diff = now.difference(session.startedAt).inSeconds;
      int timeLeft = session.minutes * 60 - diff;
      return timeLeft;
    }
  }

  int getScreenTimeDurationInSeconds({required ScreenTimeSession session}) {
    return DateTime.now()
        .difference(getScreenTimeStartTime(session: session))
        .inSeconds;
  }

  int getScreenTimeDurationInMinutes({required ScreenTimeSession session}) {
    return DateTime.now()
        .difference(getScreenTimeStartTime(session: session))
        .inMinutes;
  }

  DateTime getScreenTimeStartTime({required ScreenTimeSession session}) {
    if (session.startedAt is DateTime) {
      return session.startedAt;
    } else {
      return session.startedAt.toDate();
    }
  }

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

  Future uploadScreenTimeRequest({required ScreenTimeSession session}) async {
    await _firestoreApi.addScreenTimeSession(
        session: session.copyWith(status: ScreenTimeSessionStatus.requested));
  }

  Future removeScreenTimeSession({required ScreenTimeSession session}) async {
    await _firestoreApi.removeScreenTimeSessionStatus(
        sessionId: session.sessionId);
  }

  Future acceptScreenTimeSession({required ScreenTimeSession session}) async {
    await _firestoreApi.updateScreenTimeSessionStatus(
        session: session, status: ScreenTimeSessionStatus.active);
  }

  Future denyScreenTimeSession({required ScreenTimeSession session}) async {
    await _firestoreApi.updateScreenTimeSessionStatus(
        session: session, status: ScreenTimeSessionStatus.denied);
  }

  Stream<ScreenTimeSession> getScreenTimeStream({required String sessionId}) {
    return _firestoreApi.getScreenTimeStream(sessionId: sessionId);
  }

  Future<ScreenTimeSession?> getSpecificScreenTime(
      {required String? uid, required String? sessionId}) async {
    if (uid == null || sessionId == null) return null;
    ScreenTimeSession? session =
        getActiveScreenTimeInMemory(uid: uid, sessionId: sessionId);
    if (session == null) {
      session =
          getExpiredScreenTimeSessionInMemory(uid: uid, sessionId: sessionId);
    }
    if (session == null) {
      session = await loadAndGetScreenTimeSession(sessionId: sessionId);
    }
    return session;
  }

  void cancelOnlyActiveScreenTimeSubjectListeners({required String uid}) {
    screenTimeSubjectSubscription[uid]?.cancel();
    screenTimeSubjectSubscription[uid] = null;
  }

  void cancelOnlyActiveScreenTimeSubjectListenersAll() {
    supportedWardScreenTimeSessionsActive.forEach((key, session) {
      screenTimeSubjectSubscription[key]?.cancel();
      screenTimeSubjectSubscription[key] = null;
    });
  }

  void cancelActiveScreenTimeListeners({required String uid}) async {
    screenTimeSubjectSubscription[uid]?.cancel();
    screenTimeSubjectSubscription[uid] = null;
    screenTimeActiveSubject[uid]?.close();
    screenTimeActiveSubject.remove(uid);

    supportedWardScreenTimeSessionsActive.remove(uid);

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
  }
}
