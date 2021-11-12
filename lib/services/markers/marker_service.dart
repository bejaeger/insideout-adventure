import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/app/app.logger.dart';

class MarkerService {
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();

  final log = getLogger("MarkerService");
  final _firestoreApi = locator<FirestoreApi>();
  List<AFKMarker>? _markersLists;

  Future<bool> isUserCloseby({required AFKMarker marker}) async {
    if (_flavorConfigProvider.enableGPSVerification) {
      if (marker.lat != null && marker.lon != null) {
        return await _geolocationService.isUserCloseby(
            lat: marker.lat!, lon: marker.lon!);
      } else {
        log.wtf("Marker does not have coordinates assigned yet!");
        return false;
      }
    } else {
      log.e(
          "We will pretend that the user is nearby the marker in any case (without checking actual GPS) because we run in test mode at the moment!");
      return true;
    }
  }

  Future<void> createMarkers({required AFKMarker markers}) async {
    await _firestoreApi.createMarkers(markers: markers);
  }

  //Get User Favourite Places
  Future<List<AFKMarker>?> getQuestMarkers() async {
    return await _firestoreApi.getMarkers();
  }

  Future<void> setQuestMarkers({required List<AFKMarker> markers}) async {
    _markersLists = markers;
  }

  List<AFKMarker> get getSetMarkers => _markersLists!;

  //Markers get getMarkers => getDummyMarker1
  // TODO
  // Future functions for admin account!
  // - generateMarker
  //   -> calls qrcode service to generate a qrcodeId
  //   -> build marker model with that qrcode Id
  //   -> adds marker to firestore with document id also stored in Marker model
}
