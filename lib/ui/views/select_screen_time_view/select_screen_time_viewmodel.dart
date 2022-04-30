import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SelectScreenTimeViewModel extends BaseModel {
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  int get totalAvailableScreenTime =>
      _screenTimeService.totalAvailableScreenTime;

  Future startScreenTime() async {
    navigationService.navigateTo(
      Routes.activeScreenTimeView,
      arguments: ActiveScreenTimeViewArguments(minutes: 1),
    );
  }
}
