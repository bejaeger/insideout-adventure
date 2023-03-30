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
import 'package:stacked_services/stacked_services.dart';

class CreateAccountViewModel extends AuthenticationViewModel {
  final UserRole role;
  CreateAccountViewModel({required this.role}) : super(role: role);

  final log = getLogger("CreateAccountViewModel");
  final UserService _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();

  String? emailInputValidationMessage;
  String? passwordInputValidationMessage;
  String? fullNameInputValidationMessage;

  void Function()? onSignUpTapped() {
    return () {
      if (!isValidUserInput()) {
        notifyListeners();
        return;
      }
      saveData(AuthenticationMethod.email);
    };
  }

  bool isValidUserInput() {
    bool returnVal = true;
    if (emailValue == null || emailValue == "") {
      emailInputValidationMessage = 'Please provide a valid email address';
      returnVal = false;
    }
    if (passwordValue == null || passwordValue == "") {
      passwordInputValidationMessage = "Please provide a password";
      returnVal = false;
    }
    if (fullNameValue == null || fullNameValue == "") {
      fullNameInputValidationMessage = 'Please provide a valid name';
      returnVal = false;
    }
    if (emailValue != null) {
      bool emailValid =
          RegExp(r"^([a-zA-Z0-9_+\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
              .hasMatch(emailValue!);
      if (!emailValid) {
        emailInputValidationMessage = 'Please provide a valid email address';
        returnVal = false;
      }
    }
    if (passwordValue != null) {
      if (passwordValue!.length < 4) {
        emailInputValidationMessage =
            'Please choose a password that is at least 4 characters long.';
        returnVal = false;
      }
    }
    return returnVal;
  }

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

  void replaceWithLoginView() =>
      _navigationService.replaceWith(Routes.loginView);

  void resetValidationMessages() {
    emailInputValidationMessage = null;
    fullNameInputValidationMessage = null;
    passwordInputValidationMessage = null;
    notifyListeners();
  }

  void setFormStatus() {
    log.i('Set the form status with data: $formValueMap');
    resetValidationMessages();
  }
}
