import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/map_updates.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:rxdart/rxdart.dart';

class MapStateService {
  final log = getLogger("MapsService");

  // whether map is zoomed in to avatar with tilt
  bool isAvatarView = true;
  void setIsAvatarView(bool set) {
    isAvatarView = set;
  }

  int characterNumber = 0;
  double tilt = kInitialTilt;
  double zoom = kInitialZoomAvatarView;
  double get bearing => bearingSubject.value;
  final bearingSubject = BehaviorSubject<double>.seeded(kInitialBearing);
  final mapEventListener = BehaviorSubject<MapUpdate>();

  // to create snapshot of previous camera position
  // accessible everywhere in the app
  double? previousBearing;
  double? previousZoom;
  double? previousTilt;
  bool? previousIsAvatarView;
  double? previousLat;
  double? previousLon;

  // variable holding last bird view zoom to restore back to it
  double? lastBirdViewZoom;

  // if map should be restored to specific lat/lon
  // (if in birds view and zooming into map and restoring view)
  double? currentLat;
  double? currentLon;

  // if map should be moved to specific lat/lon
  double? newLat;
  double? newLon;

  // navigated form quest list
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

  void resetSnapshotOfCameraPosition() {
    previousIsAvatarView = null;
    previousBearing = null;
    previousZoom = null;
    previousTilt = null;
    previousLat = null;
    previousLon = null;
  }

  void takeSnapshotOfBirdViewCameraPosition() {
    lastBirdViewZoom = zoom;
  }

  void restorePreviousCameraPosition({bool moveInsteadOfAnimate = false}) {
    if (previousBearing != null) {
      bearingSubject.add(previousBearing!);
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

  ////////////////////////////////////////////////////////
  /// Clean up
  ///
  void closeListener() {
    bearingSubject.close();
    mapEventListener.close();
  }
}
