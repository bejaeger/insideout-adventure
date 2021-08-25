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
  List<UserFavPlaces>? userFavouritePlaces;

  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.4219983, -122.084),
    zoom: 8,
  );

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

//Add Markers to the Map
  void addMarker(
      {required double lat,
      required double long,
      required String markerId,
      required markerTitle}) {
    setBusy(true);
    markersTmp.add(
      Marker(
          markerId: MarkerId(markerId),
          //position: _pos,
          position: LatLng(lat, long),
          infoWindow: InfoWindow(title: markerTitle, snippet: 'Vancouver'),
          icon: (markerId == 'currpos')
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange)),
    );
    setBusy(false);
    notifyListeners();
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    setBusy(true);
    try {
      _pos = geolocation.getUserPosition;
      log.i('Harguilar Nhanga $_pos');
      addMarker(
          lat: _pos!.latitude,
          long: _pos!.longitude,
          markerId: 'currpos',
          markerTitle: 'BernaBy');
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured in the defining ',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, please apologize and try again later.");
    }
    getUserFavouritePlaces();
    setBusy(false);
    notifyListeners();
  }

  Future getUserFavouritePlaces() async {
    setBusy(true);
    userFavouritePlaces = await _userService.getUserFavouritePlaces(
        userId: _userService.currentUser.uid);

    for (UserFavPlaces _userFavouritePlaces in userFavouritePlaces!) {
      addMarker(
          markerId: _userFavouritePlaces.id,
          markerTitle: _userFavouritePlaces.name,
          lat: _userFavouritePlaces.lat!,
          long: _userFavouritePlaces.lon!);
    }
    markersTmp = markersTmp;
    log.v('These Are the Values in the current Markers $markersTmp');
    setBusy(false);
    notifyListeners();
  }

  Future<void> createFavouritePlaces() async {
    setBusy(true);
    final getUser = _userService.currentUser;
    log.v('The Current userId: ${getUser.uid}');
    await _userService.createUserFavouritePlaces(
      userId: getUser.uid,
      favouritePlaces: UserFavPlaces(
          id: getUser.uid,
          name: "Beautiful park",
          lat: 37.756750,
          lon: -122.450270,
          image: ''),
    );
    setBusy(false);
    notifyListeners();
  }
}
