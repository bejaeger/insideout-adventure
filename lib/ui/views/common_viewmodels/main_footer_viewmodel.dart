import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../services/local_storage_service.dart';

class MainFooterViewModel extends BaseModel {
  // services

  // state variables
  bool isMenuOpen = false;

  // TODO: Maybe make this a reactive value!
  void listenToLayout() {
    layoutService.isShowingQuestListSubject.listen((show) {
      notifyListeners();
    });
  }

  void handleLogoutEvent() async {
    final result = await dialogService.showDialog(
        title: "Sure",
        description: "Are you sure you want to logout?",
        buttonTitle: "YES",
        cancelTitle: "NO");
    if (result?.confirmed == true) {
      logout();
    }
  }
}
