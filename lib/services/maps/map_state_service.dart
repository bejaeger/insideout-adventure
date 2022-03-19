import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/map_updates.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  // whether map is focused on specific quest
  bool isQuestDetailsView = false;
  void setIsQuestDetailsView(bool set) {
    isQuestDetailsView = set;
  }

  double tilt = kInitialTilt;
  double zoom = kInitialZoom;
  double get bearing => bearingSubject.value;
  final bearingSubject = BehaviorSubject<double>.seeded(kInitialBearing);
  final mapEventListener = BehaviorSubject<MapUpdate>();

  // to create snapshot of previous camera position
  // accessible everywhere in the app
  double? previousBearing;
  double? previousZoom;
  double? previousTilt;
  bool? previousViewWasAvatarView;
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

  // touch events
  bool suppressOneFingerRotations = false;
  void setSuppressOneFingerRotations(bool set) {
    suppressOneFingerRotations = set;
  }

  void takeSnapshotOfCameraPosition() {
    previousViewWasAvatarView = isAvatarView;
    previousBearing = bearing;
    previousZoom = zoom;
    previousTilt = tilt;
    previousLat = currentLat;
    previousLon = currentLon;
  }

  void takeSnapshotOfBirdViewCameraPosition() {
    lastBirdViewZoom = zoom;
  }

  void restorePreviousCameraPosition() {
    if (previousBearing != null) {
      bearingSubject.add(previousBearing!);
    }
    if (previousZoom != null) {
      zoom = previousZoom!;
    }
    if (previousTilt != null) {
      tilt = previousTilt!;
    }
    if (previousViewWasAvatarView == false) {
      isAvatarView = false;
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
    previousViewWasAvatarView = null;
    restoreMapSnapshot();
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

  void animateMap() {
    mapEventListener.add(MapUpdate.animate);
  }

  void animateOnNewLocation() {
    mapEventListener.add(MapUpdate.animateOnNewLocation);
  }

  void restoreMapSnapshot() {
    mapEventListener.add(MapUpdate.restoreSnapshot);
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

  // TODO:
  // DEPRECATE THE FOLLOWING (needs google map dependency!)
  LatLngBounds boundsFromLatLngList({required List<LatLng> latLngList}) {
    if (latLngList.length == 0) {
      log.e("Can't created LatLngBounds from empty list!");
      throw Exception("Can't created LatLngBounds from empty list!");
    }
    double? x0, x1, y0, y1;
    for (LatLng latLng in latLngList) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  ////////////////////////////////////////////////////////
  /// Clean up
  ///
  void closeListener() {
    bearingSubject.close();
    mapEventListener.close();
  }
}
