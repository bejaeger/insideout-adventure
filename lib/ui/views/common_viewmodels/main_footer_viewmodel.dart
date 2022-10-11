import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

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
        barrierDismissible: true,
        title: "Sure",
        description: "Are you sure you want to logout?",
        buttonTitle: "YES",
        cancelTitle: "NO");
    if (result?.confirmed == true) {
      logout();
    }
  }

  void showExplorerSettingsDialog() async {
    await dialogService.showCustomDialog(
        variant: DialogType.ExplorerSettings, barrierDismissible: true);
  }
}
