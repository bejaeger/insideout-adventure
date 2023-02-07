import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';

// Class implementing common functionality to update and get map information

mixin MapStateControlMixin {
  final MapStateService mapStateService = locator<MapStateService>();

  double get bearing => mapStateService.bearing;
  double get tilt => mapStateService.tilt;
  double get zoom => mapStateService.zoom;
  double? get newLat => mapStateService.newLat;
  double? get newLon => mapStateService.newLon;
  double? get lastBirdViewZoom => mapStateService.lastBirdViewZoom;
  bool get isAvatarView => mapStateService.isAvatarView;
  bool get navigatedFromQuestList => mapStateService.navigatedFromQuestList;

  void changeCameraTilt(double tiltIn) {
    mapStateService.tilt = tiltIn;
  }

  void changeCameraZoom(double zoomIn) {
    mapStateService.zoom = zoomIn;
  }

  void changeCameraBearing(double bearingIn) {
    mapStateService.bearing = bearingIn;
  }

  void changeNavigatedFromQuestList(bool set) {
    mapStateService.navigatedFromQuestList = set;
  }

  void setCameraSettings({double? bearing, double? zoom, double? tilt}) {
    if (bearing != null) {
      mapStateService.bearing = bearing;
    }
    if (tilt != null) {
      mapStateService.tilt = tilt;
    }
    if (zoom != null) {
      mapStateService.zoom = zoom;
    }
  }

  void changeCameraLatLon(double lat, double lon) {
    mapStateService.setCurrentatLon(lat: lat, lon: lon);
  }

  void setNewLatLon({required double lat, required double lon}) {
    mapStateService.setNewLatLon(lat: lat, lon: lon);
  }

  void animateOnNewLocation() {
    mapStateService.animateOnNewLocation();
  }

  void animateMap({bool forceUseLocation = false}) {
    mapStateService.animateMap(forceUseLocation: forceUseLocation);
  }

  void restorePreviousCameraPositionAndAnimate(
      {bool moveInsteadOfAnimate = false}) {
    mapStateService.restorePreviousCameraPositionAndAnimate(
        moveInsteadOfAnimate: moveInsteadOfAnimate);
  }

  void addAllQuestMarkers() {
    mapStateService.addAllQuestMarkers();
  }

  void takeSnapshotOfCameraPosition() {
    mapStateService.takeSnapshotOfCameraPosition();
  }

  void resetSnapshotOfCameraPosition() {
    mapStateService.resetSnapshotOfCameraPosition();
  }

  void takeSnapshotOfBirdViewCameraPosition() {
    mapStateService.takeSnapshotOfBirdViewCameraPosition();
  }

}
