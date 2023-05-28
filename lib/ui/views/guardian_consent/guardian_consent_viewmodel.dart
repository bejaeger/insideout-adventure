import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/enums/guardian_verification_status.dart';
import 'package:afkcredits/services/email_service/email_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/guardian_consent/guardian_consent_view.form.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GuardianConsentViewModel extends FormViewModel {
  final UserService _userService = locator<UserService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final EmailService _emailService = locator<EmailService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final log = getLogger("AddExplorerViewModel");

  void Function() disposeController;
  GuardianConsentViewModel({required this.disposeController});

  String get email => _userService.currentUserNullable?.email ?? "";
  bool isLoading = false;
  int pageIndex = 0;
  bool verifiedCode = false;
  String code = "B4T6";
  DateTime? timeSentEmail;

  Future sendConsentEmail(PageController controller,
      {bool resend = false}) async {
    if (!isValidEmail()) {
      return;
    }

    timeSentEmail = DateTime.now();
    _emailService.sendConsentEmail(
        code: code,
        email: emailValue!,
        userName: _userService.currentUser.fullName);
    _userService.updateGuardianVerificationStatus(
        status: GuardianVerificationStatus.pending);
    onNextButton(controller);
    if (resend) {
      _snackbarService.showSnackbar(
          message: "You may have to check your spam folder",
          title: "Resent email!");
    }
    return true;
  }

  Future verifyCode(PageController controller) async {
    if (!(await isValidCode())) {
      return;
    }
  }

  Future<bool> isValidCode() async {
    bool returnVal = true;

    if (codeValue == null || codeValue == "") {
      fieldsValidationMessages[CodeValueKey] =
          "Please provide the code sent to you via email";
      returnVal = false;
    } else if (codeValue! != code) {
      fieldsValidationMessages[CodeValueKey] =
          "Please provide the correct code we sent you via email";
      returnVal = false;
    } else if (timeSentEmail != null &&
        DateTime.now().difference(timeSentEmail!).inMinutes > 60) {
      fieldsValidationMessages[CodeValueKey] =
          "Your verification code expired, please send a new email";
      returnVal = false;
    } else {
      _userService.updateGuardianVerificationStatus(
          status: GuardianVerificationStatus.verified);
      verifiedCode = true;
    }
    notifyListeners();
    return returnVal;
  }

  bool isValidEmail() {
    bool returnVal = true;
    if (emailValue == null) {
      fieldsValidationMessages[EmailValueKey] =
          'Please provide a valid email address';
      returnVal = false;
    } else {
      bool emailValid =
          RegExp(r"^([a-zA-Z0-9_+\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
              .hasMatch(emailValue!);
      if (!emailValid) {
        fieldsValidationMessages[EmailValueKey] =
            'Please provide a valid email address';
        returnVal = false;
      }
    }
    return returnVal;
  }

  Future onBackButton(PageController controller) async {
    if (pageIndex > 0) {
      controller.previousPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      pageIndex = pageIndex - 1;
      notifyListeners();
    } else {
      popView(result: false);
    }
  }

  Future onNextButton(PageController controller) async {
    if (pageIndex == 0) {
      controller.nextPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      pageIndex = pageIndex + 1;
      notifyListeners();
    } else if (pageIndex == 1) {
      log.i("Validating email");
    }
  }

  @override
  void setFormStatus() {}

  void popView({required dynamic result}) {
    disposeController();
    _navigationService.back(result: result);
  }
}
