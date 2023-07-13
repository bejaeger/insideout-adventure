import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/users/settings/user_settings.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/create_ward/create_ward_view.form.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateWardViewModel extends FormViewModel {
  final UserService _userService = locator<UserService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final log = getLogger("AddWardViewModel");

  bool isLoading = false;

  void Function() disposeController;
  CreateWardViewModel({required this.disposeController});

  int pageIndex = 0;
  bool ownPhoneSelected = false;
  String? chooseValueMessage;

  Future onBackButton(PageController controller) async {
    if (pageIndex > 0) {
      controller.previousPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      pageIndex = pageIndex - 1;
      notifyListeners();
    } else {
      popView();
    }
  }

  Future onNextButton(PageController controller) async {
    if (pageIndex == 0) {
      final result =
          await isValidInput(name: nameValue, password: passwordValue);
      if (result == true) {
        controller.nextPage(
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        pageIndex = pageIndex + 1;
        notifyListeners();
      }
    } else if (pageIndex == 1) {
      addWard();
    }
  }

  void switchOnOwnPhoneSelected(bool set) {
    ownPhoneSelected = set;
    notifyListeners();
  }

  Future isValidInput(
      {required String? name, required String? password}) async {
    log.i("Testing if user input is valid: name = $name, password = $password");
    bool returnValue = true;
    if (name == null || name == "") {
      fieldsValidationMessages[NameValueKey] = "Please provide a valid name";
      returnValue = false;
    }
    if (await _userService.isUserAlreadyPresent(name: name)) {
      fieldsValidationMessages[NameValueKey] =
          "A user with name $name exists already in our system. Please choose a different name.";
      returnValue = false;
    }
    if (password == null || password == "") {
      fieldsValidationMessages[PasswordValueKey] =
          "Please provide a valid password";
      returnValue = false;
    }
    if (password != null && password.length < 4) {
      fieldsValidationMessages[PasswordValueKey] =
          "Please provide a password with at least 4 characters";
      returnValue = false;
    }
    notifyListeners();
    return returnValue;
  }

  Future addWard() async {
    final result =
        await isValidInput(name: nameValue, password: passwordValue!);
    if (result == true) {
      if (!_userService.hasGivenConsent) {
        final res =
            await _navigationService.navigateTo(Routes.guardianConsentView);
        if (res == false) {
          await _dialogService.showDialog(
              title: "Could not create user",
              description:
                  "You need to give parental consent to create a child account.");
          return false;
        }
      }

      // per default if child has own phone we enable verification step
      UserSettings userSettings = UserSettings(
          ownPhone: ownPhoneSelected,
          isAcceptScreenTimeFirst: ownPhoneSelected);
      final result = await runBusyFuture(_userService.createWardAccount(
          name: nameValue!,
          password: passwordValue!,
          authMethod: AuthenticationMethod.EmailOrGuardianCreatedWard,
          userSettings: userSettings));
      if (result is String) {
        await _dialogService.showDialog(
            title: "Could not create user", description: result);
        return false;
      } else {
        String title = nameValue != null
            ? "Successfully created ${nameValue!}'s account"
            : "Successfully created child account";
        await _dialogService.showDialog(
            title: title,
            description:
                "Tip: you can use the account name and password to login to the child's account on another phone");
        _navigationService.back();
        return true;
      }
    } else {
      await _dialogService.showDialog(
          title: "Could not create user", description: result);
      return false;
    }
  }

  Future showPasswordReasonDialog() async {
    await _dialogService.showDialog(
        barrierDismissible: true,
        title: "Why do we need a password?",
        description:
            "This password is required in case the child wants to log into their account on a different phone.");
  }

  bool isPwShown = false;
  setIsPwShown(bool show) {
    isPwShown = show;
    notifyListeners();
  }

  @override
  void setFormStatus() {
    log.i('Set form Status with data: $formValueMap');
    if (hasPasswordValidationMessage) {
      setValidationMessage('Error in the form, please check again');
    }
    if (hasNameValidationMessage) {
      setValidationMessage('Error in the form, please check again');
    }
  }

  void popView() {
    disposeController();
    _navigationService.back();
  }
}
