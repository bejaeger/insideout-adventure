import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class MapBaseViewModel extends QuestViewModel {
  // Class implementing common functionality to update and get map information

  // --------------------------------------
  // Services
  final MapStateService mapStateService = locator<MapStateService>();

  // ----------------------------------------
  // Getters
  double get bearing => mapStateService.bearingSubject.value;
  double get tilt => mapStateService.tilt;
  double get zoom => mapStateService.zoom;
  double? get newLat => mapStateService.newLat;
  double? get newLon => mapStateService.newLon;
  bool get isAvatarView => mapStateService.isAvatarView;

  // -------------------------------------
  // functions
  void changeCameraTilt(double tiltIn) {
    mapStateService.tilt = tiltIn;
  }

  void changeCameraZoom(double zoomIn) {
    mapStateService.zoom = zoomIn;
  }

  void changeCameraBearing(double bearingIn) {
    mapStateService.bearingSubject.add(bearingIn);
  }

  void setCameraSettings({double? bearing, double? zoom, double? tilt}) {
    if (bearing != null) {
      mapStateService.bearingSubject.add(bearing);
    }
    if (tilt != null) {
      mapStateService.tilt = tilt;
    }
    if (zoom != null) {
      mapStateService.zoom = zoom;
    }
  }

  void setNewLatLon({required double lat, required double lon}) {
    mapStateService.setNewLatLon(lat: lat, lon: lon);
  }

  void updateMap() {
    mapStateService.updateMap();
  }

  void restorePreviousCameraPosition() {
    mapStateService.restorePreviousCameraPosition();
  }
}
