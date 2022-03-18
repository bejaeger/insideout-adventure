import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

mixin MapStateControlMixin {
  // Class implementing common functionality to update and get map information

  // --------------------------------------
  // Services
  final MapStateService mapStateService = locator<MapStateService>();
  // final LayoutService layoutService = locator<LayoutService>();

  // ----------------------------------------
  // Getters
  double get bearing => mapStateService.bearingSubject.value;
  double get tilt => mapStateService.tilt;
  double get zoom => mapStateService.zoom;
  double? get newLat => mapStateService.newLat;
  double? get newLon => mapStateService.newLon;
  bool get isAvatarView => mapStateService.isAvatarView;

  // bool get isShowingQuestDetails => layoutService.isShowingQuestDetails;
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

  void addAllQuestMarkers() {
    mapStateService.addAllQuestMarkers();
  }

  void setSuppressOneFingerRotations(bool set) {
    mapStateService.setSuppressOneFingerRotations(set);
  }

  void takeSnapshotOfCameraPosition() {
    mapStateService.previousViewWasAvatarView = isAvatarView;
    mapStateService.previousBearing = bearing;
    mapStateService.previousZoom = zoom;
    mapStateService.previousTilt = tilt;
  }

  // void switchIsShowingQuestDetails() {
  //   layoutService.switchIsShowingQuestDetails();
  // }
}
