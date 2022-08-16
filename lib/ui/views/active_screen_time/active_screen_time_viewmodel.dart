import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/notifications/notifications.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/string_utils.dart';

class ActiveScreenTimeViewModel extends BaseModel {
  // -----------------------------------
  // services
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final log = getLogger('ActiveScreenTimeViewModel');

  // -----------------------------------
  // getters
  int? get screenTimeLeft => _screenTimeService.hasActiveScreenTime
      ? _screenTimeService.screenTimeLeftInSeconds
      : -1;
  ScreenTimeSession? get currentScreenTimeSession =>
      _screenTimeService.currentSession;
  String get childName =>
      session != null ? userService.explorerNameFromUid(session!.uid) : "";
  // constructor
  // used to start screen time
  ScreenTimeSession? session;
  // used if previous screen time session was found
  final String? screenTimeSessionId;
  ActiveScreenTimeViewModel({required this.session, this.screenTimeSessionId});

  Future initialize() async {
    setBusy(true);
    if (screenTimeSessionId != null) {
      // previous screen time session found on disk
      // Try to continue or finish this session!
      session =
          await _screenTimeService.continueOrBookkeepScreenTimeSessionOnStartup(
              sessionId: screenTimeSessionId!, callback: listenToTick);
    } else {
      if (session == null) {
        showGenericInternalErrorDialog();
        popView();
        return;
      }

      // start a NEW screen time session
      DateTime endDate =
          DateTime.now().add(Duration(minutes: session!.minutes));

      // start screen time session
      _screenTimeService.startScreenTime(
          session: session!, callback: listenToTick);

      // create permanent notification
      Notifications().createPermanentNotification(
          title: "Screen time until " + formatDateToShowTime(endDate),
          message: userService.explorerNameFromUid(session!.uid) +
              " is using screen time");
      // schedule notification
      Notifications().createScheduledNotification(
          title: "Screen time is over!",
          message: userService.explorerNameFromUid(session!.uid) +
              "'s screen time expired.",
          date: endDate);
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
  Future stopScreenTime() async {
    //int counter = 1;

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
      await Notifications().setNotificationsValues();
      await Notifications().dismissPermanentNotifications();
      await Notifications().dismissScheduledNotifications();
      final res = await _screenTimeService.stopScreenTime();
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
      replaceWithHomeView();
      snackbarService.showSnackbar(
        title: snackBarTitle,
        message: snackBarMsg,
        duration: Duration(seconds: 1),
      );
    }
  }

  void listenToTick() {
    notifyListeners();
  }
}
