import 'dart:async';
import 'package:afkcredits/apis/direction_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/directions/directions.dart';
import 'package:afkcredits/datamodels/places/places.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/favorite_places/user_fav_places.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class QuestViewModel extends BaseViewModel {


   final log = getLogger('QuestViewModel');
  final geolocation = locator<GeolocationService>();
  final _userService = locator<UserService>();
  final _directionsAPI = locator<DirectionsAPI>();
  final _bottomSheetService = locator<BottomSheetService>();
  final QuestService questService = locator<QuestService>();
  final DialogService _dialogService = locator<DialogService>();
  final StopWatchService _stopWatchService = locator<StopWatchService>();

  Set<Marker> _markersTmp = {};
   StreamSubscription<int>? _timerSubscription;
  Position? _pos;
  List<UserFavPlaces>? userFavouritePlaces;
  List<Places>? places;

  GoogleMapController? _googleMapController;
  Marker? origin;
  Marker? destination;
  Directions? _directionInfo;

  //CameraPosition get initialCameraPosition => null;

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  //Get Google Map Controller
  GoogleMapController? get getGoogleMapController => _googleMapController;

  Set<Marker>? get getMarkers => _markersTmp;

  //Get Direction Info
  Directions? get getDirectionInfo => _directionInfo;

  // ignore: non_constant_identifier_names
  CameraPosition initialCameraPosition() {
    final CameraPosition _initialCameraPosition = CameraPosition(
      //In Future I will change these values to dynamically Change the Initial Camera Position
      //Based on teh city
      target: LatLng(37.4219983, -122.084),
      zoom: 8,
    );

    return _initialCameraPosition;
  }

//Add Markers to the Map
  void addMarker(
      {
      required Places places
      }) {
    setBusy(true);

    _markersTmp.add(
      Marker(
          markerId: MarkerId(places.id),
          //position: _pos,
          position: LatLng(places.lat!, places.lon!),
          infoWindow: InfoWindow(title: places.name!, snippet: 'Vancouver'),
          icon: (places.id == 'currpos')
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
          onTap: () {
                   if (checkRunningQuest ==  false){
            displayQuestBottomSheet(
              places: places,
              );
                }
                else {
                  _dialogService.showDialog(
                  title: "'You Currently Have a Running Quest !!!"); 
                }               
          }),
    );
    setBusy(false);
    notifyListeners();
  }
  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    setBusy(true);
    _directionInfo = await _directionsAPI.getDirections(
        origin: origin, destination: destination);
    setBusy(false);
    notifyListeners();
  }
  Future<void> onMapCreated(GoogleMapController controller) async {
    setBusy(true);
    try {
      _googleMapController = controller;
      _pos = geolocation.getUserPosition;
      //This is the Initial Marker In the Map.
      addMarker(
        places: Places(
          id: 'currpos', 
          lat: _pos!.latitude, 
          lon: _pos!.longitude, 
          name: 'Bernaby', 
          image: '',
          questId: 'questId02'
        ) 
      );
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

    Future startQuest() async {
      setBusy(true); 
    try {
      final quest = await questService.getQuest(questId: "QuestId");
      /// Once The user Click on Start a Quest. It tks her/him to new Page 
      ///Differents Markers will Display as Part of the quest as well The App showing the counting of the 
      ///Quest. 
      await questService.startQuest(quest: quest);

                  final timerStream = _stopWatchService.stopWatchStream();    
                   // ignore: cancel_subscriptions
                    _timerSubscription = timerStream.listen((int newTime) {             
                     _stopWatchService.setHours(hours:  ((newTime / (60 * 60)) % 60)
                            .floor()
                            .toString()
                            .padLeft(2, '0')); 
                       _stopWatchService.setMinutes(minutes:((newTime / 60) % 60)
                            .floor()
                            .toString()
                            .padLeft(2, '0') );
                            _stopWatchService.setSeconds(seconds:(newTime % 60).floor().toString().padLeft(2, '0'));             
                    });
                    _stopWatchService.setTimerStreamSubscription(timerSubscription: _timerSubscription!); 
                     setBusy(false); 
                     notifyListeners(); 

    } catch (e) {
      log.e("Could not start quest, error thrown: $e");
    }
  }

  Future getPlaces() async {
    setBusy(true);
    places = await geolocation.getPlaces();

    if (places!.isNotEmpty) {
      for (Places _p in places!) {
        addMarker(
           places: _p);
      }
      _markersTmp = _markersTmp;
      log.v('These Are the Values in the current Markers $_markersTmp');
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
          image: '', 

          ),
    );
    setBusy(false);
    notifyListeners();
  }

  Future displayQuestBottomSheet(
      {required Places places}) async {
      Quest quest = await questService.getQuest(questId: places.questId!);

    SheetResponse? sheetResponse = await _bottomSheetService.showBottomSheet(
       title: 'Am Displaying The quest Description: '  + quest.description
       // description: "OR add new payment method +",
        confirmButtonTitle: "Start Quest",
        cancelButtonTitle: "Close");
            if (sheetResponse!.confirmed == true){
          //User Will Start a Quest 
          
          checkRunningQuest = true; 
           startQuest(); 
          }    
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }
}
