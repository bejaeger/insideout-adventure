import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
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

  Set<Marker> _markersOnMap = {};
  List<AFKMarker> _afkCredits = [];
  final _geolocationService = locator<GeolocationService>();
  final markersServices = locator<MarkerService>();
  Position? _position;

  Set<Marker> get getMarkersOnMap => _markersOnMap;

  List<AFKMarker> get getAFKMarkers => _afkCredits;

  CameraPosition initialCameraPosition() {
    if (_position != null) {
      final CameraPosition _initialCameraPosition = CameraPosition(
          target: LatLng(_position!.latitude, _position!.longitude), zoom: 14);
      return _initialCameraPosition;
    } else {
      return CameraPosition(
        target: getDummyCoordinates(),
        zoom: 15,
      );
    }
  }

  Position? get getCurrentPostion => _position;
  void setPosition() async {
    _position = await _geolocationService.setCurrentUserPosition();
    logger.i(_position);
  }

  Marker addMarkers({required LatLng pos, required String markerId}) {
    return Marker(
      markerId: MarkerId(markerId),
      infoWindow: InfoWindow(title: markerId),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: pos,
      onTap: () {
        removeMarker(
          marker: Marker(markerId: MarkerId(markerId), position: pos),
        );
      },
    );
  }

  AFKMarker returnAFK(
      {required LatLng pos, required String markerId, required String qrCode}) {
    return AFKMarker(
        id: markerId, qrCodeId: qrCode, lat: pos.latitude, lon: pos.longitude);
  }

  void _addMarkersAndAFKCredits(
      {required String markerId,
      required LatLng position,
      required String qrdCodeId}) {
    _markersOnMap.add(
      addMarkers(markerId: markerId, pos: position),
    );

    _afkCredits.add(
      returnAFK(pos: position, markerId: markerId, qrCode: qrdCodeId),
    );
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

  void resetMarkersValues() {
    //_markersOnMap = {};
    _markersOnMap.clear();
    _afkCredits = [];
    notifyListeners();
  }

  void removeMarker({required Marker marker}) {
    _markersOnMap.forEach((element) {
      if (element.markerId == marker.markerId) {
        _markersOnMap.remove(element);
        notifyListeners();
      }
    });
  }

  void addMarkerOnMap({required LatLng pos}) {
    try {
      var id = Uuid();
      var id2 = Uuid();
      final markerId = id.v1().toString().replaceAll('-', '');
      final qrdCdId = id2.v1().toString().replaceAll('-', '');

      _addSingleMarkerAndAFKCredits(
          markerId: markerId, position: pos, qrdCodeId: qrdCdId);
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured when creating the map',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, sorry, please try again later.");
    }
  }

  void _addSingleMarkerAndAFKCredits(
      {required String markerId,
      required LatLng position,
      required String qrdCodeId}) {
/*
     _singleMarkerOnMap =
        _afkMarkers.addMarkers(markerId: markerId, pos: position);

    _singleAfkCredits = _afkMarkers.returnAFK(
        pos: position, markerId: markerId, qrCode: qrdCodeId); 
        */
  }

  void addMarkersOnMap({required LatLng pos}) {
    try {
      var id = Uuid();
      var id2 = Uuid();
      final markerId = id.v1().toString().replaceAll('-', '');
      final qrdCdId = id2.v1().toString().replaceAll('-', '');

      _addMarkersAndAFKCredits(
          markerId: markerId, position: pos, qrdCodeId: qrdCdId);
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

    await _addMarkersToDB(
      markers: AFKMarker(
          id: afkid,
          qrCodeId: qrCodeId,
          lat: afkMarker.position.latitude,
          lon: afkMarker.position.longitude,
          markerStatus: status),
    );
    resetMarkersValues();
  }
}
