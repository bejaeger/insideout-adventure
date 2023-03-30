import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/map_updates.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:rxdart/rxdart.dart';

class MapStateService {
  final log = getLogger("MapsService");

  bool isAvatarView = true; // avatarView = map zoomed in with tilt
  void setIsAvatarView(bool set) {
    isAvatarView = set;
  }

  double tilt = kInitialTilt;
  double zoom = kInitialZoomAvatarView;
  double bearing = kInitialBearing;
  final mapEventListener = BehaviorSubject<MapUpdate>();

  // to create snapshot of previous camera position
  // accessible everywhere in the app
  double? previousBearing;
  double? previousZoom;
  double? previousTilt;
  bool? previousIsAvatarView;
  double? previousLat;
  double? previousLon;

  // create snapshot of previous camera position
  // before Ar view is shown or marker is collected!
  // Needed because we have a fancy animation before the AR
  double? beforeArBearing;
  double? beforeArZoom;
  double? beforeArTilt;
  bool? beforeArIsAvatarView;
  double? beforeArLat;
  double? beforeArLon;

  // variable holding last bird view zoom to restore back to it
  double? lastBirdViewZoom;

  // if map should be restored to specific lat/lon
  // (if in birds view and zooming into map and restoring view)
  double? currentLat;
  double? currentLon;

  // if map should be moved to specific lat/lon
  double? newLat;
  double? newLon;

  // if finger on screen we want to stop the lottie animations
  bool get isFingerOnScreen => isFingerOnScreenSubject.value;
  final BehaviorSubject<bool> isFingerOnScreenSubject =
      BehaviorSubject<bool>.seeded(false);

  bool navigatedFromQuestList = false;

  void takeSnapshotOfCameraPosition() {
    if (previousBearing != null)
      return; // only take snapshot when no snapshot is stored!
    previousIsAvatarView = isAvatarView;
    previousBearing = bearing;
    previousZoom = zoom;
    previousTilt = tilt;
    previousLat = currentLat;
    previousLon = currentLon;
  }

  void takeBeforeARSnapshotOfCameraPosition() {
    if (beforeArBearing != null)
      return; // only take snapshot when no snapshot is stored!
    beforeArIsAvatarView = isAvatarView;
    beforeArBearing = bearing;
    beforeArZoom = zoom;
    beforeArTilt = tilt;
    beforeArLat = currentLat;
    beforeArLon = currentLon;
  }

  void resetSnapshotOfCameraPosition() {
    previousIsAvatarView = null;
    previousBearing = null;
    previousZoom = null;
    previousTilt = null;
    previousLat = null;
    previousLon = null;
  }

  void resetBeforeArSnapshotOfCameraPosition() {
    beforeArIsAvatarView = null;
    beforeArBearing = null;
    beforeArZoom = null;
    beforeArTilt = null;
    beforeArLat = null;
    beforeArLon = null;
  }

  void takeSnapshotOfBirdViewCameraPosition() {
    lastBirdViewZoom = zoom;
  }

  void setCameraToDefaultChildPosition() {
    resetSnapshotOfCameraPosition();
    tilt = kInitialTilt;
    zoom = kInitialZoomAvatarView;
    setIsAvatarView(true);
  }

  void setCameraToDefaultParentPosition() {
    resetSnapshotOfCameraPosition();
    tilt = 0;
    zoom = kInitialZoomBirdsView;
    setIsAvatarView(false);
  }

  void restorePreviousCameraPosition() {
    if (previousBearing != null) {
      bearing = previousBearing!;
    }
    if (previousZoom != null) {
      zoom = previousZoom!;
    }
    if (previousTilt != null) {
      tilt = previousTilt!;
    }
    if (previousIsAvatarView != null) {
      isAvatarView = previousIsAvatarView!;
    }
    if (previousLat != null) {
      newLat = previousLat;
    }
    if (previousLon != null) {
      newLon = previousLon;
    }
    previousBearing = null;
    previousZoom = null;
    previousTilt = null;
    previousLon = null;
    previousLat = null;
    previousIsAvatarView = null;
  }

  void restoreBeforeArCameraPosition() {
    if (beforeArBearing != null) {
      bearing = beforeArBearing!;
    }
    if (beforeArZoom != null) {
      zoom = beforeArZoom!;
    }
    if (beforeArTilt != null) {
      tilt = beforeArTilt!;
    }
    if (beforeArIsAvatarView != null) {
      isAvatarView = beforeArIsAvatarView!;
    }
    if (beforeArLat != null) {
      newLat = beforeArLat;
    }
    if (beforeArLon != null) {
      newLon = beforeArLon;
    }
    beforeArBearing = null;
    beforeArZoom = null;
    beforeArTilt = null;
    beforeArLon = null;
    beforeArLat = null;
    beforeArIsAvatarView = null;
  }

  void restorePreviousCameraPositionAndAnimate(
      {bool moveInsteadOfAnimate = false}) {
    restorePreviousCameraPosition();
    if (moveInsteadOfAnimate) {
      restoreMapSnapshotByMoving();
    } else {
      restoreMapSnapshot();
    }
  }

  void restoreBeforeArCameraPositionAndAnimate(
      {bool moveInsteadOfAnimate = false}) {
    restoreBeforeArCameraPosition();
    if (moveInsteadOfAnimate) {
      restoreMapSnapshotByMoving();
    } else {
      restoreMapSnapshot();
    }
  }

  void setCurrentatLon({required double lat, required double lon}) {
    currentLat = lat;
    currentLon = lon;
  }

  void setNewLatLon({required double lat, required double lon}) {
    newLat = lat;
    newLon = lon;
  }

  void resetNewLatLon() {
    newLat = null;
    newLon = null;
  }

  void resetPreviousLatLon() {
    previousLat = null;
    previousLon = null;
  }

  void animateMap({required bool forceUseLocation}) {
    if (forceUseLocation) {
      mapEventListener.add(MapUpdate.forceAnimateToLocation);
    } else {
      mapEventListener.add(MapUpdate.animate);
    }
  }

  void notify() {
    mapEventListener.add(MapUpdate.notify);
  }

  void animateOnNewLocation() {
    mapEventListener.add(MapUpdate.animateOnNewLocation);
  }

  void restoreMapSnapshot() {
    mapEventListener.add(MapUpdate.restoreSnapshot);
  }

  void restoreMapSnapshotByMoving() {
    mapEventListener.add(MapUpdate.restoreSnapshotByMoving);
  }

  void addAllQuestMarkers() {
    mapEventListener.add(MapUpdate.addAllQuestMarkers);
  }

  Future launchMapsForNavigation(double lat, double lon) async {
    final availableMaps = await MapLauncher.installedMaps;
    log.i("Available maps: $availableMaps");

    if (availableMaps.isEmpty) {
      return "No maps installed on phone";
    }

    await availableMaps.first.showDirections(
      destination: Coords(lat, lon),
      //title: "AFK Credits Quest",
    );
  }

  // ! THIS IS NEVER CALLED ANYWHERE!
  // ! SHOULD IT BE CALLED!?
  void closeListener() {
    // bearingSubject.close();
    isFingerOnScreenSubject.close();
    mapEventListener.close();
  }
}
