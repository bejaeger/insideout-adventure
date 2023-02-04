import 'dart:async';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class CreditsOverlayViewModel extends BaseModel {
  final log = getLogger("CreditsOverlayViewModel");

  int get totalAvailableScreenTime => userService.getTotalAvailableScreenTime();
  int get afkCreditsBalance => userService.getAfkCreditsBalance().round();

  StreamSubscription? subscription;

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
