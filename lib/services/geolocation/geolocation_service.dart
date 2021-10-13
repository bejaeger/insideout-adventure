import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/places/places.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationService {
  final log = getLogger('GeolocationService');
  final _firestoreApi = locator<FirestoreApi>();

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  var _position;

  Future getCurrentLocation() async {
    //Verify If location is available on device.
    final checkGeolocation = await checkGeolocationAvailable();

    if (checkGeolocation == true) {
      try {
        _position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);

        log.i('Harguilar Current Position $_position');
        if (_position != null) {
          final lastPosition = await Geolocator.getLastKnownPosition();
          log.i('This is Harguilar Last Location $lastPosition');
          return lastPosition;
          //return _position;
        } else {
          _position = Geolocator.getCurrentPosition();
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
      // return _position;
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
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return false;
    }

    return true;
  }

  //Get User Favourite Places
  Future<List<Places>?> getPlaces() async {
    return await _firestoreApi.getPlaces();
  }

  Future<bool> isUserCloseby({required double lat, required double lon}) async {
    Position position = await getCurrentLocation();

    double distanceInMeters = Geolocator.distanceBetween(
        position.latitude, position.longitude, lat, lon);
    if (distanceInMeters > kMaxDistanceFromMarkerInMeter) {
      return false;
    } else {
      return true;
    }
  }
}
