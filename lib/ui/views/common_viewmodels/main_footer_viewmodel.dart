import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';

class MainFooterViewModel extends SwitchAccountsViewModel {
  bool isMenuOpen = false;

  void listenToLayout() {
    layoutService.isShowingQuestListSubject.listen((show) {
      notifyListeners();
    });
  }
}
