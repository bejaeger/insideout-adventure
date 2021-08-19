import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/authentication_viewmodel.dart';
import 'package:afkcredits/ui/views/create_account/create_account_view.form.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class CreateAccountViewModel extends AuthenticationViewModel {
  final UserRole role;
  CreateAccountViewModel({required this.role}) : super(role: role);
  final log = getLogger("CreateAccountViewModel");
  final UserService _userService = locator<UserService>();

  @override
  Future<FirebaseAuthenticationResult> runAuthentication(
      AuthenticationMethod method,
      [UserRole? role]) async {
    return await _userService.runCreateAccountLogic(
        method: method,
        role: this.role,
        fullName: fullNameValue,
        email: emailValue,
        password: passwordValue);
  }

  void replaceWithSelectRoleView() =>
      navigationService.replaceWith(Routes.createAccountUserRoleView);
}
