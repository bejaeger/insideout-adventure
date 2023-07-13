import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SetPinViewModel extends FormViewModel {
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();

  final log = getLogger("SetPinViewModel");

  bool get isGuardianAccount => _userService.currentUser.role == UserRole.guardian;

  Future onSubmit(String pin) async {
    if (_userService.currentUser.role == UserRole.guardian) {
      log.i("Pin set to $pin. Getting final confirmation to switch accounts");
      final result = await _bottomSheetService.showBottomSheet(
          title: "Switch to child area", cancelButtonTitle: "Cancel");
      if (result?.confirmed == true) {
        _navigationService.back(result: SetPinResult.withPin(pin: pin));
        return true;
      } else {
        return false;
      }
    } else {
      _navigationService.back(result: SetPinResult.withPin(pin: pin));
      return true;
    }
  }

  void popView() {
    _navigationService.back();
  }

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
    print("Set form status!");
  }
}

class SetPinResult {
  final String? pin;

  final String? errorMessage;

  SetPinResult.withPin({this.pin}) : errorMessage = null;
  SetPinResult.error({this.errorMessage}) : pin = null;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
