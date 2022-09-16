import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/notifications/notification_controller.dart';
import 'package:afkcredits/notifications/notifications.dart';
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
  ScreenTimeSession? get currentScreenTimeSession =>
      _screenTimeService.getScreenTimeSession(uid: session?.uid);
  String get childName => session != null ? session!.userName : "";

  // ---------------------------
  // constructor
  // used to start screen time
  ScreenTimeSession? session;
  // used if previous screen time session was found
  final String? screenTimeSessionId;
  ActiveScreenTimeViewModel({required this.session, this.screenTimeSessionId});

  // ------------------------------
  // state
  bool justStartedListeningToScreenTime = false;

  Future initialize() async {
    setBusy(true);

    if (session != null &&
        session?.status == ScreenTimeSessionStatus.notStarted) {
      log.i("screen time session will be started");

      // start a NEW screen time session
      DateTime endDate =
          DateTime.now().add(Duration(minutes: session!.minutes));
      session = session!.copyWith(status: ScreenTimeSessionStatus.active);
      await _screenTimeService.startScreenTime(
          session: session!, callback: listenToTick);
      justStartedListeningToScreenTime = true;

      // create notifications
      Notifications().createPermanentNotification(
          title: "Screen time until " + formatDateToShowTime(endDate),
          message: session!.userName + " is using screen time");
      // schedule notification
      Notifications().createScheduledNotification(
          title: "Screen time expired!",
          message: session!.userName + "'s screen time expired.",
          date: endDate);
    }

    if (session != null && session?.status == ScreenTimeSessionStatus.active) {
      log.i("screen time session is active and will be continued");
      // previous screen time session found on disk
      // Try to continue or finish this session!

      // Need to start a timer here
      // that counts down the screen time
      // Only listen again and subtract difference if timer is
      // not already running!
      if (!_stopWatchService.isRunning) {
        int screenTimeLeftInSecondsPreset =
            screenTimeService.getTimeLeftInSeconds(session: session!);
        _stopWatchService.listenToSecondTime(
          callback: (int tick) {
            screenTimeLeft = screenTimeLeftInSecondsPreset - tick;
            notifyListeners();
          },
        );
      }
    }

    if (session == null) {
      log.wtf("session is null, cannot navigate to active screen time view");
      setBusy(false);

      popView();
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
              screenTimeLeft.toString() +
              " seconds left."); //, mainButtonTitle: "CANCEL", )
    }
    if (result == null || result?.confirmed == true) {
      await NotificationController().dismissPermanentNotifications();
      await NotificationController().dismissScheduledNotifications();
      final currentScreenTime =
          screenTimeService.getScreenTime(uid: session.uid);
      if (currentScreenTime != null) {
        final res =
            await _screenTimeService.stopScreenTime(session: currentScreenTime);
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
  }

  void resetStopWatch() {
    _stopWatchService.resetTimer();
  }

  void listenToTick() {
    notifyListeners();
  }
}
