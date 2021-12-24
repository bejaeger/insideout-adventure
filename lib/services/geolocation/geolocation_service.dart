import 'dart:async';
import 'dart:math';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:location/location.dart' as loc;
import 'package:afkcredits/app/app.logger.dart';

class GeolocationService {
  final log = getLogger('GeolocationService');
  final _firestoreApi = locator<FirestoreApi>();
  StreamSubscription? _currentPositionStreamSubscription;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Position? _position;
  Position? get getUserPosition => _position;
  double? currentGPSAccuracy;
  String? gpsAccuracyInfo;

  void listenToPosition(
      {double distanceFilter = kMinDistanceFromLastCheckInMeters}) {
    if (_currentPositionStreamSubscription == null) {
      // TODO: Provide proper error message to user in case of
      // denied permission, no access to gps, ...
      _currentPositionStreamSubscription = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best,
              distanceFilter: distanceFilter.round())
          .listen((position) {
        log.v("New position event fired, accuracy: ${position.accuracy}");
        _position = position;
      });
    }
  }

  setGPSAccuracyInfo(String? info) {
    gpsAccuracyInfo = info;
  }

  Future<Position> getAndSetCurrentLocation() async {
    //Verify If location is available on device.
    final checkGeolocation = await checkGeolocationAvailable();
    if (checkGeolocation == true) {
      try {
        // if (!kIsWeb) {
        Duration? difference;
        if (getUserPosition != null) {
          difference = getUserPosition?.timestamp?.difference(DateTime.now());
        }

        // cooldown time of 5 seconds for distance check.
        if ((difference != null && difference.inSeconds.abs() > 5) ||
            getUserPosition == null) {
          // log.wtf("---------------------------------");
          // log.i(DateTime.now().toString());
          final geolocatorPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
          );
          // log.i(DateTime.now().toString());

          currentGPSAccuracy = geolocatorPosition.accuracy;
          if (currentGPSAccuracy != null &&
              currentGPSAccuracy! > kThresholdGPSAccuracyToShowInfo) {
            setGPSAccuracyInfo(
                "Low GPS Accuracy (${currentGPSAccuracy?.toStringAsFixed(0)} m)");
          } else {
            setGPSAccuracyInfo(null);
          }
          _position = geolocatorPosition;
          return geolocatorPosition;
        } else {
          // return previous location
          log.v("Returning previously fetched location");
          return _position!;
        }

        // } else {
        // final loc.Location location = new loc.Location();
        // _position = await location.getLocation();
        // }
        // if (_position != null) {
        //   log.v("Getting last known position instead");
        //   final lastPosition = await Geolocator.getLastKnownPosition();
        //   return lastPosition;
        //   //return _position;
        // } else {
        //   _position = Geolocator.getCurrentPosition(
        //       desiredAccuracy: LocationAccuracy.best);
        //   return _position;
        // }

      } catch (error) {
        log.e("Error when reading geolocation. Error thrown: $error");
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

  Future<bool> checkGeolocationAvailable() async {
    bool isGeolocationAvailable = await Geolocator.isLocationServiceEnabled();
    return isGeolocationAvailable;
  }

  // @ https://pub.dev/packages/geolocator
  // The geolocator will automatically try to request permissions when you try to acquire a location through the getCurrentPosition or getPositionStream methods.
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
    final position = await getAndSetCurrentLocation();

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

  Future<double> distanceBetweenUserAndCoordinates(
      {required double? lat, required double? lon}) async {
    if (lat == null || lon == null) {
      log.e("input latitude or longitude is null, cannot derive distance!");
      return -1;
    }
    final position = await getAndSetCurrentLocation();
    double distanceInMeters = Geolocator.distanceBetween(
        position.latitude, position.longitude, lat, lon);
    return distanceInMeters;
  }

  double distanceBetween(
      {required double? lat1,
      required double? lon1,
      required double? lat2,
      required double? lon2}) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      log.e("input latitude or longitude is null, cannot derive distance!");
      return -1;
    }
    double distanceInMeters =
        Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return distanceInMeters;
  }

  void cancelPositionListener() {
    _currentPositionStreamSubscription?.cancel();
    _currentPositionStreamSubscription = null;
  }

  void clearData() {
    _position = null;
    currentGPSAccuracy = null;
    cancelPositionListener();
  }
}
