import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

import '../../../notification/notifications.dart';

class ActiveScreenTimeViewModel extends BaseModel {
  // -----------------------------------
  // services
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final log = getLogger('ActiveScreenTimeViewModel');

  // constructor
  final int minutes;
  ActiveScreenTimeViewModel({required this.minutes}) {
    _screenTimeService.startScreenTime(
        minutes: minutes, callback: listenToTick);
    // TODO: This is where we would want to start
    Notifications().createNotifications(message: "Active Screen Time");

    Future.delayed(
      Duration(minutes: 1),
      () async {
        /*  await Notifications()
            .createNotificationsTimesUp(message: "Your Time is Up"); */
        // TODO: This is where we would want to start
        Notifications().createNotifications(message: "Your Time is Up");

        stopScreenTimeAfterZero();
      },
    );
  }

  // getters
  int? get screenTimeLeft => _screenTimeService.hasActiveScreenTime
      ? _screenTimeService.screenTimeLeft
      : -1;
  Future<void> stopScreenTimeAfterZero() async {
    //Notifications().createNotificationsTimesUp(message: "Your Time is Up");
    await Notifications().setNotificationsValues();
    _screenTimeService.stopScreenTime();
    Notifications()
        .dismissNotificationsByChannelKey(channelKey: 'base_channel');
    navigationService.back();

    notifyListeners();
  }

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
      _screenTimeService.stopScreenTime();
      navigationService.back();
      snackbarService.showSnackbar(
        title: "Cancelled screentime",
        message: "",
        duration: Duration(seconds: 1),
      );
    }
  }

  void listenToTick(int tick) {
    notifyListeners();
  }
}
