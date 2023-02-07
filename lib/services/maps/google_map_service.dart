import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/utils/utilities.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:afkcredits/app/app.logger.dart';

class GoogleMapService {
  static GoogleMapController? _mapController;

  static final mapLogger = getLogger("MapControllerService");
  static Set<Marker> markersOnMap = {};
  static Set<Circle> circlesOnMap = {};

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

  static Future animateCamera({
    required double bearing,
    required double zoom,
    required double tilt,
    required double lat,
    required double lon,
    bool? force,
  }) async {
    if (_mapController == null) return;
    CameraPosition position = CameraPosition(
      bearing: bearing,
      target: LatLng(lat, lon),
      zoom: zoom,
      tilt: tilt,
    );
    await runAnimation(
      () => _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(position),
      ),
      force: force,
    );
  }

  static Future animateNewLatLon(
      {required double lat, required double lon, bool? force}) async {
    if (_mapController == null) return;
    if (isAnimating && force != true) return;
    await runAnimation(
      () async => await _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(lat, lon),
        ),
      ),
      force: force,
    );
  }

  static Future animateNewLatLonZoomDelta(
      {required double lat,
      required double lon,
      required double deltaZoom,
      bool? force}) async {
    if (_mapController == null) return;
    if (isAnimating && force != true) return;
    double zoom = await _mapController!.getZoomLevel();
    await runAnimation(
      () async => await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lon), zoom + deltaZoom),
      ),
      force: force,
    );
  }

  static Future animateCameraToBetweenCoordinates(
      {required List<List<double>> latLngList, double? padding = 100}) async {
    if (_mapController == null) return;
    runAnimation(
      () => _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
            boundsFromLatLngList(latLngList: latLngList), padding ?? 0),
      ),
    );
  }

  static void fakeAnimate() async {
    if (_mapController == null) return;
    runAnimation(
      () async => dontMoveCamera(),
    );
  }

  static CameraPosition initialCameraPosition({
    required Position? userLocation,
    bool parentAccount = false,
  }) {
    if (userLocation != null) {
      return CameraPosition(
        bearing: parentAccount ? 0 : kInitialBearing,
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: parentAccount ? kInitialZoomBirdsView : kInitialZoomAvatarView,
        tilt: parentAccount ? 0 : kInitialTilt,
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

  static void configureAndAddMapMarker({
    required Quest quest,
    required AFKMarker afkmarker,
    required Future Function() onTap,
    bool isStartMarker = false,
    bool completed = false,
    String? infoWindowText,
    bool isParentAccount = false,
  }) async {
    final icon = await defineMarkersColour(
        quest: quest,
        afkmarker: afkmarker,
        completed: completed,
        collected: false,
        isParentAccount: isParentAccount,
        isStartMarker: isStartMarker);
    Marker marker = Marker(
      markerId: MarkerId(afkmarker
          .id), // google maps marker id of start marker will be our quest id
      position: LatLng(afkmarker.lat!, afkmarker.lon!),
      infoWindow: infoWindowText != null
          ? InfoWindow(title: infoWindowText)
          : InfoWindow(
              title: afkmarker == quest.startMarker
                  ? "START HERE"
                  : "NEXT CHECKPOINT"),
      icon: icon,
      alpha: (completed && quest.type == QuestType.TreasureLocationSearch)
          ? 0.2
          : 1,
      onTap: () async {
        // needed to avoid navigating to that marker!
        dontMoveCamera();
        await onTap();
      },
    );
    markersOnMap.add(marker);
  }

  static void configureAndAddMapArea(
      {required Quest quest,
      required AFKMarker afkmarker,
      required Future Function() onTap,
      bool isStartArea = false,
      bool collected = false}) {
    Color? color;
    if (isStartArea) {
      color = Colors.orange;
    } else if (collected) {
      color = Colors.green;
    } else {
      color = Colors.red;
    }
    Circle circle = Circle(
      circleId: CircleId(afkmarker
          .id), // google maps marker id of start marker will be our quest id
      center: LatLng(afkmarker.lat!, afkmarker.lon!),
      fillColor: color.withOpacity(0.5),
      strokeColor: color.withOpacity(0.6),
      strokeWidth: 2,
      radius: kMaxDistanceFromMarkerInMeter.toDouble(),
      consumeTapEvents: true,
      onTap: () async {
        // needed to avoid navigating to that marker!
        dontMoveCamera();
        await onTap();
      },
    );
    circlesOnMap.add(circle);
  }

  static void addARObjectToMap(
      {required void Function(double lat, double lon, bool isCoin) onTap,
      required double lat,
      required double lon,
      required bool isGreen}) async {
    final coinBitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(4, 4)), kAFKCreditsLogoSmallPath);
    final treasureBitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(4, 4)), kAFKCreditsLogoSmallPathYellow);
    Marker marker = Marker(
      markerId: MarkerId("COIN" +
          isGreen
              .toString()), // google maps marker id of start marker will be our quest id
      position: LatLng(lat, lon),
      icon: isGreen ? coinBitmap : treasureBitmap,
      onTap: () async {
        // needed to avoid navigating to that marker!
        dontMoveCamera();
        onTap(lat, lon, isGreen);
      },
    );
    markersOnMap.add(marker);
  }

  static void resetMapMarkers() {
    markersOnMap = {};
  }

  static void resetMapAreas() {
    circlesOnMap = {};
  }

  static void dontMoveCamera() async {
    if (_mapController == null) return;
    _mapController!.moveCamera(CameraUpdate.scrollBy(0, 0));
  }

  // Ensures that animation is not interrupted e.g. when clicking "Zoom In"
  // and at the same time the location listener wants to update the position
  static Future runAnimation(Future Function() animation, {bool? force}) async {
    if (isAnimating == true && force != true) {
      // wait for 1 second before executing animation
      await Future.delayed(Duration(milliseconds: mapAnimationSpeed()));

      runAnimation(animation, force: force);
    }
    isAnimating = true;
    try {
      try {
        // Need to await, otherwise animation errors are not caught!
        await animation();
      } catch (e) {
        mapLogger.wtf("Could not animate due to error: $e");
        mapLogger.wtf("Skipping error");
      }
    } catch (e) {
      mapLogger.e("Error occured when animating camera!");
      isAnimating = false;
      rethrow;
    }
    await Future.delayed(Duration(milliseconds: mapAnimationSpeed()));
    isAnimating = false;
  }

  static Future<BitmapDescriptor> defineMarkersColour({
    required AFKMarker afkmarker,
    required Quest? quest,
    required bool completed,
    required bool isStartMarker,
    required bool collected,
    required bool isParentAccount,
  }) async {
    if (isParentAccount && quest?.createdBy == null) {
      // this means it is a public quest. Display them a bit darker on the map
      if (quest?.type == QuestType.TreasureLocationSearch) {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet + 18);
      } else {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange + 18);
      }
    }
    if (collected) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
    if (completed) {
      if (quest?.type == QuestType.TreasureLocationSearch) {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      } else {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      }
    } else {
      if (quest?.type == QuestType.QRCodeHike) {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
      } else if (quest?.type == QuestType.TreasureLocationSearch) {
        if (isStartMarker) {
          return BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet);
        } else {
          return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
        }
      } else {
        if (isStartMarker) {
          return BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange);
        } else {
          return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
        }
      }
    }
  }

  static LatLngBounds boundsFromLatLngList(
      {required List<List<double>> latLngList}) {
    if (latLngList.length == 0) {
      mapLogger.e("Can't create LatLngBounds from empty list!");
      throw Exception("Can't create LatLngBounds from empty list!");
    }
    double? x0, x1, y0, y1;
    for (List<double> latLng in latLngList) {
      if (x0 == null) {
        x0 = x1 = latLng[0];
        y0 = y1 = latLng[1];
      } else {
        if (latLng[0] > x1!) x1 = latLng[0];
        if (latLng[0] < x0) x0 = latLng[0];
        if (latLng[1] > y1!) y1 = latLng[1];
        if (latLng[1] < y0!) y0 = latLng[1];
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  static void updateMapMarkers(
      {required AFKMarker afkmarker,
      required bool collected,
      bool completed = false}) async {
    final icon = await defineMarkersColour(
        afkmarker: afkmarker,
        quest: null,
        completed: completed,
        collected: collected,
        isParentAccount: false,
        isStartMarker: false);
    markersOnMap = markersOnMap
        .map((item) => item.markerId == MarkerId(afkmarker.id)
            ? item.copyWith(
                iconParam: icon,
                infoWindowParam: InfoWindow(title: "COLLECTED"))
            : item)
        .toSet();
  }

  static void updateMapAreas({required AFKMarker afkmarker}) {
    circlesOnMap = circlesOnMap
        .map((item) => item.circleId == CircleId(afkmarker.id)
            ? item.copyWith(
                fillColorParam: Colors.green.withOpacity(0.5),
                strokeColorParam: Colors.green.withOpacity(0.6),
              )
            : item)
        .toSet();
  }

  static void showMarkerInfoWindow({required String? markerId}) async {
    if (_mapController == null || markerId == null) return;
    MarkerId markerIdConverted = MarkerId(markerId);
    try {
      await _mapController!.showMarkerInfoWindow(markerIdConverted);
    } catch (e) {
      mapLogger.e(
          "Could not show info window, maybe no info window was specified. Error: $e");
    }
  }

  static void hideMarkerInfoWindow({required String? markerId}) async {
    if (_mapController == null || markerId == null) return;
    MarkerId markerIdConverted = MarkerId(markerId);
    try {
      await _mapController!.hideMarkerInfoWindow(markerIdConverted);
    } catch (e) {
      mapLogger.e(
          "Could not show info window, maybe no info window was specified. Error: $e");
    }
  }
}

Future<MapViewModel> presolveMapViewModel() async {
  MapViewModel _instance = MapViewModel(
      moveCamera: GoogleMapService.moveCamera,
      animateCamera: GoogleMapService.animateCamera,
      configureAndAddMapMarker: GoogleMapService.configureAndAddMapMarker,
      configureAndAddMapArea: GoogleMapService.configureAndAddMapArea,
      animateNewLatLon: GoogleMapService.animateNewLatLon,
      animateNewLatLonZoomDelta: GoogleMapService.animateNewLatLonZoomDelta,
      resetMapMarkers: GoogleMapService.resetMapMarkers,
      resetMapAreas: GoogleMapService.resetMapAreas,
      addARObjectToMap: GoogleMapService.addARObjectToMap,
      fakeAnimate: GoogleMapService.fakeAnimate,
      updateMapMarkers: GoogleMapService.updateMapMarkers,
      updateMapAreas: GoogleMapService.updateMapAreas,
      showMarkerInfoWindow: GoogleMapService.showMarkerInfoWindow,
      hideMarkerInfoWindow: GoogleMapService.hideMarkerInfoWindow,
      animateCameraToBetweenCoordinates:
          GoogleMapService.animateCameraToBetweenCoordinates);
  return Future.value(_instance);
}
