import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked_services/stacked_services.dart';

class StartUpViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final _placesService = locator<PlacesService>();
  final _environmentService = locator<EnvironmentService>();

  Future<void> runStartupLogic() async {
    await _environmentService.initialise();
    //final placesKey =  _environment.getValue(key)
    _placesService.initialize(
        apiKey: _environmentService.getValue(GoogleMapsEnvKey));
  }

  void navigateToSponsorHomeView() {
    _navigationService.navigateTo(Routes.sponsorHomeView);
  }

  void navigateToExplorerHomeView() {
    _navigationService.navigateTo(Routes.explorerHomeView);
  }

  void navigateToMapView() {
    _navigationService.navigateTo(Routes.mapView);
  }
}
