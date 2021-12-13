import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/transfer_base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectRoleAfterLoginViewModel extends TransferBaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();
  final log = getLogger("SelectRoleAfterLoginViewModel");
  final AuthenticationMethod authMethod;

  SelectRoleAfterLoginViewModel({required this.authMethod});

  void navigateToLoginView() {
    _navigationService.replaceWith(Routes.loginView);
  }

  Future createSponsorAccountAndNavigateToSponsorHome() async {
    try {
      setBusy(true);
      await _userService.createUserAccountFromFirebaseUser(
          role: UserRole.sponsor, authMethod: authMethod);
      await _userService.syncUserAccount();
      replaceWithHomeView();
      setBusy(false);
    } catch (e) {
      // TODO: Proper error message to user
      log.e("Could not create user account, error: $e");
    }
  }

  Future createExploreAccountAndNavigateToExplorerHome() async {
    try {
      setBusy(true);
      await _userService.createUserAccountFromFirebaseUser(
          role: UserRole.explorer, authMethod: authMethod);
      await _userService.syncUserAccount();
      replaceWithHomeView();
      setBusy(false);
    } catch (e) {
      // TODO: Proper error message to user
      log.e("Could not create user account, error: $e");
    }
  }

  Future createAdminAccountAndNavigateToExplorerHome() async {
    try {
      setBusy(true);
      await _userService.createUserAccountFromFirebaseUser(
          role: UserRole.admin, authMethod: authMethod);
      await _userService.syncUserAccount();
      replaceWithHomeView();
      setBusy(false);
    } catch (e) {
      // TODO: Proper error message to user
      log.e("Could not create user account, error: $e");
    }
  }
}
