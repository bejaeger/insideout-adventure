import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:afkcredits/app/app.logger.dart';
// small service to check for permission!

class PermissionService {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final LocalStorageService  _localStorageServie = locator<LocalStorageService>();
  final log = getLogger("PermissionService");

  Future<bool> allPermissionsProvided() async {
    // location
    var serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    var permission = await _geolocatorPlatform.checkPermission();
    bool location = false;
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      location = true;
    }

    // notification
    bool notifications = await AwesomeNotifications().isNotificationAllowed();

    // camera
    // NOT used atm!
    // var status = await Permission.camera.status;
    // status.isGranted;
    dynamic testedAr = await _localStorageServie.getFromDisk(key: kConfiguredArKey);

    return serviceEnabled && location && notifications && testedAr != null;
  }
}
