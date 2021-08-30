import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/directions/directions.dart';
import 'package:afkcredits/datamodels/places/places.dart';
import 'package:afkcredits/datamodels/users/favorite_places/user_fav_places.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
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
  List<Places>? places;

  GoogleMapController? _googleMapController;
  Marker? origin;
  Marker? destination;
  Directions? info;

  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.4219983, -122.084),
    zoom: 8,
  );

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  //Get Google Map Controller
  GoogleMapController? get getGoogleMapController => _googleMapController;

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
    _googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 14.5,
          tilt: 50.0,
        ),
      ),
    );
    setBusy(false);
    notifyListeners();
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    setBusy(true);
    try {
      _googleMapController = controller;
      _pos = geolocation.getUserPosition;
      log.i('Harguilar Nhanga $_pos');
      //This is the Initial Marker In the Map.
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
    getPlaces();
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

  Future getPlaces() async {
    setBusy(true);
    places = await geolocation.getPlaces();

    if (places!.isNotEmpty) {
      for (Places _p in places!) {
        addMarker(
            markerId: _p.id, markerTitle: _p.name, lat: _p.lat!, long: _p.lon!);
      }
      markersTmp = markersTmp;
      log.v('These Are the Values in the current Markers $markersTmp');
      setBusy(false);
      notifyListeners();
    } else {
      log.i('Places is Empty');
    }
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

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }
}
