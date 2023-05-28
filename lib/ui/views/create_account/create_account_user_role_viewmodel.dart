import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SelectUserRoleViewModel extends BaseModel {
  void navigateToWardCreateAccount() {
    navToWardCreateAccount(role: UserRole.ward);
  }

  void navigateToGuardianCreateAccount() {
    navToGuardianCreateAccount(role: UserRole.guardian);
  }

  void navigateToLoginView() {
    navToLoginView();
  }
}
