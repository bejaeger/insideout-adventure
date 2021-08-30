import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/app/app.logger.dart';

class MarkerService {
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final log = getLogger("MarkerService");

  Future<bool> isUserCloseby({required Marker marker}) async {
    if (marker.lat != null && marker.lon != null) {
      return await _geolocationService.isUserCloseby(
          lat: marker.lat!, lon: marker.lon!);
    } else {
      log.wtf("Marker does not have coordinates assigned yet!");
      return false;
    }
  }

  // TODO
  // Future functions for admin account!
  // - generateMarker
  //   -> calls qrcode service to generate a qrcodeId
  //   -> build marker model with that qrcode Id
  //   -> adds marker to firestore with document id also stored in Marker model
}
