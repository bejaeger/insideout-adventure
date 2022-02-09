import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:afkcredits/app/app.logger.dart';

class MapsService {
  final log = getLogger("MapsService");

  Future launchMapsForNavigation(double lat, double lon) async {
    final availableMaps = await MapLauncher.installedMaps;
    log.i("Available maps: $availableMaps");

    if (availableMaps.isEmpty) {
      return "No maps installed on phone";
    }

    await availableMaps.first.showDirections(
      destination: Coords(lat, lon),
      //title: "AFK Credits Quest",
    );
  }

  LatLngBounds boundsFromLatLngList({required List<LatLng> latLngList}) {
    if (latLngList.length == 0) {
      log.e("Can't created LatLngBounds from empty list!");
      throw Exception("Can't created LatLngBounds from empty list!");
    }
    double? x0, x1, y0, y1;
    for (LatLng latLng in latLngList) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
}
