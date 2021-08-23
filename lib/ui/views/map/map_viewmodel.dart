import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/users/favorite_places/user_fav_places.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:permission_handler/permission_handler.dart';

class MapViewModel extends BaseViewModel {
  final log = getLogger('MapViewModel');
  final geolocation = locator<GeolocationService>();
  final _userService = locator<UserService>();

  Set<Marker> markersTmp = {};
  Position? _pos;

  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.4219983, -122.084),
    zoom: 12,
  );

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    setBusy(true);
    try {
      _pos = geolocation.getUserPosition;
      log.i('Harguilar Nhanga $_pos');
      markersTmp.add(
        Marker(
            markerId: MarkerId('currpos'),
            //position: _pos,
            position: LatLng(_pos!.latitude, _pos!.longitude),
            infoWindow: InfoWindow(title: 'BernaBy', snippet: 'Vancouver'),
            icon: ('currpos' == 'currpos')
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange)),
      );
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured in the defining ',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, please apologize and try again later.");
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> createFavouritePlaces() async {
    setBusy(true);
    final getUser = _userService.currentUser;
    await _userService.createUserFavouritePlaces(
        userId: getUser.uid,
        favouritePlaces: UserFavPlaces(
            id: getUser.uid,
            name: "Beautiful park",
            lat: 41.9294115,
            lon: 12.5380785,
            image: ''));

    setBusy(false);
    notifyListeners();
  }
}
