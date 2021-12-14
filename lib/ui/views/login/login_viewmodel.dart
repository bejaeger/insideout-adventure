import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/users/admin/user_admin.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/users/afkcredits_authentication_result_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/authentication_viewmodel.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:afkcredits/ui/views/login/login_view.form.dart';

class LoginViewModel extends AuthenticationViewModel {
  //    kIsWeb ? Routes.walletView : Routes.layoutTemplateViewMobile);
  bool checkUserRole = true;
  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();
  final log = getLogger("LoginViewModel");
  final UserService _userService = locator<UserService>();
  final FlavorConfigProvider flavorConfigProvider =
      locator<FlavorConfigProvider>();
  String get getReleaseName => flavorConfigProvider.appName;

  dynamic userLoginTapped({required UserRole userRole}) {
    if (_flavorConfigProvider.flavor == Flavor.dev &&
        userRole == UserRole.explorer) {
      return () => saveData(AuthenticationMethod.dummy, UserRole.explorer);
    } else if (_flavorConfigProvider.flavor == Flavor.dev &&
        userRole == UserRole.sponsor) {
      return () => saveData(AuthenticationMethod.dummy, UserRole.sponsor);
    } else if (_flavorConfigProvider.flavor == Flavor.dev &&
        userRole == UserRole.adminMaster) {
      //This code needs to be moved accordingly, based on the discussion Ben and I will have.
      return () => createAdminUser(
          userAdmin: UserAdmin(
              id: _flavorConfigProvider.getTestUserId(UserRole.adminMaster),
              role: UserRole.adminMaster,
              email:
                  _flavorConfigProvider.getTestUserEmail(UserRole.adminMaster),
              password: _userService
                  .hashPassword(_flavorConfigProvider.getTestUserPassword())));
    } else {
      return null;
    }
  }

  @override
  Future<AFKCreditsAuthenticationResultService> runAuthentication(
    AuthenticationMethod method, [
    UserRole? role,
  ]) async {
    return await _userService.runLoginLogic(
        method: method,
        emailOrName: emailOrNameValue,
        stringPw: passwordValue,
        role: role);
  }

  Future<AFKCreditsAuthenticationResultService?> runAdminAuthentication(
      {required AuthenticationMethod method,
      required UserRole? role,
      required String email,
      required String password}) async {
    final result = await _userService.runLoginLogic(
        method: method, emailOrName: email, stringPw: password, role: role);
/*     if (!result.hasError) {
      navigateToAdminHomeView();
    } */
    return result;
  }
  //This code needs to be moved accordingly, based on the discussion Ben and I will have.

  Future createAdminUser({required UserAdmin userAdmin}) async {
    await _userService.createUserAdminAccount(userAdmin: userAdmin);
    navigateToAdminHomeView(role: userAdmin.role!);
  }

  void navigateToCreateAccount() {
    navigationService.replaceWith(Routes.createAccountUserRoleView);
  }
  //This code needs to be moved accordingly, based on the discussion Ben and I will have.

  void navigateToAdminHomeView({required UserRole role}) {
    //navigationService.replaceWith(Routes.homeView);
    navigationService.replaceWith(Routes.bottomBarLayoutTemplateView,
        arguments: BottomBarLayoutTemplateViewArguments(userRole: role));
  }

  bool isPwShown = false;
  setIsPwShown(bool show) {
    isPwShown = show;
    notifyListeners();
  }
}
