import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
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

  dynamic userLoginTapped({required UserRole userRole}) async {
    if (_flavorConfigProvider.flavor == Flavor.dev &&
        userRole == UserRole.explorer) {
      return () => saveData(AuthenticationMethod.dummy, UserRole.explorer);
    } else if (_flavorConfigProvider.flavor == Flavor.dev &&
        userRole == UserRole.sponsor) {
      return () => saveData(AuthenticationMethod.dummy, UserRole.sponsor);
    } else if (_flavorConfigProvider.flavor == Flavor.dev &&
        userRole == UserRole.admin) {
      return () => runAdminAuthentication(
          role: UserRole.admin,
          email: 'admin@gmailcom',
          password: 'password',
          method: AuthenticationMethod.dummy);
      // return () => saveData(AuthenticationMethod.dummy, UserRole.admin);
    } else {
      return null;
    }
  }

/*   

dynamic onDummyLoginAdminTapped() {
    if (_flavorConfigProvider.flavor == Flavor.dev) {
      //return () => saveData(AuthenticationMethod.dummy, UserRole.admin);
    } else {
      return null;
    }
  }

dynamic onDummyLoginExplorerTapped() {
    if (_flavorConfigProvider.flavor == Flavor.dev) {
      //return () => saveData(AuthenticationMethod.dummy, UserRole.explorer);
    } else {
      return null;
    }
  }

  dynamic onDummyLoginSponsorTapped() {
    if (_flavorConfigProvider.flavor == Flavor.dev) {
      return () => saveData(AuthenticationMethod.dummy, UserRole.sponsor);
    } else {
      return null;
    }
  } */

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

  Future<AFKCreditsAuthenticationResultService> runAdminAuthentication(
      {required AuthenticationMethod method,
      required UserRole? role,
      required String email,
      required String password}) async {
    return await _userService.runLoginLogic(
        method: method, emailOrName: email, stringPw: password, role: role);
  }

  void navigateToCreateAccount() {
    navigationService.replaceWith(Routes.createAccountUserRoleView);
  }

  bool isPwShown = false;
  setIsPwShown(bool show) {
    isPwShown = show;
    notifyListeners();
  }
}
