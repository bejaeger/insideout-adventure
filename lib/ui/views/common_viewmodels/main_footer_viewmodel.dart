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
        title: "Sure",
        description: "Are you sure you want to logout?",
        buttonTitle: "YES",
        cancelTitle: "NO");
    if (result?.confirmed == true) {
      logout();
    }
  }
}
