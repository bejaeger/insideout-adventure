import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/users/afkcredits_authentication_result_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/authentication_viewmodel.dart';
import 'package:afkcredits/ui/views/login/login_view.form.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends AuthenticationViewModel {
  final FirebaseAuthenticationService _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  bool checkUserRole = true;
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  final log = getLogger("LoginViewModel");
  final UserService _userService = locator<UserService>();
  final AppConfigProvider flavorConfigProvider = locator<AppConfigProvider>();
  final DialogService _dialogService = locator<DialogService>();

  String get getReleaseName => flavorConfigProvider.appName;

  String? emailOrNameInputValidationMessage;
  String? passwordInputValidationMessage;

  dynamic userLoginTapped({UserRole? userRole}) {
    if (userRole == null) {
      return () {
        if (!isValidUserInput()) {
          notifyListeners();
          return;
        }
        saveData(AuthenticationMethod.EmailOrSponsorCreatedExplorer);
      };
    } else {
      if (_flavorConfigProvider.flavor == Flavor.dev) {
        return () {
          saveData(AuthenticationMethod.dummy, userRole);
        };
      }
      // ? do not provide dummy login also in prod database!
      if (_flavorConfigProvider.flavor == Flavor.prod) {
        return null;
      }
    }
  }

  bool isValidUserInput() {
    bool returnVal = true;
    if (emailOrNameValue == null) {
      emailOrNameInputValidationMessage =
          'Please provide a valid email address';
      returnVal = false;
    }
    if (passwordValue == null) {
      passwordInputValidationMessage = "Please provide a password";
      returnVal = false;
    }
    if (emailOrNameValue == "") {
      emailOrNameInputValidationMessage =
          'Please provide a valid email address';
      returnVal = false;
    }
    if (passwordValue == "") {
      passwordInputValidationMessage = "Please provide a password";
      returnVal = false;
    }
    return returnVal;
  }

  bool isValidEmail() {
    bool returnVal = true;
    if (emailOrNameValue == "" || emailOrNameValue == null) {
      returnVal = false;
    }
    return returnVal;
  }

  void resetValidationMessages() {
    emailOrNameInputValidationMessage = null;
    passwordInputValidationMessage = null;
    notifyListeners();
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

  Future onForgotPassword() async {
    if (emailOrNameValue == "" || emailOrNameValue == null) {
      await _dialogService.showDialog(
          title: "Enter email and tap again",
          description: "We will send you a password reset link");
      return;
    } else {
      final response = await _dialogService.showDialog(
          title: "Send email to $emailOrNameValue?",
          description: "We will send you an email with a password reset link",
          buttonTitle: "Send email",
          cancelTitle: "Cancel");
      if (response?.confirmed == true) {
        bool res = await _firebaseAuthenticationService
            .sendResetPasswordLink(emailOrNameValue!);
        if (res == true) {
          await _dialogService.showDialog(
            title: "Check your inbox",
            description: "We sent you a password reset link.",
            buttonTitle: "Ok",
          );
        } else {
          await _dialogService.showDialog(
            title: "Sending email failed",
            description:
                "Are you sure you already registered with $emailOrNameValue?",
            buttonTitle: "Try again",
          );
        }
      }
    }
  }

  void navigateToCreateAccount() {
    navToSponsorCreateAccount(role: UserRole.sponsor);
  }

  bool isPwShown = false;
  setIsPwShown(bool show) {
    isPwShown = show;
    notifyListeners();
  }

  void showNotImplementedSnackbar() {
    _snackbarService.showSnackbar(
        title: "Not yet implemented.",
        message: "I know... it's sad",
        duration: Duration(seconds: 1));
  }

  void setFormStatus() {
    log.i('Set the form status with data: $formValueMap');
    resetValidationMessages();
  }
}
