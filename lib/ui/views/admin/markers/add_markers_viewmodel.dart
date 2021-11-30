import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class AddMarkersViewModel extends BaseViewModel {
  final log = getLogger("AddMarkersViewModel");
  final _geolocationService = locator<GeolocationService>();
  final _markersServices = locator<MarkerService>();
  GoogleMapController? _googleMapController;

  int? _group;
  Marker? _marker;

  //add Markers to the Firebase
  Future<void> addMarkersToDB({required AFKMarker markers}) async {
    try {
      await _markersServices.addMarkers(markers: markers);
    } catch (e) {
      throw FirestoreApiException(
          message: 'Failed To Insert Places',
          devDetails: 'Failed Caused By $e.');
    }
  }

//Get Google Map Controller
  GoogleMapController? get getGoogleMapController => _googleMapController;

  CameraPosition initialCameraPosition() {
    if (_geolocationService.getUserPosition != null) {
      final CameraPosition _initialCameraPosition = CameraPosition(
          target: LatLng(_geolocationService.getUserPosition!.latitude,
              _geolocationService.getUserPosition!.longitude),
          zoom: 13);
      return _initialCameraPosition;
    } else {
      return CameraPosition(
        target: getDummyCoordinates(),
        zoom: 14,
      );
    }
  }

  void checkMarkerStatus({int? checkMarkerStatus}) {
    if (checkMarkerStatus == 1) {
      _group = checkMarkerStatus;
    } else {
      _group = 2;
    }
    notifyListeners();
  }

  int? get getGroupId => _group;

  void onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  Marker get getMarkers => _marker!;

  void addMarkersToMap(LatLng? position) async {
    if (_marker != null) {
      _marker = Marker(
        markerId: MarkerId('MarkerId'),
        position: position!,
        infoWindow: const InfoWindow(title: 'Added By administrator'),
      );
    } else {
      log.i('Please Markers Should not be Null');
    }
    notifyListeners();
  }
}
