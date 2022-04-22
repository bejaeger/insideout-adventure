import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/services/pedometer/pedometer_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class StepCounterOverlayViewModel extends BaseModel {
  // ------------------------------------------------------
  // services
  final PedometerService _pedometerService = locator<PedometerService>();
  final log = getLogger("StepCounterOverlayViewModel");

  // ------------------------------------------
  // getters
  bool get isCounting => _pedometerService.isCounting;
  String get count => _pedometerService.currentCount.toString();

  // --------------------------------
  // state
  String pedestrianStatus = "?";

  // flag that will be set to false after the first step count has been emitted
  bool firstEvent = true;

  // ---------------------------------------------------------
  // Functions

  Future startPedometer() async {
    // need to request permission
    final grantedPermission =
        await _pedometerService.isActivityPermissionGranted();
    if (!grantedPermission) {
      await dialogService.showDialog(
          title: "We would like to use the step counter.",
          description: "Please say yes in the following screen");
      final result = await _pedometerService.requestActivityPermission();
      if (!result) {
        return;
      }
    }

    // start pedometer
    final result = _pedometerService.startPedometer(onStatusListen: (status) {
      pedestrianStatus = status.status;
      notifyListeners();
    }, onStepCountListen: (_) {
      if (firstEvent == true) {
        firstEvent = false;
      }
      log.v("New step count event!");
      notifyListeners();
    });
    if (result is String) {
      log.e("Could not start pedometer because of error: $result");
      snackbarService.showSnackbar(
          title: "Couldn't start step counter", message: result.toString());
      notifyListeners();
    } else {
      snackbarService.showSnackbar(title: "Started pedometer", message: "");
      notifyListeners();
    }
  }

  void stopPedometer() {
    pedestrianStatus = "?";
    firstEvent = true;
    _pedometerService.stopPedometer();
    snackbarService.showSnackbar(title: "Stopped pedometer", message: "");
    notifyListeners();
  }

  //     final Battery battery = Battery();
  //     final isInBatterySaveMode = await battery.isInBatterySaveMode;
  //     if (isInBatterySaveMode != true) {
  //       return false;
  //     } else if (isInBatterySaveMode == true) {
  //       log.i("Phone is in battery save mode, show dialog");
  //       final result = await dialogService.showDialog(
  //         title: "Disable Battery Saver",
  //         description:
  //             "For best performance, please disable Power Saver in Settings/Battery.",
  //         buttonTitle: "SETTINGS",
  //         cancelTitle: "START ANYWAY",
  //         barrierDismissible: true,
  //       );
  //       if (result?.confirmed == true) {
  //         try {
  //           await OpenSettings.openBatterySaverSetting();
  //           return true;
  //         } catch (e) {
  //           log.e("Could not open settings");
  //           await Future.delayed(Duration(milliseconds: 500));
  //           await dialogService.showDialog(
  //             title: "Could Not Open Settings",
  //             description:
  //                 "Sorry, we could not open your settings. Please navigate to Settings/Battery yourself.",
  //           );
  //           return true;
  //         }
  //         // await checkIfBatterySaveModeOn();
  //       } else if (result?.confirmed == false) {
  //         return false;
  //       }
  //       return true;
  //       // await Future.delayed(Duration(milliseconds: 300));
  //     }
  //     return true;
  //   } catch (e) {
  //     log.e("Could not check battery save mode!");
  //     log.e("Error: $e");
  //     return false;
  //   }
  // }
}
