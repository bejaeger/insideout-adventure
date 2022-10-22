import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/settings/user_settings.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveScreenTimeViewModel extends BaseModel {
  // -----------------------------------
  // services
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  final log = getLogger('ActiveScreenTimeViewModel');

  // -----------------------------------
  // getters
  int? screenTimeLeft;
  ScreenTimeSession? get currentScreenTimeSession =>
      _screenTimeService.getActiveScreenTimeInMemory(uid: session?.uid);
  ScreenTimeSession? get expiredScreenTime =>
      _screenTimeService.getExpiredScreenTimeSessionInMemory(
          uid: session?.uid, sessionId: session?.sessionId);
  UserSettings get currentUserSettings => userService.currentUserSettings;

  String get childName => session != null ? session!.userName : "";
  String get childId => session != null ? session!.uid : "";

  // ---------------------------
  // constructor
  // used to start screen time
  ScreenTimeSession? session;
  // used if previous screen time session was found
  ActiveScreenTimeViewModel({required this.session});

  // ------------------------------
  // state
  bool justStartedListeningToScreenTime = false;
  Timer? _timer;

  Future initialize() async {
    setBusy(true);

    // start screen time here
    if (session != null &&
        session?.status == ScreenTimeSessionStatus.notStarted) {
      log.i("screen time session will be started");

      // start a NEW screen time session
      session = await _screenTimeService.startScreenTime(
          session: session!, callback: listenToTick);
      justStartedListeningToScreenTime = true;
    }

    // continue screen time here
    if (session != null && session?.status == ScreenTimeSessionStatus.active) {
      log.i(
          "screen time session has started or is active and will be continued");

      // ? Setup local listener for counter
      int screenTimeLeftInSecondsPreset =
          screenTimeService.getTimeLeftInSeconds(session: session!);
      screenTimeLeft = screenTimeLeftInSecondsPreset;
      notifyListeners();

      _stopWatchService.forceListenToSecondTime(
        callback: (int tick) {
          screenTimeLeft = screenTimeLeftInSecondsPreset - tick;
          notifyListeners();
          log.v("Fired listener");
        },
      );
    }

    // ? The following is not needed anymore as we do it one step earlier,
    // ? in the parent_home_viewmodel.dart and explorer_home_viewmodel.dart
    // if screen time is over and notification is pressed
    // bool loadedScreenTime = true;
    // this is the case if we navigate to this view from the expired notification;
    // if (session != null &&
    //     session?.status == ScreenTimeSessionStatus.completed) {
    // this loads the screen time session into memory so it can be accessed with the getter
    // expiredScreenTime
    // loadedScreenTime = await _screenTimeService.loadExpiredScreenTimeSession(
    //     uid: session?.uid, sessionId: session?.sessionId);
    // if (loadedScreenTime) {
    //   session = expiredScreenTime;
    // }
    // }

    // if (session == null || loadedScreenTime == false) {
    if (session == null) {
      log.wtf("session is null, cannot navigate to active screen time view");
      popView();
      // setBusy(false);
      return;
    }
    setBusy(false);
  }

  // Future<void> stopScreenTimeAfterZero() async {
  //   //Notifications().createNotificationsTimesUp(message: "Your Time is Up");
  //   await Notifications().setNotificationsValues();
  //   _screenTimeService.stopScreenTime();
  //   Notifications()
  //       .dismissNotificationsByChannelKey(channelKey: 'base_channel');
  //   navigationService.back();
  //   notifyListeners();
  // }

  // functions
  Future stopScreenTime({required ScreenTimeSession? session}) async {
    if (session == null) return;
    //int counter = 1;
    if (screenTimeLeft == null) return;
    dynamic result;
    if (screenTimeLeft! > 0) {
      result = await dialogService.showDialog(
          buttonTitle: "YES",
          cancelTitle: "NO",
          title: "Cancel Active Screen Time?",
          description: "There are " +
              secondsToMinuteTime(screenTimeLeft) +
              "in left."); //, mainButtonTitle: "CANCEL", )
    }
    setBusy(true);
    if (result == null || result?.confirmed == true) {
      // trying to deal with notifications in screen time service
      // await NotificationController().dismissPermanentNotifications();
      // await NotificationController().dismissScheduledNotifications();
      final res = await _screenTimeService.stopScreenTime(session: session);
      if (res is String) {
        log.wtf("Screen time couldn't be stopped, error: $res");
      }
      String snackBarTitle = "";
      String snackBarMsg = "";
      if (res == false) {
        snackBarTitle = "Cancelled screentime ";
        snackBarMsg = "No credits are being deducted";
      }
      if (res == true) {
        snackBarTitle = "Stopped screentime";
        snackBarMsg = "Credits are deducted accordingly";
      }
      resetStopWatch();
      replaceWithHomeView();
      snackbarService.showSnackbar(
        title: snackBarTitle,
        message: snackBarMsg,
        duration: Duration(seconds: 2),
      );
    }
    setBusy(false);
  }

  // ---------------------------
  // helpers
  //
  DateTime getStartedAt() {
    if (expiredScreenTime!.startedAt is Timestamp) {
      return expiredScreenTime!.startedAt.toDate();
    } else {
      return expiredScreenTime!.startedAt;
    }
  }

  // ------------------------------------
  // clean up
  void resetStopWatch() {
    _timer?.cancel();
    // _stopWatchService.resetTimer();
  }

  void cancelOnlyActiveScreenTimeSubjectListeners({required String uid}) {
    screenTimeService.cancelOnlyActiveScreenTimeSubjectListeners(uid: uid);
  }

  void listenToTick() {
    notifyListeners();
  }

  void resetActiveScreenTimeView({required String uid}) {
    resetStopWatch();
    // ? just do the following all the time!
    //if (justStartedListeningToScreenTime) {
    // this is needed so that new state listeners are being started
    // in home views!
    cancelOnlyActiveScreenTimeSubjectListeners(uid: uid);
    clearStackAndNavigateToHomeView();
    //}
  }

  @override
  dispose() {
    super.dispose();
    // reset timer
    log.v("Resetting stop watch timer");
    // this is important but will stop the active screen time listener
    // when we navigate from outside the app inside the app when
    // the active screen time was shown also last time
    _stopWatchService.resetTimer();
  }
}
