import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectRoleAfterLoginViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();
  final log = getLogger("SelectRoleAfterLoginViewModel");
  final AuthenticationMethod authMethod;

  SelectRoleAfterLoginViewModel({required this.authMethod});

  void navigateToLoginView() {
    _navigationService.replaceWith(Routes.loginView);
  }

  void createAccountAndNavigateToHome({required UserRole role}) async {
    try {
      await _userService.createUserAccountFromFirebaseUser(
          role: role, authMethod: authMethod);
      await _userService.syncUserAccount();
      replaceWithHomeView();
    } catch (e) {
      log.e("Could not create user account, error: $e");
    }
  }
}
