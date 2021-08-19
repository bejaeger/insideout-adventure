import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/authentication_viewmodel.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:afkcredits/ui/views/login/login_view.form.dart';

class LoginViewModel extends AuthenticationViewModel {
  //    kIsWeb ? Routes.walletView : Routes.layoutTemplateViewMobile);
  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();
  final log = getLogger("LoginViewModel");
  final UserService _userService = locator<UserService>();

  dynamic onDummyLoginExplorerTapped() {
    if (_flavorConfigProvider.flavor == Flavor.dev) {
      return () => saveData(AuthenticationMethod.dummy, UserRole.explorer);
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
  }

  @override
  Future<FirebaseAuthenticationResult> runAuthentication(
      AuthenticationMethod method,
      [UserRole? role]) {
    return _userService.runLoginLogic(
        method: method, email: emailValue, password: passwordValue, role: role);
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
