import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Marks {
  Marker addMarkers({required LatLng pos, required String markerId}) {
    return Marker(
      markerId: MarkerId(markerId),
      infoWindow: InfoWindow(title: markerId),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: pos,
    );
  }

  //TODO: Refactor the Code Below with the Abstract Class.
  AFKMarker returnAFK(
      {required LatLng pos, required String markerId, required String qrCode}) {
    return AFKMarker(
        id: markerId, qrCodeId: qrCode, lat: pos.latitude, lon: pos.longitude);
  }
}
