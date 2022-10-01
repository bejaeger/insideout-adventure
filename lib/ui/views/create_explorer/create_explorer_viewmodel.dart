import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/ui/views/create_explorer/create_explorer_view.form.dart';

class CreateExplorerViewModel extends FormViewModel {
  final UserService _userService = locator<UserService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final log = getLogger("AddExplorerViewModel");

//No Need for this since we are going to start doing realtime validation on
//setFormStatus()
  // Still need this e.g. if the user didn't tap the password field.
  dynamic isValidInput({required String? name, required String? password}) {
    log.i("Testing if user input is valid: name = $name, password = $password");
    if (name == null || name == "") return "Please provide a valid name";
    if (password == null) return "Please provide a valid password";
    if (password.length < 6)
      return "Please provide a password with at least 6 characters";
    return true;
  }

  Future addExplorer() async {
    final result = isValidInput(name: nameValue, password: passwordValue!);
    if (result == true) {
      final result = await runBusyFuture(_userService.createExplorerAccount(
          name: nameValue!,
          password: passwordValue!,
          authMethod: AuthenticationMethod.EmailOrSponsorCreatedExplorer));
      if (result is String) {
        await _dialogService.showDialog(
            title: "Could not create user", description: result);
      } else {
        // successfully added user
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
    // Set a validation message for the entire form
    if (hasPasswordValidationMessage) {
      setValidationMessage('Error in the form, please check again');
    }
    if (hasNameValidationMessage) {
      setValidationMessage('Error in the form, please check again');
    }
  }
}
