import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectUserRoleViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  void navigateToExplorerCreateAccount() {
    _navigationService.replaceWith(Routes.createAccountView,
        arguments: CreateAccountViewArguments(role: UserRole.explorer));
  }

  void navigateToSponsorCreateAccount() {
    _navigationService.replaceWith(Routes.createAccountView,
        arguments: CreateAccountViewArguments(role: UserRole.sponsor));
  }

  void navigateToAdminCreateAccount() {
    _navigationService.replaceWith(Routes.createAccountView,
        arguments: CreateAccountViewArguments(role: UserRole.admin));
  }

  void navigateToLoginView() {
    _navigationService.replaceWith(Routes.loginView);
  }
}
