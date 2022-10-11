import 'dart:async';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/services/common_services/pausable_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;

class GeolocationService extends PausableService {
  final log = getLogger('GeolocationService');
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  // listener for active quests
  StreamSubscription? _livePositionStreamSubscription;
  bool get isListeningToLocation => _livePositionStreamSubscription != null;
  StreamSubscription? _livePositionMainStreamSubscription;
  bool get isListeningToMainLocation =>
      _livePositionMainStreamSubscription != null &&
      !_livePositionMainStreamSubscription!.isPaused;

  int? get currentGPSAccuracy => _livePosition?.accuracy.round();
  String? gpsAccuracyInfo;

  bool isGeolocationAvailable = false;

  // position with stream
  Position? _livePosition;
  Future<Position> get getUserLivePosition async =>
      _livePosition ??
      await getAndSetCurrentLocation(forceGettingNewPosition: false);
  LatLng get getUserLatLng =>
      LatLng(_livePosition!.latitude, _livePosition!.longitude);
  List<double> get getUserLatLngInList =>
      [_livePosition!.latitude, _livePosition!.longitude];

  Position? get getUserLivePositionNullable => _livePosition;

  // for testing
  // current position forced
  Position? _currentPosition;
  // last known position
  Position? _lastKnownPosition;

  double distanceToLastCheckedMarker = -1;
  double distanceToStartMarker = -1;

  bool _listenedToNewPosition = false;
  bool get listenedToNewPosition => _listenedToNewPosition;

  int currentPositionDistanceFilter = -1;

  // Maybe we should add a filterGPSData function that only
  // allows the user to check location based on certain conditions
  // Maybe this should be a callback that notifies the user when GPS
  // is bad!

  Future<void> listenToPosition({
    required int distanceFilter,
    void Function(Position)? onData,
    void Function(Position)? viewModelCallback,
    bool skipFirstStreamEvent = false,
  }) async {
    Completer<void> completer = Completer();
    if (_livePositionStreamSubscription == null) {
      currentPositionDistanceFilter = distanceFilter.round();

      // need to fully cancel the main listener here!
      // otherwise stream from geolocator is not reset!
      cancelMainPositionListener();

      // TODO: Provide proper error message to user in case of
      // denied permission, no access to gps, ...

      _livePositionStreamSubscription = Geolocator.getPositionStream(
              locationSettings: LocationSettings(
                  accuracy: LocationAccuracy.best,
                  distanceFilter: currentPositionDistanceFilter))
          .listen(
        (position) {
          printPositionInfo(position);
          _livePosition = position;
          setGPSAccuracyInfo(position.accuracy);
          if (onData != null) {
            onData(position);
          }
          if (viewModelCallback != null) {
            // option to not fire callback on first event
            if (skipFirstStreamEvent) {
              if (completer.isCompleted) {
                viewModelCallback(position);
              }
            } else {
              viewModelCallback(position);
            }
          }
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );
    } else {
      log.w("Quest position stream already listened to!");
      completer.complete();
    }
    return completer.future;
  }

  // this uses another stream subscription that is paused
  // when an active quest is present and resumed if it's cancelled!
  // This guarantees that we always have the main location listener active!
  Future<void> listenToPositionMain({
    required int distanceFilter,
    void Function(Position)? onData,
    void Function(Position)? viewModelCallback,
    bool skipFirstStreamEvent = false,
  }) async {
    Completer<void> completer = Completer();
    if (_livePositionMainStreamSubscription == null) {
      currentPositionDistanceFilter = distanceFilter.round();
      // TODO: Provide proper error message to user in case of
      // denied permission, no access to gps, ...
      _livePositionMainStreamSubscription = Geolocator.getPositionStream(
              locationSettings: LocationSettings(
                  accuracy: LocationAccuracy.best,
                  distanceFilter: currentPositionDistanceFilter))
          .listen(
        (position) {
          printPositionInfo(position);
          _livePosition = position;
          setGPSAccuracyInfo(position.accuracy);
          if (onData != null) {
            onData(position);
          }
          if (viewModelCallback != null) {
            // option to not fire callback on first event
            if (skipFirstStreamEvent) {
              if (completer.isCompleted) {
                viewModelCallback(position);
              }
            } else {
              viewModelCallback(position);
            }
          }
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );
    } else {
      log.w("Position stream already listened to!");
      completer.complete();
    }
    return completer.future;
  }

  @override
  void resume() {
    if (servicePaused == true) {
      if (isListeningToLocation == true) {
        log.v('Quest Geolocation listener resumed');
        resumePositionListener();
      } else {
        // resume main position listener
        resumeMainPositionListener();
      }
      super.resume();
    }
  }

  @override
  void pause() {
    if (servicePaused == null || servicePaused == false) {
      if (isListeningToLocation == true) {
        log.v('Quest Geolocation listener paused');
        pausePositionListener();
      }
      if (isListeningToMainLocation == true) {
        log.v('Main Geolocation listener paused');
        pauseMainPositionListener();
      }
      super.pause();
    }
  }

  Future<LocationPermission> askForLocationPermission() async {
    log.v("Trying to request permissions");
    final LocationPermission result = await Geolocator.requestPermission();
    log.i("Granted permission: $result");
    return result;
  }

  void setGPSAccuracyInfo(double accuracy, [bool isSuperUser = false]) {
    String? info;
    if (accuracy > kThresholdGPSAccuracyToShowInfo) {
      info = "Low GPS Accuracy (${accuracy.toStringAsFixed(0)} m)";
    } else {
      if (isSuperUser) {
        info = "GPS accuracy: ${accuracy.toStringAsFixed(0)} m";
      }
    }
    gpsAccuracyInfo = info;
  }

  void setListenedToNewPosition(bool set) {
    _listenedToNewPosition = set;
  }

  Future<Position> getAndSetCurrentLocation(
      {bool forceGettingNewPosition = false}) async {
    //Verify If location is available on device.
    if (!isGeolocationAvailable) {
      isGeolocationAvailable = await checkGeolocationAvailable();
    }
    if (isGeolocationAvailable == true) {
      try {
        // if (!kIsWeb) {
        Duration? difference;
        if (getUserLivePositionNullable != null) {
          difference = getUserLivePositionNullable?.timestamp
              ?.difference(DateTime.now());
        }

        // cooldown time of 5 seconds for distance check and NEW positions should be retrieved.
        if (((difference != null && difference.inSeconds.abs() > 5) ||
                difference == null) &&
            forceGettingNewPosition) {
          // log.wtf("---------------------------------");
          log.i("Getting current position now at ${DateTime.now().toString()}");
          final geolocatorPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            //forceAndroidLocationManager: true,
          );

          log.i("Retrieved position at ${DateTime.now().toString()}");
          setGPSAccuracyInfo(geolocatorPosition.accuracy);
          _livePosition = geolocatorPosition;
          printPositionInfo(geolocatorPosition);
          return geolocatorPosition;
        } else {
          // return previous location

          final lastKnownPosition =
              kIsWeb ? null : await Geolocator.getLastKnownPosition();
          if (lastKnownPosition != null) {
            log.v("Returning last known position");
            _livePosition = lastKnownPosition;
            printPositionInfo(lastKnownPosition);
            setGPSAccuracyInfo(lastKnownPosition.accuracy);
            return lastKnownPosition;
          } else {
            if (_livePosition != null) {
              log.v("Returning previously fetched position");
              printPositionInfo(_livePosition!);
              setGPSAccuracyInfo(_livePosition!.accuracy);
              return _livePosition!;
            } else {
              log.v("Force getting new position");
              return getAndSetCurrentLocation(forceGettingNewPosition: true);
            }
          }
        }
      } catch (error) {
        log.e("Error when reading geolocation. Error thrown: $error");
        throw GeolocationServiceException(
            message: 'An error occured trying to get your current geolocation',
            devDetails: "Error message from geolocation service: $error",
            prettyDetails:
                "Geolocation could not be found. Please make sure you have your location service activated on your phone.");
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
      _livePosition = position;
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
    var request = await Permission.locationAlways.request();

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

  Future<bool> isUserCloseby(
      {required double lat, required double lon, int? threshold}) async {
    // log.v("Check if user is closeby marker based on last known location");
    final position = await getAndSetCurrentLocation();
    if (countAsCloseByMarker(
        position: position,
        lat: lat,
        lon: lon,
        threshold: threshold ?? kMaxDistanceFromMarkerInMeter)) {
      log.v("User is nearby the marker!");
      return true;
    } else {
      // not nearby marker but try to recover with new forced calculation
      log.v(
          "User not nearby the marker, try calculating a NEW position and check again");
      final position =
          await getAndSetCurrentLocation(forceGettingNewPosition: true);
      return countAsCloseByMarker(
          position: position,
          lat: lat,
          lon: lon,
          threshold: threshold ?? kMaxDistanceFromMarkerInMeter);
    }
  }

  bool countAsCloseByMarker(
      {required Position position,
      required double lat,
      required double lon,
      int threshold = kMaxDistanceFromMarkerInMeter}) {
    double distanceInMeters = Geolocator.distanceBetween(
        position.latitude, position.longitude, lat, lon);
    // log.v("D, Position positionistance from marker: $distanceInMeters");
    distanceToLastCheckedMarker = distanceInMeters;
    if (distanceInMeters < threshold.toDouble()) {
      return true;
    } else {
      return false;
    }
  }

  void resetStoredDistancesToMarkers() {
    distanceToLastCheckedMarker = -1;
    distanceToStartMarker = -1;
  }

  Future setDistanceToLastCheckedMarker(
      {required double? lat, required double? lon}) async {
    if (lat == null || lon == null) {
      log.wtf("Coordinates are null, can't check distance!");
      return;
    }
    final position = await getAndSetCurrentLocation();
    distanceToLastCheckedMarker = Geolocator.distanceBetween(
        position.latitude, position.longitude, lat, lon);
  }

  Future setDistanceToStartMarker(
      {required double? lat, required double? lon, Position? position}) async {
    if (lat == null || lon == null) {
      log.wtf("Coordinates are null, can't check distance!");
      return;
    }
    late Position positionActual;
    if (position == null) {
      positionActual = await getAndSetCurrentLocation();
    } else {
      positionActual = position;
    }
    // DISTANCE TO CURRENT MARKER!
    distanceToStartMarker = Geolocator.distanceBetween(
        positionActual.latitude, positionActual.longitude, lat, lon);
    distanceToLastCheckedMarker = distanceToStartMarker;
  }

  Future<double> distanceBetweenUserAndCoordinates(
      {required double? lat,
      required double? lon,
      bool forceGettingNewPosition = false}) async {
    if (lat == null || lon == null) {
      log.e("input latitude or longitude is null, cannot derive distance!");
      return -1;
    }
    final position = await getAndSetCurrentLocation(
        forceGettingNewPosition: forceGettingNewPosition);
    double distanceInMeters = Geolocator.distanceBetween(
        position.latitude, position.longitude, lat, lon);
    return distanceInMeters;
  }

  double distanceBetweenPositionAndCoordinates(
      {required Position? position,
      required double? lat,
      required double? lon}) {
    if (lat == null || lon == null) {
      log.e("input latitude or longitude is null, cannot derive distance!");
      return -1;
    }
    double distanceInMeters = Geolocator.distanceBetween(
        position!.latitude, position.longitude, lat, lon);
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

  void printPositionInfo(Position position) {
    log.v(
        "New fired position lat, lon, accuracy, seconds ago: ${position.latitude}, ${position.longitude}, ${position.accuracy}, ${position.timestamp?.difference(DateTime.now()).inSeconds}");
  }

  void cancelPositionListener() {
    log.v("Cancel Quest position listener");
    _livePositionStreamSubscription?.cancel();
    _livePositionStreamSubscription = null;
    // don't do this implicitely here. Explicit treatment is better!
    // if (_livePositionMainStreamSubscription != null &&
    //     _livePositionMainStreamSubscription!.isPaused) {
    //   // resumeMainPositionListener();
    //   //listenToPositionMain(distanceFilter: distanceFilter);
    // }
  }

  void cancelMainPositionListener() {
    log.v("Cancel Main position listener");
    _livePositionMainStreamSubscription?.cancel();
    _livePositionMainStreamSubscription = null;
  }

  void pausePositionListener() {
    _livePositionStreamSubscription?.pause();
  }

  void resumePositionListener() {
    _livePositionStreamSubscription?.resume();
  }

  void pauseMainPositionListener() {
    _livePositionMainStreamSubscription?.pause();
  }

  void resumeMainPositionListener() {
    _livePositionMainStreamSubscription?.resume();
  }

  void clearData() {
    _lastKnownPosition = null;
    _currentPosition = null;
    _livePosition = null;
    distanceToStartMarker = -1;
    distanceToLastCheckedMarker = -1;
    cancelPositionListener();
    cancelMainPositionListener();
  }

  Future getLastKnownAndCurrentPosition(
      {required QuestDataPointTrigger trigger}) async {
    _lastKnownPosition = await Geolocator.getLastKnownPosition();
    if (trigger != QuestDataPointTrigger.onlyLastKnownLocationFetchingEvent) {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    }
  }

  String getLastKnownDistancesToGoal() {
    if (_lastKnownPosition == null) {
      return "nan";
    } else {
      return distanceBetween(
              lat1: _lastKnownPosition?.latitude,
              lon1: _lastKnownPosition?.longitude,
              lat2: kTestLat,
              lon2: kTestLon)
          .toStringAsFixed(1);
    }
  }

  String getCurrentDistancesToGoal() {
    if (_currentPosition == null) {
      return "nan";
    } else {
      return distanceBetween(
              lat1: _currentPosition?.latitude,
              lon1: _currentPosition?.longitude,
              lat2: kTestLat,
              lon2: kTestLon)
          .toStringAsFixed(1);
    }
  }

  String getLiveDistancesToGoal() {
    if (_livePosition == null) {
      return "nan";
    } else {
      return distanceBetween(
              lat1: _livePosition?.latitude,
              lon1: _livePosition?.longitude,
              lat2: kTestLat,
              lon2: kTestLon)
          .toStringAsFixed(1);
    }
  }

  LatLng getLatLngShiftedLon({required LatLng latLng, double offset = 100}) {
    //Earth’s radius, sphere
    double R = 6378137;
    //Coordinate offsets in radians
    // final double dLat = offset/R;
    final double dLon =
        offset / (R * math.cos(math.pi * latLng.latitude / 180));
    //OffsetPosition, decimal degrees
    // final double newLat = latLng.latitude + dLat * 180/math.pi;
    final double newLon = latLng.longitude + dLon * 180 / math.pi;
    return LatLng(latLng.latitude, newLon);
  }

  List<double> getLatLngShiftedLonInList(
      {required List<double> latLng, double offset = 100}) {
    //Earth’s radius, sphere
    double R = 6378137;
    //Coordinate offsets in radians
    // final double dLat = offset/R;
    final double dLon = offset / (R * math.cos(math.pi * latLng[0] / 180));
    //OffsetPosition, decimal degrees
    // final double newLat = latLng.latitude + dLat * 180/math.pi;
    final double newLon = latLng[1] + dLon * 180 / math.pi;
    return [latLng[0], newLon];
  }

  List<double> getLatLngShiftedLatInList(
      {required List<double> latLng, double offset = 100}) {
    //Earth’s radius, sphere
    double R = 6378137;
    //Coordinate offsets in radians
    // final double dLat = offset/R;
    final double dLat = offset / R;
    //OffsetPosition, decimal degrees
    // final double newLat = latLng.latitude + dLat * 180/math.pi;
    final double newLat = latLng[0] + dLat * 180 / math.pi;
    return [newLat, latLng[1]];
  }

  Future<Position?> setCurrentUserPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

//  Position get getCUrrentUserPostion => _position!;

}
