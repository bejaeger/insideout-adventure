import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class ExplorerHomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
///////////////////////////////////////////
// Navigations

  void navigateToMapView() {
    _navigationService.navigateTo(Routes.mapView);
  }
}
