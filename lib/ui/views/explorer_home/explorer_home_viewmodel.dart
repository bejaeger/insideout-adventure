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

  Future collectMarker1() async {
    await questService.verifyAndUpdateCollectedMarkers(
        marker: getDummyMarker1());
  }

  Future collectMarker2() async {
    await questService.verifyAndUpdateCollectedMarkers(
        marker: getDummyMarker2());
  }

  Future collectMarker3() async {
    await questService.verifyAndUpdateCollectedMarkers(
        marker: getDummyMarker3());
  }
}
