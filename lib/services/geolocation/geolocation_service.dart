import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/places/places.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:location/location.dart' as loc;

class GeolocationService {
  final log = getLogger('GeolocationService');
  final _firestoreApi = locator<FirestoreApi>();

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  dynamic _position;

  Future getCurrentLocation() async {
    //Verify If location is available on device.
    final checkGeolocation = await checkGeolocationAvailable();

    if (checkGeolocation == true) {
      try {
        if (!kIsWeb) {
          _position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best);
        } else {
          final loc.Location location = new loc.Location();
          _position = await location.getLocation();
        }

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
        log.e("Error when reading geolocation.");
        throw GeolocationServiceException(
            message: 'An error occured trying to get your current geolocation',
            devDetails: "Error message from geolocation service: $error",
            prettyDetails:
                "Geolocation could not be found. Please make sure your have location activated on your phone.");
      }
      // return _position;
    } else {
      log.e("Location service seems to be turned off on the phone");
      throw GeolocationServiceException(
          message: 'An error occured trying to get your current geolocation',
          devDetails: "Location service seems to be turned off on the phone.",
          prettyDetails:
              "Geolocation could not be found. Please make sure you have location activated on your phone.");
    }
  }

  Future setUserPosition({required dynamic position}) async {
    if (position != null) {
      _position = position;
      log.i('This is my current Posstion $position');
    } else {
      log.e('Null Position Passed $position');
    }
  }

  Position? get getUserPosition => _position;

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

/*   //Get User Favourite Places
  Future<List<Places>?> getPlaces() async {
    return await _firestoreApi.getPlaces();
  }
 */
  Future<bool> isUserCloseby({required double lat, required double lon}) async {
    final position = await getCurrentLocation();

    if (position != null) {
      double distanceInMeters = Geolocator.distanceBetween(
          position.latitude, position.longitude, lat, lon);
      if (distanceInMeters > kMaxDistanceFromMarkerInMeter) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }
}
