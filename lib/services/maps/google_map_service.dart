import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:afkcredits/app/app.logger.dart';

class GoogleMapService {
  static GoogleMapController? _mapController;

  static final mapLogger = getLogger("MapControllerService");
  static Set<Marker> markersOnMap = {};

  static bool isAnimating = false;

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
    if (_mapController == null || isAnimating) return;
    try {
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
    } catch (e) {
      mapLogger.wtf("Could not move camera due to error: $e");
      mapLogger.wtf("Skipping error");
    }
  }

  static void animateCamera({
    required double bearing,
    required double zoom,
    required double tilt,
    required double lat,
    required double lon,
    bool? force,
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
      {required double lat, required double lon, bool? force}) {
    if (_mapController == null) return;
    if (isAnimating && force != true) return;
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

  static void addARObjectToMap(
      {required void Function(double lat, double lon, bool isCoin) onTap,
      required double lat,
      required double lon,
      required bool isCoin}) async {
    final coinBitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(3, 3)), kAFKCreditsLogoSmallPath);
    final treasureBitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(3, 3)), kTreasureIconSmallPath);
    Marker marker = Marker(
      markerId: MarkerId("COIN" +
          isCoin
              .toString()), // google maps marker id of start marker will be our quest id
      //position: LatLng(49.26813866276503, -122.98950899176373),
      position: LatLng(lat, lon),
      icon: isCoin ? coinBitmap : treasureBitmap,
      onTap: () async {
        // needed to avoid navigating to that marker!
        dontMoveCamera();
        onTap(lat, lon, isCoin);
      },
    );
    // Marker markerTreasure = Marker(
    //   markerId: MarkerId(
    //       "TREASURE"), // google maps marker id of start marker will be our quest id
    //   position: LatLng(49.26843866276503, -122.99103899176373),

    //   //infoWindow:
    //   //  InfoWindow(
    //   //     title: afkmarker == quest.startMarker ? "START HERE" : "GO HERE"),
    //   // InfoWindow(snippet: quest.name),
    //   icon: treasureBitmap,
    //   onTap: () async {
    //     // needed to avoid navigating to that marker!
    //     dontMoveCamera();
    //     onTap(false);
    //   },
    // );
    markersOnMap.add(marker);
    // markersOnMap.add(markerTreasure);
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
  static runAnimation(void Function() animation, {bool? force}) async {
    if (isAnimating == true && force != true) {
      // wait for 1 second before executing animation
      await Future.delayed(Duration(seconds: 1));

      runAnimation(animation, force: force);
    }
    isAnimating = true;
    try {
      try {
        animation();
      } catch (e) {
        mapLogger.wtf("Could not animate due to error: $e");
        mapLogger.wtf("Skipping error");
      }
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

//Ben I just wonder why are we defining a function type ViewModel into services.
Future<MapViewModel> presolveMapViewModel() async {
  MapViewModel _instance = MapViewModel(
    moveCamera: GoogleMapService.moveCamera,
    animateCamera: GoogleMapService.animateCamera,
    configureAndAddMapMarker: GoogleMapService.configureAndAddMapMarker,
    animateNewLatLon: GoogleMapService.animateNewLatLon,
    resetMapMarkers: GoogleMapService.resetMapMarkers,
    addARObjectToMap: GoogleMapService.addARObjectToMap,
  );
  return Future.value(_instance);
}
