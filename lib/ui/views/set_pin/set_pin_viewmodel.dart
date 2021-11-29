import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';

class SetPinViewModel extends FormViewModel {
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();

  final log = getLogger("SetPinViewModel");

  Future onSubmit(String pin) async {

    if (_userService.currentUser.role == UserRole.sponsor) {
      log.i("Pin set to $pin. Getting final confirmation to switch accounts");
      final result = await _bottomSheetService.showBottomSheet(
          title: "Switch To Explorer Account", cancelButtonTitle: "Cancel");
      if (result?.confirmed == true) {
        _navigationService.back(result: SetPinResult.withPin(pin: pin));
      }
    } else {
      _navigationService.back(result: SetPinResult.withPin(pin: pin));
    }
    
  }

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
}

class SetPinResult {
  final String? pin;

  /// Contains the error message for the request
  final String? errorMessage;

  SetPinResult.withPin({this.pin}) : errorMessage = null;
  SetPinResult.error({this.errorMessage}) : pin = null;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
