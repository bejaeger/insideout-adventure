import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/dummy_datamodels.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class ExplorerHomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

///////////////////////////////////////////
// Navigations

  void navigateToMapView() {
    //_navigationService.navigateTo(Routes.mapScreen);
    _navigationService.navigateTo(Routes.mapView);
  }

  //////////////////////////////
  /// Dummy functions

  void collectMarker1() {
    questService.updateCollectedMarkers(marker: getDummyMarker1());
  }

  void collectMarker2() {
    questService.updateCollectedMarkers(marker: getDummyMarker2());
  }

  void collectMarker3() {
    questService.updateCollectedMarkers(marker: getDummyMarker3());
  }
}
