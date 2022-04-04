import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SelectScreenTimeViewModel extends BaseModel {
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  int get totalAvailableScreenTime =>
      _screenTimeService.totalAvailableScreenTime;

  Future startScreenTime() async {
    // Function that starts screen time
    // Should ultimately do the following:

    // 1. Check if there was a preset time selected (15min, 30min, ...)

    // 2. Check whether enough credits are available

    // 3. Show prompt for parents to confirm (we omit this for now!)

    // 4. Navigate to Active Screen Time Screen

    // 5. Show PERMANENT notification!
    // - When user (parent) goes to different apps, he should be able to
    // see the time still left in the notification
    // - By tapping the notification he should be navigated to the active screen time screen,

    navigationService.navigateTo(Routes.activeScreenTimeView,
        arguments: ActiveScreenTimeViewArguments(minutes: 1));
  }
}
