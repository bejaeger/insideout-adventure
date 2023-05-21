import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
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
  bool? ownPhoneSelected;
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
      final result = isValidInput(name: nameValue, password: passwordValue);
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

  dynamic isValidInput({required String? name, required String? password}) {
    log.i("Testing if user input is valid: name = $name, password = $password");
    if (name == null || name == "") {
      fieldsValidationMessages[NameValueKey] = "Please provide a valid name";
      return;
    }
    if (password == null) {
      fieldsValidationMessages[PasswordValueKey] =
          "Please provide a valid password";
      return;
    }
    if (password.length < 4) {
      fieldsValidationMessages[PasswordValueKey] =
          "Please provide a password with at least 4 characters";
      return;
    }
    return true;
  }

  Future addWard() async {
    if (ownPhoneSelected == null) {
      chooseValueMessage = "Choose yes or no";
      notifyListeners();
      return;
    }
    final result = isValidInput(name: nameValue, password: passwordValue!);
    if (result == true) {
      // per default if ward has own phone we enable verification step
      UserSettings userSettings = UserSettings(
          ownPhone: ownPhoneSelected!,
          isAcceptScreenTimeFirst: ownPhoneSelected!);
      final result = await runBusyFuture(_userService.createWardAccount(
          name: nameValue!,
          password: passwordValue!,
          authMethod: AuthenticationMethod.EmailOrGuardianCreatedWard,
          userSettings: userSettings));
      if (result is String) {
        await _dialogService.showDialog(
            title: "Could not create user", description: result);
      } else {
        await _dialogService.showDialog(
            title: "Successfully created account",
            description:
                "Tip: You can use the entered credentials to login on another phone");
        _navigationService.back();
      }
    } else {
      await _dialogService.showDialog(
          title: "Could not create user", description: result);
    }
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