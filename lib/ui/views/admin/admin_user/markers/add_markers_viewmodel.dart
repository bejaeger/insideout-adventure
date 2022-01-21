import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/enums/marker_status.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

class AddMarkersViewModel extends BaseViewModel {
  final log = getLogger("AddMarkersViewModel");
  final _geolocationService = locator<GeolocationService>();
  final _markersServices = locator<MarkerService>();
  final snackbarService = locator<SnackbarService>();

  int? _group;
  Marker? marker;
  double lat = 0.0;
  double lon = 0.0;

  AddMarkersViewModel({this.marker});

  //add Markers to the Firebase
  Future<void> _addMarkersToDB({required AFKMarker markers}) async {
    try {
      await _markersServices.addMarkers(markers: markers);
    } catch (e) {
      throw FirestoreApiException(
          message: 'Failed To Insert Places',
          devDetails: 'Failed Caused By $e.');
    }
  }

  Future<void> addMarkersToFirebase({required MarkerStatus status}) async {
    var id = Uuid();
    String afkid = id.v1().toString().replaceAll('-', '');
    log.i("AFKID is: " + afkid);

    String qrCodeId = id.v1() + id.v4();
    if (lat != 0.0 && afkid != "") {
      await _addMarkersToDB(
        markers: AFKMarker(
            id: afkid,
            qrCodeId: qrCodeId,
            lat: lat,
            lon: lon,
            markerStatus: status),
      );
      showAddedMarkerSnackbar();
    } else {
      showEmptyMarkerSnackbar();
    }
  }

  CameraPosition initialCameraPosition() {
    if (_geolocationService.getUserLivePositionNullable != null) {
      final CameraPosition _initialCameraPosition = CameraPosition(
          target: LatLng(_geolocationService.getUserLivePositionNullable!.latitude,
              _geolocationService.getUserLivePositionNullable!.longitude),
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
      _group = 1;
    } else {
      _group = 2;
    }
    notifyListeners();
  }

  void setGroupNumber() {
    _group = null;
    notifyListeners();
  }

  int? get getGroupId => _group;
  void showAddedMarkerSnackbar() {
    snackbarService.showSnackbar(
        title: "Marker Added",
        message: "Marked Added to Database",
        duration: Duration(seconds: 2));
  }

  void showEmptyMarkerSnackbar() {
    snackbarService.showSnackbar(
      title: "Not Added",
      message: "Select One of The Fields",
      duration: Duration(seconds: 2),
    );
  }

  Future addMarkerToMap(LatLng position) async {
    if (marker == null || (marker != null)) {
      lat = position.latitude;
      lon = position.longitude;
      log.i("Harguilar Printed This out:" + "" + position.toString());
      marker = await Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: position,
      );

      notifyListeners();
      return marker;
    }
  }
}
