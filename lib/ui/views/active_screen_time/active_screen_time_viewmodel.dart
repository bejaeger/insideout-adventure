import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

import '../../../notification/notifications.dart';

class ActiveScreenTimeViewModel extends BaseModel {
  // -----------------------------------
  // services
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();

  // constructor
  final int minutes;
  ActiveScreenTimeViewModel({required this.minutes}) {
    _screenTimeService.startScreenTime(
        minutes: minutes, callback: listenToTick);

    // TODO: This is where we would want to start
    Notifications().unlockedAchievement(message: "Active Screen Time");
  }

  void dismissNotificationsByChannelKey({required String channelKey}) {
    Notifications().dismissNotificationsByChannelKey(channelKey);
  }

  // getters
  int? get screenTimeLeft => _screenTimeService.hasActiveScreenTime
      ? _screenTimeService.screenTimeLeft
      : -1;
  Future<void> stopScreenTimeAfterZero() async {
    await setNotificationsValues();
    _screenTimeService.stopScreenTime();
    dismissNotificationsByChannelKey(channelKey: 'base_channel');
    navigationService.back();

    notifyListeners();
  }

  Future<void> setNotificationsValues() async {
    final currentBadgeCounter = await Notifications().getBadgeIndicator();

    //Set the Global Counter to a New Value
    Notifications().setBadgeIndicator(currentBadgeCounter);
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
      await setNotificationsValues();
      _screenTimeService.stopScreenTime();
      navigationService.back();
      snackbarService.showSnackbar(
          title: "Cancelled screentime",
          message: "",
          duration: Duration(seconds: 1));
    }
  }

  void listenToTick(int tick) {
    notifyListeners();
  }
}
