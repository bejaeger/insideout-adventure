import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked/stacked.dart';

class MapViewModel extends BaseViewModel {
  //final _geolocationService = locator<GeolocationService>();
  final _placesService = locator<PlacesService>();
  final log = getLogger('MapViewModel');
  List<Marker> markers = [];

  final CameraPosition position = CameraPosition(
    target: LatLng(49.246445, -122.994560),
    zoom: 12,
  );

  Future getCurrentLocation() async {
    setBusy(true);
    //Verify If location is available.
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
/*           _position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best); */

        _position = await _placesService.getPlacesAtCurrentLocation();
      } catch (error) {
        throw MapViewModelException(
            message:
                'An error occured in the defining your position $_position',
            devDetails: "Error message from Map View Model  ",
            prettyDetails:
                "An internal error occured on our side, please apologize and try again later.");

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

  void initState() {
    setBusy(true);
    getCurrentLocation().then((pos) {
      addMarker(pos, 'currpos', 'You are here!');
    }).catchError((err) => print(err.toString()));
    setBusy(false);
    notifyListeners();
  }
}
