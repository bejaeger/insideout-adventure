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

  // constructor
  final int minutes;
  ActiveScreenTimeViewModel({required this.minutes}) {
    ScreenTimeSession session = ScreenTimeSession(
      sessionId: "",
      uid: currentUser.uid,
      minutes: minutes,
      status: ScreenTimeSessionStatus.active,
      afkCredits: double.parse(screenTimeToCredits(minutes).toString()),
    );

    DateTime endDate = DateTime.now().add(Duration(minutes: minutes));

    // start screen time session
    _screenTimeService.startScreenTime(
        session: session, callback: listenToTick);

    // create permanent notification
    Notifications().createPermanentNotification(
        title: "Screen time until " + formatDateToShowTime(endDate),
        message: currentUser.fullName + " is using screen time");
    Notifications().createScheduledNotification(
        title: "Screen time is over!",
        message: currentUser.fullName + "'s screen time expired.",
        date: endDate);

    // TODO: Schedule a notification.
    // Notifications().createNotificationsTimesUp(message: "Your Time is Up");
    // stopScreenTimeAfterZero();
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
      _screenTimeService.stopScreenTime();
      navigationService.back();
      snackbarService.showSnackbar(
        title: "Cancelled screentime",
        message: "",
        duration: Duration(seconds: 1),
      );
    }
  }

  void listenToTick() {
    notifyListeners();
  }
}
