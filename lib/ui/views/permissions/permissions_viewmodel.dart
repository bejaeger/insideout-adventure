import 'dart:async';

import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:afkcredits/app/app.logger.dart';

// View that asks for all permissions

// - Geolocation
// - Notifications

// - Camera for AR view
// - URL launcher?
// - Activity
// - ...
// - maybe battery save mode

class PermissionsViewModel extends BaseModel {
  // -----------------------------------------------------------
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final log = getLogger("PermissionsViewModel");

  // -----------------------------
  // state
  bool showReinstallScreen = false;
  bool changedPermission = false;

  // -------------------------------------------------
  // Main function
  Future<void> runPermissionLogic() async {
    bool allGood = true;

    // - location permission
    allGood = allGood & await handleLocationPermission();

    // - notification service
    allGood = allGood & await handleNotificationPermissions();

    // - camera service
    // Not used at the moment!
    //allGood = allGood & await handleCameraPermissions();

    // - activity service
    // Not used at the moment!

    if (allGood) {
      if (changedPermission) {
        await showAllSetDialog();
      }
      popView();
    } else {
      // we are at a dead end here!
      // without location permission the app won't work!
      showReinstallScreen = true;
      notifyListeners();
    }
    notifyListeners();
  }

  // ---------------------------------------------
  // helper functions

  // @ https://pub.dev/packages/geolocator
  // The geolocator will automatically try to request permissions when you try to acquire a location through the getCurrentPosition or getPositionStream methods.
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      log.i("Location service not enabled.");
      await showEnableLocationOnDeviceDialog();
      return false;
    }
    permission = await _geolocatorPlatform.checkPermission();
    log.v("location permissions: $permission");
    if (permission == LocationPermission.denied) {
      await showLocationPermissionRequestDialog();
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        log.i("Location service denied.");
        return await handleLocationPermission();
      } else {
        changedPermission = true;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      log.i("Location service denied forever.");
      await showReinstallOrChangePermissionDialog(permissionType: "location");
      await openAppSettings();
      return await handleLocationPermission();
    }
    return true;
  }

  Future handleNotificationPermissions() async {
    bool allowed = await AwesomeNotifications().isNotificationAllowed();
    log.v("notification permissions: $allowed");
    if (!allowed) {
      Completer completer = Completer();
      showNotificationPermissionRequestDialog(completer: completer);
      await completer.future;
      changedPermission = true;
    }
    return true;
  }

  // ? Not used at the moment
  Future handleCameraPermissions() async {
    var status = await Permission.camera.status;
    log.v("camera permissions: $status");
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      await showCameraPermissionRequestDialog();
      status = await Permission.camera.request();
      if (status.isDenied) {
        return await handleCameraPermissions();
      } else {
        changedPermission = true;
      }
      if (status.isPermanentlyDenied) {
        await showReinstallOrChangePermissionDialog(permissionType: "camera");
        await openAppSettings();
        return await handleCameraPermissions();
      } else {
        changedPermission = true;
      }
    }
    return true;
  }

  // -------------------------------------------------------
  // Dialogs
  Future showLocationPermissionRequestDialog() async {
    await dialogService.showDialog(
        title: "Give location access",
        description:
            "For this app to work we need your location. Please allow us to use your precise location in the following.");
  }

  // ? This is a bit more complicated as the 'requestPermissionToSendNotifications' does
  // ? not seem to work properly.
  // ? The user has to press 'Ok' twice! After he enabled notifications the flow goes on!
  // ? Otherwise the user will be always prompted with the notifications dialog.
  Future showNotificationPermissionRequestDialog({Completer? completer}) async {
    final res = await dialogService.showDialog(
        title: "Allow notifications",
        description:
            "For optimal usage of the app we would like to send you notifications.");
    if (res?.confirmed == true) {
      if ((completer != null && completer.isCompleted) || completer == null) {
      } else {
        askForNotificationPermission(completer: completer);
        showNotificationPermissionRequestDialog(completer: completer);
      }
    }
  }

  Future askForNotificationPermission({required Completer completer}) async {
    AwesomeNotifications()
        .requestPermissionToSendNotifications(
            // TODO: Maybe have to add CriticalAlert here
            // permissions: const [
            //   NotificationPermission.Badge,
            //   NotificationPermission.Alert,
            //   NotificationPermission.Sound,
            //   NotificationPermission.Vibration,
            //   NotificationPermission.Light,
            //   NotificationPermission.CriticalAlert,
            // ],
            )
        .then(
      (_) {
        popView();
        completer.complete();
        notifyListeners();
      },
    );
  }

  Future showCameraPermissionRequestDialog() async {
    await dialogService.showDialog(
        title: "Allow camera access",
        description:
            "To use our augmented reality features we need to access the camera.");
  }

  Future showReinstallOrChangePermissionDialog(
      {required String permissionType}) async {
    await dialogService.showDialog(
        title: "Oops...that didn't work",
        description:
            "For this app to work we need $permissionType permissions. Please change the permissions in your settings to which we will forward you.");
  }

  Future showAllSetDialog() async {
    await dialogService.showDialog(
        title: "You are all set!",
        //description: "You are all set!",
        buttonTitle: "Let's go");
  }

  Future showEnableLocationOnDeviceDialog() async {
    await dialogService.showDialog(
        title: "Oops...",
        description:
            "Please enable your location service on the device to use this app.");
  }
}
