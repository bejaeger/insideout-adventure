import 'dart:async';
import 'dart:math';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/position_retrieval.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:device_info/device_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show describeEnum, kIsWeb;
import 'package:location/location.dart' as loc;
import 'dart:io' show Platform;
import 'package:afkcredits/app/app.logger.dart';
import 'package:notion_api/notion.dart';
import 'package:notion_api/notion/general/lists/children.dart';
import 'package:notion_api/notion/general/lists/properties.dart';
import 'package:notion_api/notion/general/property.dart';
import 'package:notion_api/notion/general/rich_text.dart';
import 'package:notion_api/notion/general/types/notion_types.dart';
import 'package:notion_api/notion/objects/database.dart';
import 'package:notion_api/notion/objects/pages.dart';
import 'package:notion_api/notion/objects/parent.dart';
import 'package:notion_api/responses/notion_response.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

class GeolocationService {
  late String trial;
  GeolocationService() {
    var rng = new Random();
    trial = rng.nextInt(100000).toString();
  }
  final log = getLogger('GeolocationService');
  final _firestoreApi = locator<FirestoreApi>();
  StreamSubscription? _currentPositionStreamSubscription;
  final NotionClient notion =
      NotionClient(token: 'secret_q0fv8n18xW5l1PS9ipqljUphAXvmvCyXqKfGjcqXvWs');

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Position? _position;
  Position? get getUserPosition => _position;
  double? currentGPSAccuracy;
  String? gpsAccuracyInfo;

  // position with stream
  Position? _livePosition;
  Position? get getUserLivePosition => _livePosition;

  // current position forced
  Position? _currentPosition;
  Position? get getCurrentPosition => _currentPosition;

  // last known position
  Position? _lastKnownPosition;
  Position? get getLastKnownPosition => _lastKnownPosition;

  List<PositionEntry> allPositions = [];

  String currentLocationDistanceKey = "currentLocationDistance";
  String liveLocationDistanceKey = "liveLocationDistance";
  String lastKnownLocationDistanceKey = "lastKnownLocationDistance";
  String triggeredByKey = "triggeredBy";

  String currentLocationTimestampKey = "currentLocationTimestamp";
  String liveLocationTimestampKey = "liveLocationTimestamp";
  String lastKnownLocationTimestampKey = "lastKnownLocationTimestamp";

  String currentLocationLatitudeKey = "currentLocationLatitude";
  String liveLocationLatitudeKey = "liveLocationLatitude";
  String lastKnownLocationLatitudeKey = "lastKnownLocationLatitude";

  String currentLocationLongitudeKey = "currentLocationLongitude";
  String liveLocationLongitudeKey = "liveLocationLongitude";
  String lastKnownLocationLongitudeKey = "lastKnownLocationLongitude";

  String currentLocationAccuracyKey = "currentLocationAccuracy";
  String liveLocationAccuracyKey = "liveLocationAccuracy";
  String lastKnownLocationAccuracyKey = "lastKnownLocationAccuracy";

  String trialEntryKey = "trial";

  String deviceInfoKey = "deviceInfo";

  void listenToPosition(
      {double distanceFilter = kMinDistanceFromLastCheckInMeters}) {
    if (_currentPositionStreamSubscription == null) {
      // TODO: Provide proper error message to user in case of
      // denied permission, no access to gps, ...
      _currentPositionStreamSubscription = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best,
              distanceFilter: distanceFilter.round())
          .listen((position) {
        log.v("New position event fired from location listener!");
        printPositionInfo(position);
        _livePosition = position;
        addPositionEntry(trigger: LocationRetrievalTrigger.listener);
      });
    }
  }

  setGPSAccuracyInfo(String? info) {
    gpsAccuracyInfo = info;
  }

  Future<Position> getAndSetCurrentLocation(
      {bool forceGettingNewPosition = false}) async {
    //Verify If location is available on device.
    final checkGeolocation = await checkGeolocationAvailable();
    if (checkGeolocation == true) {
      try {
        // if (!kIsWeb) {
        Duration? difference;
        if (getUserPosition != null) {
          difference = getUserPosition?.timestamp?.difference(DateTime.now());
        }

        // cooldown time of 5 seconds for distance check and NEW positions should be retrieved.
        if ((difference != null &&
            difference.inSeconds.abs() > 5 &&
            forceGettingNewPosition)) {
          // log.wtf("---------------------------------");
          log.i("Getting current position now at ${DateTime.now().toString()}");
          final geolocatorPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            //forceAndroidLocationManager: true,
          );

          log.i("Retrieved position at ${DateTime.now().toString()}");

          currentGPSAccuracy = geolocatorPosition.accuracy;
          if (currentGPSAccuracy != null &&
              currentGPSAccuracy! > kThresholdGPSAccuracyToShowInfo) {
            setGPSAccuracyInfo(
                "Low GPS Accuracy (${currentGPSAccuracy?.toStringAsFixed(0)} m)");
          } else {
            setGPSAccuracyInfo(null);
          }
          _position = geolocatorPosition;
          printPositionInfo(geolocatorPosition);
          return geolocatorPosition;
        } else {
          // return previous location

          final lastKnownPosition = await Geolocator.getLastKnownPosition();
          if (lastKnownPosition != null) {
            log.v("Returning last known position");
            _position = lastKnownPosition;
            return lastKnownPosition;
          } else {
            if (_position != null) {
              log.v("Returning previously fetched position");
              printPositionInfo(_position!);
              return _position!;
            } else {
              log.v("Force getting new position");
              return getAndSetCurrentLocation(forceGettingNewPosition: true);
            }
          }
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

/*   //Get User Favourite Places
  Future<List<Places>?> getPlaces() async {
    return await _firestoreApi.getPlaces();
  }
 */
  Future<bool> isUserCloseby({required double lat, required double lon}) async {
    log.v("Check if user is closeby marker based on last known location");
    final position = await getAndSetCurrentLocation();
    if (countAsCloseByMarker(position: position, lat: lat, lon: lon)) {
      log.v("User is nearby the marker!");
      return true;
    } else {
      // not nearby marker but try to recover with new forced calculation
      log.v(
          "User not nearby the marker, try calculating a NEW position and check again");
      final position =
          await getAndSetCurrentLocation(forceGettingNewPosition: true);
      return countAsCloseByMarker(position: position, lat: lat, lon: lon);
    }
  }

  bool countAsCloseByMarker(
      {required Position position, required double lat, required double lon}) {
    double distanceInMeters = Geolocator.distanceBetween(
        position.latitude, position.longitude, lat, lon);
    if (distanceInMeters > kMaxDistanceFromMarkerInMeter) {
      return true;
    } else {
      return false;
    }
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

  void printPositionInfo(Position position) {
    log.v(
        "position lat, lon, accuracy, seconds ago: ${position.latitude}, ${position.longitude}, ${position.accuracy}, ${position.timestamp?.difference(DateTime.now()).inSeconds}");
  }

  void cancelPositionListener() {
    _currentPositionStreamSubscription?.cancel();
    _currentPositionStreamSubscription = null;
  }

  void clearData() {
    _position = null;
    _lastKnownPosition = null;
    _currentPosition = null;
    _livePosition = null;
    currentGPSAccuracy = null;
    cancelPositionListener();
  }

  // ------------------------------------------------
  // -------------------------------------------------
  // R & D
  Future addPositionEntry(
      {required LocationRetrievalTrigger trigger,
      bool pushToNotion = false}) async {
    _lastKnownPosition = await Geolocator.getLastKnownPosition();
    if (trigger != LocationRetrievalTrigger.onlyLastKnown) {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    }
    final positionEntry = PositionEntry(
        entryNumber: allPositions.length,
        triggeredBy: trigger,
        livePosition: _livePosition,
        currentPosition: _currentPosition,
        lastKnownPosition: _lastKnownPosition);
    log.v("Adding position entry");
    allPositions.add(positionEntry);
    if (pushToNotion) {
      try {
        return await pushNotionDatabaseEntry(positionEntry);
      } catch (e) {
        log.e("Error pushing entry to notion db: $e");
        return false;
      }
    } else {
      return true;
    }
  }

  Future pushAllPositionsToNotion() async {
    bool ok = true;
    for (int i = 0; i < allPositions.length; i++) {
      ok = ok & await pushNotionDatabaseEntry(allPositions[i]);
    }
    return ok;
  }

  Map<String, String> getDistanceToGoal(
      {required PositionEntry positionEntry,
      required double lat,
      required double lon}) {
    Map<String, String> distancesMap = {
      currentLocationDistanceKey: "-1",
      liveLocationDistanceKey: "-1",
      lastKnownLocationDistanceKey: "-1",
      triggeredByKey: "",
    };
    String distanceInMetersAsString = distanceBetween(
            lat1: positionEntry.livePosition?.latitude,
            lon1: positionEntry.livePosition?.longitude,
            lat2: lat,
            lon2: lon)
        .toStringAsFixed(1);
    distancesMap[liveLocationDistanceKey] = distanceInMetersAsString;
    distanceInMetersAsString = distanceBetween(
            lat1: positionEntry.currentPosition?.latitude,
            lon1: positionEntry.currentPosition?.longitude,
            lat2: lat,
            lon2: lon)
        .toStringAsFixed(1);
    distancesMap[currentLocationDistanceKey] = distanceInMetersAsString;
    distanceInMetersAsString = distanceBetween(
            lat1: positionEntry.lastKnownPosition?.latitude,
            lon1: positionEntry.lastKnownPosition?.longitude,
            lat2: lat,
            lon2: lon)
        .toStringAsFixed(1);
    distancesMap[lastKnownLocationDistanceKey] = distanceInMetersAsString;
    distancesMap[triggeredByKey] =
        describeEnum(positionEntry.triggeredBy).toString();
    return distancesMap;
  }

  Future pushNotionDatabaseEntry(PositionEntry entry) async {
    // ID of manually created database
    final String databaseId = "3fa2284a2aec40a5a6d03089493be25a";

    Page newEntry = Page(
      parent: Parent.database(id: databaseId), // <- database
      title: Text(entry.entryNumber.toString()),
    );

    String deviceInfoString = "";
    if (Platform.isAndroid) {
      // Android-specific code
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log.v('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
      deviceInfoString = "machine: " +
          androidInfo.model +
          ", systemVersion: " +
          androidInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log.v('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
      deviceInfoString = "machine: " +
          iosInfo.utsname.machine +
          ", systemName: " +
          iosInfo.systemName +
          ", systemVersion: " +
          iosInfo.systemVersion;
      // iOS-specific code
    }
    addNotionDatabaseTextProperty(newEntry, deviceInfoKey, deviceInfoString);
    addNotionDatabaseTextProperty(newEntry, trialEntryKey, trial);

    // timestamps
    addNotionDatabaseTextProperty(newEntry, currentLocationTimestampKey,
        entry.currentPosition?.timestamp.toString());
    addNotionDatabaseTextProperty(newEntry, lastKnownLocationTimestampKey,
        entry.lastKnownPosition?.timestamp?.toString());
    addNotionDatabaseTextProperty(newEntry, liveLocationTimestampKey,
        entry.livePosition?.timestamp?.toString());

    // longitude
    addNotionDatabaseTextProperty(newEntry, currentLocationLongitudeKey,
        entry.currentPosition?.longitude.toString());
    addNotionDatabaseTextProperty(newEntry, lastKnownLocationLongitudeKey,
        entry.lastKnownPosition?.longitude.toString());
    addNotionDatabaseTextProperty(newEntry, liveLocationLongitudeKey,
        entry.livePosition?.longitude.toString());

    // latitude
    addNotionDatabaseTextProperty(newEntry, currentLocationLatitudeKey,
        entry.currentPosition?.latitude.toString());
    addNotionDatabaseTextProperty(newEntry, lastKnownLocationLatitudeKey,
        entry.lastKnownPosition?.latitude.toString());
    addNotionDatabaseTextProperty(newEntry, liveLocationLatitudeKey,
        entry.livePosition?.latitude.toString());

    // accuracy
    addNotionDatabaseTextProperty(newEntry, currentLocationAccuracyKey,
        entry.currentPosition?.accuracy.toStringAsFixed(2));
    addNotionDatabaseTextProperty(newEntry, lastKnownLocationAccuracyKey,
        entry.lastKnownPosition?.accuracy.toStringAsFixed(2));
    addNotionDatabaseTextProperty(newEntry, liveLocationAccuracyKey,
        entry.livePosition?.accuracy.toStringAsFixed(2));

    // Add calculated distance to random location in heidach
    Map<String, String> distancesToGoal = getDistanceToGoal(
        positionEntry: entry, lat: 48.06701330843975, lon: 7.903736956224777);

    [
      currentLocationDistanceKey,
      liveLocationDistanceKey,
      lastKnownLocationDistanceKey,
      triggeredByKey
    ].forEach((element) {
      addNotionDatabaseTextProperty(
          newEntry, element, distancesToGoal[element]);
    });
    try {
      final NotionResponse notionResponse = await notion.pages.create(newEntry);
      if (notionResponse.hasError) {
        log.e(
            "Error when pushing data to notion database: ${notionResponse.message}");
        return false;
      } else {
        log.i("Created entry in notion database");
        return true;
      }
    } catch (e) {
      log.wtf(e);
      return false;
    }
  }

  String getLastKnownDistancesToGoal() {
    if (_lastKnownPosition == null) {
      return "nan";
    } else {
      if (allPositions.length > 0) {
        Map<String, String> distancesToGoal = getDistanceToGoal(
            positionEntry: allPositions.last,
            lat: 48.06701330843975,
            lon: 7.903736956224777);
        return distancesToGoal[lastKnownLocationDistanceKey] ?? "-1";
      } else {
        return "nan";
      }
    }
  }

  String getCurrentDistancesToGoal() {
    if (_lastKnownPosition == null) {
      return "nan";
    } else {
      if (allPositions.length > 0) {
        Map<String, String> distancesToGoal = getDistanceToGoal(
            positionEntry: allPositions.last,
            lat: 48.06701330843975,
            lon: 7.903736956224777);
        return distancesToGoal[currentLocationDistanceKey] ?? "-1";
      } else {
        return "nan";
      }
    }
  }

  String getLiveDistancesToGoal() {
    if (_lastKnownPosition == null) {
      return "nan";
    } else {
      if (allPositions.length > 0) {
        Map<String, String> distancesToGoal = getDistanceToGoal(
            positionEntry: allPositions.last,
            lat: 48.06701330843975,
            lon: 7.903736956224777);
        return distancesToGoal[liveLocationDistanceKey] ?? "-1";
      } else {
        return "nan";
      }
    }
  }
}

void addNotionDatabaseTextProperty(
    Page page, String propertyName, String? propertyContent) {
  page.addProperty(
    name: propertyName,
    property: RichTextProp(
      content: [
        Text(propertyContent ?? "nan"),
      ],
    ),
  );
}

class PositionEntry {
  final Position? livePosition;
  final Position? currentPosition;
  final Position? lastKnownPosition;
  final LocationRetrievalTrigger triggeredBy;
  final int entryNumber;
  const PositionEntry(
      {required this.triggeredBy,
      required this.livePosition,
      required this.currentPosition,
      required this.lastKnownPosition,
      required this.entryNumber});
}
