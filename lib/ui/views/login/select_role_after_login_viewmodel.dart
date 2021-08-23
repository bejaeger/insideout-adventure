import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/layout_template_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectRoleAfterLoginViewModel extends LayoutTemplateViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();
  final log = getLogger("SelectRoleAfterLoginViewModel");

  SelectRoleAfterLoginViewModel();

  void navigateToLoginView() {
    _navigationService.replaceWith(Routes.loginView);
  }

  Future createSponsorAccountAndNavigateToSponsorHome() async {
    try {
      setBusy(true);
      await _userService.createUserAccountFromFirebaseUser(
          role: UserRole.sponsor);
      await _userService.syncUserAccount();
      replaceToHomeView();
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
          role: UserRole.explorer);
      await _userService.syncUserAccount();
      replaceToHomeView();
      setBusy(false);
    } catch (e) {
      // TODO: Proper error message to user
      log.e("Could not create user account, error: $e");
    }
  }
}
