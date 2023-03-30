import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';

class MarkerService {
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  final log = getLogger("MarkerService");

  Future<bool> isUserCloseby(
      {required AFKMarker? marker, int? geofenceRadius}) async {
    if (marker == null) {
      return false;
    }
    if (_flavorConfigProvider.enableGPSVerification) {
      if (marker.lat != null && marker.lon != null) {
        return await _geolocationService.isUserCloseby(
            lat: marker.lat!, lon: marker.lon!, threshold: geofenceRadius);
      } else {
        log.wtf("Marker does not have coordinates assigned yet!");
        return false;
      }
    } else {
      log.e(
          "We will pretend that the user is nearby the marker (without checking actual GPS) because we run in test mode at the moment!");
      await _geolocationService.setDistanceToLastCheckedMarker(
          lat: marker.lat!, lon: marker.lon!);
      return true;
    }
  }
}
