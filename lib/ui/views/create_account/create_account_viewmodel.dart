import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/users/afkcredits_authentication_result_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/authentication_viewmodel.dart';
import 'package:afkcredits/ui/views/create_account/create_account_view.form.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app_config_provider.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class CreateAccountViewModel extends AuthenticationViewModel {
  final UserRole role;
  CreateAccountViewModel({required this.role}) : super(role: role);
  final log = getLogger("CreateAccountViewModel");
  final UserService _userService = locator<UserService>();
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();

  final _navigationService = locator<NavigationService>();

  @override
  Future<AFKCreditsAuthenticationResultService> runAuthentication(
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
      _navigationService.replaceWith(Routes.createAccountUserRoleView);

  @override
  Future<FirebaseAuthenticationResult> runAdminAuthResult() =>
      _firebaseAuthenticationService!.createAccountWithEmail(
        email:
            _flavorConfigProvider.getTestUserEmail(UserRole.adminMaster).trim(),
        password: _userService
            .hashPassword(_flavorConfigProvider.getTestUserPassword()),
      );
}
