import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class SelectRoleAfterLoginViewModel extends BaseModel {
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
      _navigationService.replaceWith(Routes.sponsorHomeView);
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
      _navigationService.replaceWith(Routes.explorerHomeView);
      setBusy(false);
    } catch (e) {
      // TODO: Proper error message to user
      log.e("Could not create user account, error: $e");
    }
  }
}
