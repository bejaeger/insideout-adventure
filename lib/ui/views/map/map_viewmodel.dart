import 'package:afkcredits/app/app.logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class MapViewModel extends BaseViewModel {
  final log = getLogger('MapViewModel');
  List<Marker> markers = [];

  final CameraPosition position = CameraPosition(
    target: LatLng(49.246445, -122.994560),
    zoom: 12,
  );

  Future getCurrentLocation() async {
    setBusy(true);
    final checkGeolocation = await checkGeolocationAvailable();
    Position _position = Position(
      longitude: this.position.target.longitude,
      latitude: this.position.target.latitude,
      speed: 0.0,
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speedAccuracy: 1.0,
      timestamp: null,
    );

    if (checkGeolocation) {
      try {
        _position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
      } catch (error) {
        return _position;
      }

      return _position;
    }

    setBusy(false);
    notifyListeners();
  }

  Future<bool> checkGeolocationAvailable() async {
    bool isGeolocationAvailable = await Geolocator.isLocationServiceEnabled();
    return isGeolocationAvailable;
  }

  void addMarker(Position pos, String markerId, String markerTitle) {
    setBusy(true);
    final marker = Marker(
        markerId: MarkerId(markerId),
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow: InfoWindow(title: markerTitle),
        icon: (markerId == 'currpos')
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            : BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange));
    markers.add(marker);

    markers = markers;
    setBusy(false);
    notifyListeners();
  }
}
