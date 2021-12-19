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
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends AuthenticationViewModel {
  //    kIsWeb ? Routes.walletView : Routes.layoutTemplateViewMobile);
  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  bool checkUserRole = true;
  final _navigationService = locator<NavigationService>();
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

  Future<AFKCreditsAuthenticationResultService?> runAdminAuthentication(
      {required AuthenticationMethod method,
      required UserRole? role,
      required String email,
      required String password}) async {
    final result = await _userService.runLoginLogic(
        method: method, emailOrName: email, stringPw: password, role: role);
    return result;
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
