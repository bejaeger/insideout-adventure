import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class SelectScreenTimeViewModel extends BaseModel {
  // ----------------------------------
  // services
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final log = getLogger("SelectScreenTimeViewModel");

  // ------------------------------------
  // getters
  int get totalAvailableScreenTime =>
      _screenTimeService.totalAvailableScreenTime;

// ------------------------
  // state
  int screenTimePreset = 15; // in minutes

  // ------------------
  // constructor
  SelectScreenTimeViewModel() {
    if (screenTimePreset > totalAvailableScreenTime) {
      screenTimePreset = totalAvailableScreenTime;
    }
  }

  // ---------------------------------
  // functions

  // preset screen time selecter / switcher
  void selectScreenTime({required int minutes}) {
    log.v("set screen time preset to $minutes min");
    screenTimePreset = minutes;
    if (screenTimePreset == -1) {
      screenTimePreset = _screenTimeService.totalAvailableScreenTime;
    }
    notifyListeners();
  }

  Future startScreenTime() async {
    // Function that starts screen time
    // Should ultimately do the following:

    // 1. Check whether enough credits are available
    if (screenTimePreset > totalAvailableScreenTime) {
      await dialogService.showDialog(
          title: "Sorry", description: "You don't have enough credits.");
      return;
    }

    // 2. Show prompt for parents to confirm (we omit this for now!)

    // 3. Navigate to Active Screen Time Screen

    // 4. Show PERMANENT notification!
    // - When user (parent) goes to different apps, he should be able to
    // see the time still left in the notification
    // - By tapping the notification he should be navigated to the active screen time screen,

    // 5. Final confirmation
    dynamic result = await dialogService.showDialog(
        buttonTitle: "YES",
        cancelTitle: "NO",
        title: "Sure?",
        description:
            "Do you want to start $screenTimePreset min screen time?"); //, mainButtonTitle: "CANCEL", )

    // 6. Start screen time
    if (result == null || result?.confirmed == true) {
      navigationService.navigateTo(Routes.activeScreenTimeView,
          arguments: ActiveScreenTimeViewArguments(minutes: screenTimePreset));
    }
  }
}
