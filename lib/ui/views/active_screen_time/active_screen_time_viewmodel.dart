import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

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
    // a permanent notification!
  }

  // getters
  int? get screenTimeLeft => _screenTimeService.hasActiveScreenTime
      ? _screenTimeService.screenTimeLeft
      : -1;

  // functions
  Future stopScreenTime() async {
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
