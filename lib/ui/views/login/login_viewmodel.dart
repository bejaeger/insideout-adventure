import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/services/users/afkcredits_authentication_result_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/authentication_viewmodel.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:afkcredits/ui/views/login/login_view.form.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends AuthenticationViewModel {
  //    kIsWeb ? Routes.walletView : Routes.layoutTemplateViewMobile);
  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  bool checkUserRole = true;
  final _navigationService = locator<NavigationService>();
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  final log = getLogger("LoginViewModel");
  final UserService _userService = locator<UserService>();
  final AppConfigProvider flavorConfigProvider = locator<AppConfigProvider>();
  String get getReleaseName => flavorConfigProvider.appName;

  dynamic userLoginTapped({required UserRole userRole}) {
    if (_flavorConfigProvider.flavor == Flavor.dev) {
      return () => saveData(AuthenticationMethod.dummy, userRole);
    }
    // provide dummy login also in prod database!
    if (_flavorConfigProvider.flavor == Flavor.prod) {
      return () => saveData(AuthenticationMethod.dummy, userRole);
    }
  }

/*   @override
  Future<FirebaseAuthenticationResult> runAdminAuthResult() =>
      _userService.createUserAdminAccount(
        userAdmin: UserAdmin(
            id: _flavorConfigProvider.getTestUserId(UserRole.adminMaster),
            role: UserRole.adminMaster,
            email: _flavorConfigProvider.getTestUserEmail(UserRole.adminMaster),
            password: _userService
                .hashPassword(_flavorConfigProvider.getTestUserPassword())),
        method: AuthenticationMethod.dummy,
      ); */

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

  void navigateToCreateAccount() {
    _navigationService.replaceWith(Routes.createAccountUserRoleView);
  }

  bool isPwShown = false;
  setIsPwShown(bool show) {
    isPwShown = show;
    notifyListeners();
  }

  @override
  Future<FirebaseAuthenticationResult> runAdminAuthResult() =>
      _firebaseAuthenticationService!.createAccountWithEmail(
        email:
            _flavorConfigProvider.getTestUserEmail(UserRole.adminMaster).trim(),
        password: _userService
            .hashPassword(_flavorConfigProvider.getTestUserPassword()),
      );
}
