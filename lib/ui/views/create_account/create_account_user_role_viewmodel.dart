import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SelectUserRoleViewModel extends BaseModel {
  //final NavigationService _navigationService = locator<NavigationService>();

  void navigateToExplorerCreateAccount() {
    navToExplorerCreateAccount(role: UserRole.explorer);
/*     _navigationService.replaceWith(Routes.createAccountView,
        arguments: CreateAccountViewArguments(role: UserRole.explorer)); */
  }

  void navigateToSponsorCreateAccount() {
    navToSponsorCreateAccount(role: UserRole.sponsor);
    /*   _navigationService.replaceWith(Routes.createAccountView,
        arguments: CreateAccountViewArguments(role: UserRole.sponsor)); */
  }

  void navigateToAdminCreateAccount() {
    navToAdminCreateAccount(role: UserRole.adminMaster);
    /*    _navigationService.replaceWith(Routes.createAccountView,
        arguments: CreateAccountViewArguments(role: UserRole.adminMaster)); */
  }

  void navigateToLoginView() {
    navToLoginView();
    //_navigationService.replaceWith(Routes.loginView);
  }
}
