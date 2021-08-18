import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ExplorerHomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();
///////////////////////////////////////////
// Navigations

  void navigateToMapView() {
    _navigationService.navigateTo(Routes.mapView);
  }

  Future logout() async {
    await _userService.handleLogoutEvent();
    _navigationService.clearStackAndShow(Routes.loginView);
  }
}
