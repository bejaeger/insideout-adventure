import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

import '../../app/app.locator.dart';
import '../../datamodels/dummy_data.dart';
import '../../enums/marker_status.dart';
import '../../exceptions/firestore_api_exception.dart';
import '../../exceptions/mapviewmodel_expection.dart';
import '../../services/geolocation/geolocation_service.dart';
import '../../services/markers/marker_service.dart';

abstract class AFKMarks extends FormViewModel {
  final logger = getLogger('AFKMarks');
  //Geoflutterfire geo = Geoflutterfire();

  Set<Marker> _markersOnMap = {};
  List<AFKMarker> _afkMarkers = [];
  //List<AfkMarkersPositions> _afkMarkersPosition = [];
  final geolocationService = locator<GeolocationService>();
  final markersServices = locator<MarkerService>();
  final QuestService questService = locator<QuestService>();
  Position? get userLocation => geolocationService.getUserLivePositionNullable;

  Set<Marker> get getMarkersOnMap => _markersOnMap;

  List<AFKMarker> get getAFKMarkers => _afkMarkers;
  // List<AfkMarkersPositions> get getAfkMarkersPosition => _afkMarkersPosition;

  CameraPosition initialCameraPosition() {
    if (userLocation != null) {
      if (questService.lonAtLatestQuestDownload == null &&
          questService.latAtLatestQuestDownload == null)
        return CameraPosition(
            target: LatLng(userLocation!.latitude, userLocation!.longitude),
            zoom: kInitialZoomBirdsView);
      else {
        return CameraPosition(
            target: LatLng(questService.latAtLatestQuestDownload!,
                questService.lonAtLatestQuestDownload!),
            zoom: kInitialZoomBirdsView);
      }
    } else {
      return CameraPosition(
        target: getDummyCoordinates(),
        zoom: 15,
      );
    }
  }

  void getLocation() async {
    await geolocationService.getAndSetCurrentLocation();
  }

  Marker addMarkers(
      {required LatLng pos,
      required String markerId,
      required int number,
      QuestType? questType}) {
    return Marker(
      markerId: MarkerId(markerId),
      //infoWindow: InfoWindow(title: "Marker"),
      icon: number == 0
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
          : (questType == QuestType.GPSAreaHike ||
                  questType == QuestType.GPSAreaHunt)
              ? BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange)
              : questType == QuestType.TreasureLocationSearch
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueViolet)
                  : BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
      position: pos,
      onTap: () {
        removeMarker(
          markerId: markerId,
        );
      },
    );
  }

  AFKMarker returnAFKMarker(
      {required LatLng pos, required String markerId, required String qrCode}) {
    return AFKMarker(
        id: markerId, qrCodeId: qrCode, lat: pos.latitude, lon: pos.longitude);
  }

/*   AfkMarkersPositions returnAfkPositionMarkers(
      {required LatLng pos, required String docId}) {
    /*    GeoPoint? point = geo.point(
        latitude: pos.latitude, longitude: pos.longitude) as GeoPoint?; */
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);

    return AfkMarkersPositions(point: point, documentId: docId);
  } */

  void _addMarkerOnMapAndAFKMarker(
      {required String markerId,
      required LatLng position,
      required String qrdCodeId,
      required int number,
      QuestType? questType}) {
    var id2 = Uuid();
    final id = id2.v1().toString().replaceAll('-', '');
    _markersOnMap.add(
      addMarkers(
          markerId: markerId,
          pos: position,
          number: number,
          questType: questType),
    );
    _afkMarkers.add(
      returnAFKMarker(pos: position, markerId: markerId, qrCode: qrdCodeId),
    );
    /*   _afkMarkersPosition.add(
      returnAfkPositionMarkers(pos: position, docId: id),
    ); */
  }

  //add Markers to the Firebase
  Future<void> _addMarkersToDB({required AFKMarker markers}) async {
    try {
      await markersServices.addMarkers(markers: markers);
    } catch (e) {
      throw FirestoreApiException(
          message: 'Failed To Insert Places',
          devDetails: 'Failed Caused By $e.');
    }
  }

  //add Markers to the Firebase
/*   Future<void> _addAfkMarkersPositionToFirebase(
      {required AfkMarkersPositions afkMarkersPositions}) async {
    try {
      await markersServices.addAFKMarkersPositions(
          afkMarkersPositions: afkMarkersPositions);
    } catch (e) {
      throw FirestoreApiException(
          message: 'Failed To Insert Places',
          devDetails: 'Failed Caused By $e.');
    }
  } */

  void resetMarkersValues() {
    //_markersOnMap = {};
    _markersOnMap.clear();
    _afkMarkers = [];
    //_afkMarkersPosition = [];
    notifyListeners();
  }

  void removeMarker({required String markerId}) {
    _markersOnMap
        .removeWhere((element) => element.markerId == MarkerId(markerId));
    _afkMarkers.removeWhere((element) => element.id == markerId);
    notifyListeners();
  }

  void removeAllMarkers() {
    List<AFKMarker> markers = List.from(getAFKMarkers);
    for (AFKMarker m in markers) {
      removeMarker(markerId: m.id);
    }
  }

  void addMarkerOnMap(
      {required LatLng pos, required int number, QuestType? questType}) {
    try {
      var id = Uuid();
      var id2 = Uuid();
      final markerId = id.v1().toString().replaceAll('-', '');
      final qrdCdId = id2.v1().toString().replaceAll('-', '');

      _addMarkerOnMapAndAFKMarker(
          markerId: markerId,
          position: pos,
          qrdCodeId: qrdCdId,
          number: number,
          questType: questType);
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured when creating the map',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, sorry, please try again later.");
    }
  }

  Future<void> addMarkersToFirebase(
      {required MarkerStatus status, required Marker afkMarker}) async {
    var id = Uuid();
    String afkid = id.v1().toString().replaceAll('-', '');
    String qrCodeId = id.v1() + id.v4();

    /*   GeoPoint? point = geo.point(
        latitude: afkMarker.position.latitude,
        longitude: afkMarker.position.longitude) as GeoPoint?; */
    /*   GeoFirePoint point = geo.point(
        latitude: afkMarker.position.latitude,
        longitude: afkMarker.position.longitude); */

    await _addMarkersToDB(
      markers: AFKMarker(
          id: afkid,
          qrCodeId: qrCodeId,
          lat: afkMarker.position.latitude,
          lon: afkMarker.position.longitude,
          markerStatus: status),
    );
/*     await _addAfkMarkersPositionToFirebase(
      afkMarkersPositions: AfkMarkersPositions(documentId: afkid, point: point),
    ); */
    resetMarkersValues();
  }
}
