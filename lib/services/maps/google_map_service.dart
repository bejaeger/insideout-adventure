import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:afkcredits/app/app.logger.dart';

class GoogleMapService {
  static GoogleMapController? _mapController;

  static final mapLogger = getLogger("MapControllerService");
  static Set<Marker> markersOnMap = {};

  static void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  static void moveCamera({
    required double bearing,
    required double zoom,
    required double tilt,
    required double lat,
    required double lon,
  }) {
    if (_mapController == null) return;
    _mapController!.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: bearing,
          target: LatLng(lat, lon),
          zoom: zoom,
          tilt: tilt,
        ),
      ),
    );
  }

  static void animateCamera({
    required double bearing,
    required double zoom,
    required double tilt,
    required double lat,
    required double lon,
    bool? force = false,
  }) {
    if (_mapController == null) return;
    CameraPosition position = CameraPosition(
      bearing: bearing,
      target: LatLng(lat, lon),
      // target: LatLng(currentLat, currentLon),
      zoom: zoom,
      tilt: tilt,
    );
    runAnimation(
      () => _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(position),
      ),
      force: force,
    );
  }

  static void animateNewLatLon(
      {required double lat, required double lon, bool force = false}) {
    if (_mapController == null) return;
    runAnimation(
      () => _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(lat, lon),
        ),
      ),
      force: force,
    );
  }

  static CameraPosition initialCameraPosition({
    required Position? userLocation,
  }) {
    if (userLocation != null) {
      return CameraPosition(
        bearing: kInitialBearing,
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: kInitialZoom,
        tilt: kInitialTilt,
      );
    } else {
      print(
          "ERROR! ==>> THIS SHOULD NEVER HAPPEN! User Location could not be found!");
      return CameraPosition(
        target: getDummyCoordinates(),
        tilt: 90,
        zoom: 17.5,
      );
    }
  }

  // configures map marker
  static void configureAndAddMapMarker(
      {required Quest quest,
      required AFKMarker afkmarker,
      required Future Function() onTap}) {
    Marker marker = Marker(
      markerId: MarkerId(afkmarker
          .id), // google maps marker id of start marker will be our quest id
      position: LatLng(afkmarker.lat!, afkmarker.lon!),

      //infoWindow:
      //  InfoWindow(
      //     title: afkmarker == quest.startMarker ? "START HERE" : "GO HERE"),
      // InfoWindow(snippet: quest.name),
      icon: defineMarkersColour(quest: quest, afkmarker: afkmarker),
      onTap: () async {
        // needed to avoid navigating to that marker!
        dontMoveCamera();
        await onTap();
      },
    );
    markersOnMap.add(marker);
  }

  static void resetMapMarkers() {
    markersOnMap = {};
  }

  static void dontMoveCamera() async {
    if (_mapController == null) return;
    _mapController!.moveCamera(CameraUpdate.scrollBy(0, 0));
  }

  // Ensures that animation is not interrupted e.g. when clicking "Zoom In"
  // and at the same time the location listener wants to update the position
  static bool isAnimating = false;
  static runAnimation(void Function() animation, {bool? force = false}) async {
    if (isAnimating == true && force != true) {
      // wait for 1 second before executing animation
      await Future.delayed(Duration(seconds: 1));
      runAnimation(animation);
    }
    isAnimating = true;
    try {
      animation();
    } catch (e) {
      mapLogger.e("Error occured when animating camera!");
      isAnimating = false;
      rethrow;
    }
    await Future.delayed(Duration(seconds: 1));
    isAnimating = false;
  }

  ///////////////////////////////////////////////////////////////////
  /// Geocooardinates manipulations
  ///
  static LatLngBounds boundsFromLatLngList({required List<LatLng> latLngList}) {
    if (latLngList.length == 0) {
      mapLogger.e("Can't created LatLngBounds from empty list!");
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

  ///////////////////////////////////////////////////////////
  /// Map Style
  static BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest}) {
    //   return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    // }
    // if (hasActiveQuest) {
    //   final index = activeQuest.quest.markers
    //       .indexWhere((element) => element == afkmarker);
    //   if (!activeQuest.markersCollected[index]) {
    //     return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    //   } else {
    //     return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    //   }
    // } else {
    if (quest?.type == QuestType.QRCodeHike) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    } else if (quest?.type == QuestType.TreasureLocationSearch) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }
}
