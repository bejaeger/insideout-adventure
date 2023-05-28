import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/services/local_secure_storage_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsViewModel extends BaseModel {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final LocalSecureStorageService _localStorageServie =
      locator<LocalSecureStorageService>();
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final log = getLogger("PermissionsViewModel");

  bool showReinstallScreen = false;
  bool changedPermission = false;

  Future<void> runPermissionLogic() async {
    bool allGood = true;

    allGood = allGood & await handleLocationPermission();

    allGood = allGood & await handleNotificationPermissions();

    // not used at the moment
    // allGood = allGood & await handleCameraPermissions();

    await handleArTest();

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

  // @ https://pub.dev/packages/geolocator
  // The geolocator will automatically try to request permissions when you try to acquire a location through the getCurrentPosition or getPositionStream methods.
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
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
      // This won't await for the user to turn back to the app.
      // So he will be immediately faced with the new handleLocationPermission and thus
      // the "Oops" text
      await openAppSettings();
      // UNLESS: We show this again. and when the user pressed okay things should be fine now!
      await showReinstallOrChangePermissionDialog(permissionType: "location");
      notifyListeners();
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

  Future handleCameraPermissions() async {
    var status = await Permission.camera.status;
    log.v("camera permissions: $status");
    if (status.isDenied || status.isPermanentlyDenied) {
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
        // see comments above on why we show this dialog again
        await showReinstallOrChangePermissionDialog(permissionType: "camera");
        notifyListeners();
        return await handleCameraPermissions();
      } else {
        changedPermission = true;
      }
    }
    return true;
  }

  Future handleArTest() async {
    // AR not supported yet for Android
    if (!appConfigProvider.isARAvailable) {
      _localStorageServie.saveToDisk(key: kConfiguredArKey, value: "true");
      return;
    }

    await showTestArDialog();
    bool ok = false;
    try {
      dynamic res = await navToArObjectView(true);
      ok = res is bool && res == true;
    } catch (e) {
      log.e("Cannot open AR view");
    }
    if (ok) {
      userService.setIsUsingAr(value: true);
      await showArWorksDialog();
      await _localStorageServie.saveToDisk(
          key: kConfiguredArKey, value: "true");
    } else {
      final res = await showArFailedDialog();
      if (res?.confirmed == true) {
        await handleCameraPermissions();
        await handleArTest();
      } else {
        await showArDoesNotWorkDialog();
        await _localStorageServie.saveToDisk(
            key: kConfiguredArKey, value: "true");
        // AR is available but it is configured NOT to use AR!
        userService.setIsUsingAr(value: false);
      }
    }
  }

  Future showLocationPermissionRequestDialog() async {
    await dialogService.showDialog(
        title: "Enable location access",
        description:
            "For this app to work we need to know about your location. Please allow us to use your precise location in the following.");
  }

  // ? This is a bit more complicated as the 'requestPermissionToSendNotifications' does
  // ? not seem to work properly.
  // ? The user has to press 'Ok' twice! After he enabled notifications the flow goes on!
  // ? Otherwise the user will be always prompted with the notifications dialog.
  Future showNotificationPermissionRequestDialog({Completer? completer}) async {
    final res = await dialogService.showDialog(
        title: "Enable notifications",
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
    await AwesomeNotifications().requestPermissionToSendNotifications(
      //channelKey: kScheduledNotificationChannelKey,
      // TODO: Maybe have to add CriticalAlert here
      permissions: const [
        NotificationPermission.Badge,
        NotificationPermission.Alert,
        NotificationPermission.Sound,
        NotificationPermission.Vibration,
        NotificationPermission.Light,
        NotificationPermission.CriticalAlert,
        NotificationPermission.PreciseAlarms,
        NotificationPermission.OverrideDnD,
      ],
    ).then(
      (_) {
        popView();
        completer.complete();
        notifyListeners();
      },
    );
  }

  Future showCameraPermissionRequestDialog() async {
    await dialogService.showDialog(
        title: "Enable camera access",
        description:
            "To use our augmented reality features we need to access the camera.");
  }

  Future showTestArDialog() async {
    await dialogService.showDialog(
        title: "Test AR feature",
        description:
            "To use our augmented reality feature we need to access the camera.");
  }

  Future showArWorksDialog() async {
    await dialogService.showDialog(
        title: "Augmented reality is ready to go", description: "Enjoy!");
  }

  Future showArFailedDialog() async {
    return await dialogService.showDialog(
        title: "Cannot configure AR",
        description: "Did you deny camera access?",
        buttonTitle: "Give camera access",
        cancelTitle: "Continue without AR");
  }

  Future showArDoesNotWorkDialog() async {
    await dialogService.showDialog(
        title: "Cannot configure AR",
        description:
            "Good news: everything in the app still works. Only the augmented reality reature is not supported for this device :)");
  }

  Future showReinstallOrChangePermissionDialog(
      {required String permissionType}) async {
    await dialogService.showDialog(
        title: "Sorry...that did not work",
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
        title: "Sorry...that did not work",
        description:
            "Please enable your location service on the device to use this app.");
  }
}
