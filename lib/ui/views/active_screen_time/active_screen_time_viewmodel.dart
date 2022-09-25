import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/utils/string_utils.dart';

class ActiveScreenTimeViewModel extends BaseModel {
  // -----------------------------------
  // services
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  final log = getLogger('ActiveScreenTimeViewModel');

  // -----------------------------------
  // getters
  int? screenTimeLeft;
  ScreenTimeSession? get currentScreenTimeSession => _screenTimeService
      .getScreenTimeSession(uid: session?.uid, sessionId: session?.sessionId);
  ScreenTimeSession? get expiredScreenTime =>
      _screenTimeService.getExpiredScreenTimeSession(
          uid: session?.uid, sessionId: session?.sessionId);

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

  Future initialize() async {
    setBusy(true);

    if (currentScreenTimeSession != null) {
      session = currentScreenTimeSession;
    }

    // start screen time here
    if (session != null &&
        session?.status == ScreenTimeSessionStatus.notStarted) {
      log.i("screen time session will be started");

      // start a NEW screen time session
      session = session!.copyWith(status: ScreenTimeSessionStatus.active);

      // updates session with new id
      session = await _screenTimeService.startScreenTime(
          session: session!, callback: listenToTick);
      justStartedListeningToScreenTime = true;
    }

    // continue screen time here
    if (session != null && session?.status == ScreenTimeSessionStatus.active) {
      log.i(
          "screen time session has started or is active and will be continued");
      int screenTimeLeftInSecondsPreset =
          screenTimeService.getTimeLeftInSeconds(session: session!);
      screenTimeLeft = screenTimeLeftInSecondsPreset;
      notifyListeners();
      // takes surprisingly long to start that listener here so update the screenTimeLeft one before!
      _stopWatchService.listenToSecondTime(
        callback: (int tick) {
          screenTimeLeft = screenTimeLeftInSecondsPreset - tick;
          notifyListeners();
          log.v("Fired listener");
        },
      );
    }

    // if screen time is over and notification is pressed
    bool loadedScreenTime = true;
    // this is the case if we navigate to this view from the expired notification;
    if (session != null &&
        session?.status == ScreenTimeSessionStatus.completed) {
      // this loads the screen time session into memory so it can be accessed with the getter
      // expiredScreenTime
      loadedScreenTime = await _screenTimeService.loadExpiredScreenTimeSession(
          uid: session?.uid, sessionId: session?.sessionId);
      if (loadedScreenTime) {
        session = expiredScreenTime;
      }
    }

    if (session == null || loadedScreenTime == false) {
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
        snackBarTitle = "Cancelled screentime. ";
        snackBarMsg = "No credits are deducted";
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
  }

  void resetStopWatch() {
    _stopWatchService.resetTimer();
  }

  void cancelOnlyActiveScreenTimeSubjectListeners({required String uid}) {
    screenTimeService.cancelOnlyActiveScreenTimeSubjectListeners(uid: uid);
  }

  void listenToTick() {
    notifyListeners();
  }

  @override
  dispose() {
    super.dispose();
    // reset timer
    log.v("Resetting stop watch timer");
    _stopWatchService.resetTimer();
  }
}
