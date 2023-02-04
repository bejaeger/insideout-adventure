import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SelectUserRoleViewModel extends BaseModel {

  void navigateToExplorerCreateAccount() {
    navToExplorerCreateAccount(role: UserRole.explorer);
  }

  void navigateToSponsorCreateAccount() {
    navToSponsorCreateAccount(role: UserRole.sponsor);
  }

  void navigateToLoginView() {
    navToLoginView();
  }
}
