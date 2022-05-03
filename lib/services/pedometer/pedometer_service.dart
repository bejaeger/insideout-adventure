import 'dart:async';
import 'dart:collection';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/services/common_services/pausable_service.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:rxdart/subjects.dart';

// For now very simple with callback functionality!
class PedometerService extends PausableService {
  // services
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final log = getLogger("PedometerService");

  // member variables
  StreamSubscription? _pedestrianStatusStreamSubscription;
  StreamSubscription? _stepCountStreamSubscription;

  // exposed
  // ?? Could also make this a behavior subject
  bool get isCounting => _stepCountStreamSubscription != null;
  //int get currentCount => liveCount - initialCount;
  int get currentCount => countSubject.value;

  // state
  int initialCount = 0;
  int liveCount = 0;

  // queue holding previous positions -> FIFO
  Position? previousLocation;
  bool lastLocationCheated = false;

  final BehaviorSubject countSubject = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject statusSubject = BehaviorSubject<String>.seeded("");

  // will be set to false when pedometer started
  // needs to be reset!
  bool firstEvent = true;

  Future listenToPedometer({bool requestPermission = false}) async {
    final _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    if (_pedestrianStatusStreamSubscription == null) {
      _pedestrianStatusStreamSubscription =
          _pedestrianStatusStream.listen((PedestrianStatus status) {
        statusSubject.add(status.status);
      });
    }
    final _stepCountStream = Pedometer.stepCountStream;
    if (_stepCountStreamSubscription == null) {
      _stepCountStreamSubscription =
          _stepCountStream.listen((StepCount count) async {
        if (firstEvent == true) {
          // check whether there was a previous count
          int? presetCount;
          var localPresetCount = await _localStorageService.getFromDisk(
              key: kLocalStoragePedometerCount);
          if (localPresetCount != null) {
            presetCount = int.parse(localPresetCount);
          }
          // presetCount is loaded when step counter is resumed!
          initialCount = presetCount ?? count.steps;
          firstEvent = false;
        }
        liveCount = count.steps;
        final realCount = liveCount - initialCount;
        countSubject.add(realCount);

        checkForCheater(realCount);
        log.v("Updated step counter");
      });
    }
  }

  Future startPedometer({bool requestPermission = false}) async {
    try {
      if (servicePaused == null) {
        // that means if app has just started!
        await stopPedometer();
      }

      if (requestPermission) {
        final grantedPermission = await requestActivityPermission();
        if (!grantedPermission) {
          return "Please allow us to use the phone's step counter";
        }
      }

      listenToPedometer();
    } catch (e) {
      return "Cannot start pedometer";
    }
  }

  Future stopPedometer() async {
    cancelSubscriptions();
    initialCount = 0;
    liveCount = 0;
    firstEvent = true;
    countSubject.add(0);
    statusSubject.add("");
    // set flag to true that pedometer is active.
    await _localStorageService.deleteFromDisk(key: kLocalStoragePedometerCount);
  }

  void cancelSubscriptions() {
    _pedestrianStatusStreamSubscription?.cancel();
    _pedestrianStatusStreamSubscription = null;
    _stepCountStreamSubscription?.cancel();
    _stepCountStreamSubscription = null;
  }

  Future<void> checkForCheater(int count) async {
    // TODO:
    // Anti-cheat feature!

    // Idea:
    // 1. store location after each 50 steps
    // 2. At step 50: check location again and calculate distance
    // 3. If distance < threshold: WARNING
    //   (Of course the person could have walked in a circle, but this is hopefully negligible)
    //   (Can also check the speed of the second location)
    // 4. Show and increment a warning and repeat:
    // 5. If second warning is there reset step count

    if ((count + 1) % (kStepFrequencyAntiCheat + 1) == 0) {
      log.v("Checking cheat feature");
      // plus one to avoid first count!
      Position newLocation =
          await _geolocationService.getAndSetCurrentLocation();
      double deltaPos = _geolocationService.distanceBetween(
          lat1: newLocation.latitude,
          lon1: newLocation.longitude,
          lat2: previousLocation?.latitude,
          lon2: previousLocation?.longitude);
      bool thisLocationCheated = false;
      if (deltaPos < kMinDistanceAntiCheat) {
        thisLocationCheated = true;
        if (count > (kStepFrequencyAntiCheat + 1)) {
          // surpassed first cheater check successfully!
          if (lastLocationCheated) {
            log.wtf("CHEATER EXPOSED!");
            countSubject.add(-2);
            initialCount = initialCount + kStepFrequencyAntiCheat * 2;
            countSubject.add(count - kStepFrequencyAntiCheat * 2);
          }
        } else {
          log.wtf("CHEATER EXPOSED!");
          countSubject.add(-1);
          initialCount = initialCount + kStepFrequencyAntiCheat;
          countSubject.add(count - kStepFrequencyAntiCheat);
        }
      }
      lastLocationCheated = thisLocationCheated;
      previousLocation = newLocation;
    }
  }

  ///////////////////////////////////////////
  // lifecycle functionality
  @override
  Future pause() async {
    if (_stepCountStreamSubscription != null) {
      _localStorageService.saveToDisk(
          key: kLocalStoragePedometerCount, value: initialCount.toString());

      // _pedestrianStatusStreamSubscription?.pause();
      // _stepCountStreamSubscription?.pause();

      // For some reason I need to fully cancel the streams here
      // in order to be able to resume them again1
      cancelSubscriptions();
      super.pause();
      log.v("Pedometer service paused");
    }
  }

  @override
  Future resume() async {
    if (servicePaused == true) {
      String? count = await _localStorageService.getFromDisk(
          key: kLocalStoragePedometerCount);
      if (count != null) {
        initialCount = int.parse(count);
      }
      if (_pedestrianStatusStreamSubscription == null ||
          _stepCountStreamSubscription == null) {
        listenToPedometer();
      } else {
        // Somehow resuming a paused stream subscription does not work!
        _pedestrianStatusStreamSubscription!.resume();
        _stepCountStreamSubscription!.resume();
      }
      countSubject.add(liveCount - initialCount);
      super.resume();
      log.v("Pedometer service resumed");
    } else {
      stopPedometer();
      log.v("Pedometer service resetted");
    }
  }

  // ??? Could add the following to a permission_service

  // Activity permission checker

  Future<bool> isActivityPermissionGranted() async {
    final status = await Permission.activityRecognition.status;
    return !status.isDenied;
  }

  Future<bool> requestActivityPermission() async {
    // Instantiate it
    try {
      if (!(await isActivityPermissionGranted())) {
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
        if (await Permission.activityRecognition.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          log.i("Permission has been granted");
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e) {
      log.e("Could not check activity recognition permission! Error: $e!");
      return false;
    }
  }

  ////////////////////////////////////////////////////////
  /// Clean up
  ///
  /// TODO: Add that to main dispose function
  void closeListener() {
    countSubject.close();
    statusSubject.close();
  }
}
