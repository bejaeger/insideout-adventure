import 'dart:async';

import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class ExplorerAccountViewModel extends BaseModel {
  // ----------------------
  // services
  final log = getLogger("ExplorerAccountViewModel");

  // ------------------------
  // state
  StreamSubscription? subscription;

  void listenToLayout() {
    if (subscription == null) {
      subscription =
          layoutService.isShowingExplorerAccountSubject.listen((show) {
        notifyListeners();
      });
    } else {
      log.wtf("isShowingExplorerAccount already listened to");
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }
}
