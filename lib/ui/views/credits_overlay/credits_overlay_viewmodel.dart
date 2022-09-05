import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class CreditsOverlayViewModel extends BaseModel {
  // -------------------------------------
  // services
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final log = getLogger("CreditsOverlayViewModel");

  // ------------------------------------
  // getters
  int get totalAvailableScreenTime =>
      _screenTimeService.getTotalAvailableScreenTime();
  int get afkCreditsBalance =>
      _screenTimeService.getAfkCreditsBalance().round();

  // ------------------------
  // state
  StreamSubscription? subscription;

  // initialize function
  void listenToLayout() {
    if (subscription == null) {
      subscription =
          layoutService.isShowingCreditsOverlaySubject.listen((show) {
        notifyListeners();
      });
    } else {
      log.wtf("isShowingCreditsOverlay already listened to");
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }
}
