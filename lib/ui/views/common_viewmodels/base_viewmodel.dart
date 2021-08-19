import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

// The Basemodel
// All our ViewModels inherit from this class so
// put everything here that needs to be available throughout the
// entire App

class BaseModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();

  navigateBack() {
    _navigationService.back();
  }

  Future logout() async {
    await _userService.handleLogoutEvent();
    _navigationService.clearStackAndShow(Routes.loginView);
  }
}
