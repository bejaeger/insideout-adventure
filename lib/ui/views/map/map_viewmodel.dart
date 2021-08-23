import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:permission_handler/permission_handler.dart';

class MapViewModel extends BaseViewModel {
  final log = getLogger('MapViewModel');
  List<Marker> markers = [];
  Set<Marker> markersTmp = {};
  var _pos;

  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(49.246445, -122.994560),
    zoom: 12,
  );

  Future getCurrentLocation() async {
    setBusy(true);

    //Verify If location is available on device.
    final checkGeolocation = await checkGeolocationAvailable();
    Position _position = Position(
        latitude: this.initialCameraPosition.target.latitude,
        longitude: this.initialCameraPosition.target.longitude,
        accuracy: 0.0,
        timestamp: null,
        speed: 0.0,
        heading: 0.0,
        speedAccuracy: 0.0,
        altitude: 0.0);

    if (checkGeolocation) {
      try {
        _position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        if (_position != null) {
          final lastPosition = await Geolocator.getLastKnownPosition();
          return lastPosition;
        }
      } catch (error) {
        throw MapViewModelException(
            message:
                'An error occured in the defining your position $_position',
            devDetails: "Error message from Map View Model $error ",
            prettyDetails:
                "An internal error occured on our side, please apologize and try again later.");
        // return _position;
      }
      return _position;
    }

    setBusy(false);
    notifyListeners();
  }

  Future<bool> checkGeolocationAvailable() async {
    bool isGeolocationAvailable = await Geolocator.isLocationServiceEnabled();
    return isGeolocationAvailable;
  }

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  void initState() {
    setBusy(true);
    requestPermission();
    try {
      _pos = getCurrentLocation();
      print('This is the Position : $_pos');
      // addMarker(pos, 'currpos', 'You are here!');
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured in the defining ',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, please apologize and try again later.");
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    setBusy(true);
    try {
      markersTmp.add(
        Marker(
            markerId: MarkerId('currpos'),
            //position: _pos,
            position: LatLng(49.246445, -122.994560),
            infoWindow: InfoWindow(title: 'BernaBy', snippet: 'Vancouver'),
            icon: ('currpos' == 'currpos')
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange)),
      );
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured in the defining ',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, please apologize and try again later.");
    }
    setBusy(false);
    notifyListeners();
  }
}
