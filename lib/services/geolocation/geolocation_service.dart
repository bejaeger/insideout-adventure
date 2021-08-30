import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/places/places.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocationService {
  final log = getLogger('GeolocationService');
  final _firestoreApi = locator<FirestoreApi>();

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  var _position;

  CameraPosition getInitialCameraPostion() {
    final CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(49.246445, -122.994560),
      zoom: 17,
    );
    return initialCameraPosition;
  }

  Future getCurrentLocation() async {
    //Verify If location is available on device.
    final checkGeolocation = await checkGeolocationAvailable();
    Position _position = Position(
        latitude: 49.246445,
        longitude: -122.994560,
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
          //final lastPosition = await Geolocator.getLastKnownPosition();
          //return lastPosition;
          return _position;
        }
      } catch (error) {
        throw MapViewModelException(
            message:
                'An error occured in the defining your position $_position',
            devDetails: "Error message from Map View Model $error ",
            prettyDetails:
                "An internal error occured on our side, please apologize and try again later.");
      }
      return _position;
    }
  }

  Future setUserPosition({required Position position}) async {
    if (position != null) {
      _position = position;
      log.i('This is my current Posstion $position');
    } else {
      log.e('Null Position Passed $position');
    }
  }

  Position get getUserPosition => _position;

  Future<bool> checkGeolocationAvailable() async {
    bool isGeolocationAvailable = await Geolocator.isLocationServiceEnabled();
    return isGeolocationAvailable;
  }

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return true;
  }

  //Get User Favourite Places
  Future<List<Places>?> getPlaces() async {
    return await _firestoreApi.getPlaces();
  }
}
