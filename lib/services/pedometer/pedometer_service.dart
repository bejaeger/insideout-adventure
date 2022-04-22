import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:afkcredits/app/app.logger.dart';

// For now very simple with callback functionality!
class PedometerService {
  StreamSubscription? _pedestrianStatusStreamSubscription;
  StreamSubscription? _stepCountStreamSubscription;
  final log = getLogger("PedometerService");
  bool get isCounting => _stepCountStreamSubscription != null;
  // String _status = '?';
  // String _steps = '?';

  Future startPedometer(
      {required void Function(PedestrianStatus) onStatusListen,
      required void Function(StepCount) onStepCountListen,
      bool requestPermission = false}) async {
    try {
      // TODO:
      // Anti-cheat feature!

      // Idea:
      // 1. store location at start of pedometer
      // 2. At step 50: check location again and calculate distance
      // 3. If distance < threshold: WARNING
      //   (Of course the person could have walked in a circle, but this is hopefully negligible)
      //   (Can also check the speed of the second location)
      // 4. Show and increment a warning and repeat:
      // 5. If second warning is there reset step count

      if (requestPermission) {
        final grantedPermission = await requestActivityPermission();
        if (!grantedPermission) {
          return "Please allow us to use the phone's step counter";
        }
      }
      final _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      if (_pedestrianStatusStreamSubscription == null) {
        _pedestrianStatusStreamSubscription =
            _pedestrianStatusStream.listen(onStatusListen);
      }

      final _stepCountStream = Pedometer.stepCountStream;
      if (_stepCountStreamSubscription == null) {
        _stepCountStreamSubscription =
            _stepCountStream.listen(onStepCountListen);
      }
    } catch (e) {
      return "Cannot start pedometer";
    }
  }

  void stopPedometer() {
    _pedestrianStatusStreamSubscription?.cancel();
    _pedestrianStatusStreamSubscription = null;
    _stepCountStreamSubscription?.cancel();
    _stepCountStreamSubscription = null;
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
}
