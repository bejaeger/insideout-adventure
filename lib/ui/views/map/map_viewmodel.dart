import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/directions/directions.dart';
import 'package:afkcredits/datamodels/places/places.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/favorite_places/user_fav_places.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';

class MapViewModel extends QuestViewModel {
  final log = getLogger('MapViewModel');
  final geolocation = locator<GeolocationService>();
  //final _userService = locator<UserService>();
  //final _directionsAPI = locator<DirectionsAPI>();
  final _bottomSheetService = locator<BottomSheetService>();
  final QuestService questService = locator<QuestService>();
  final DialogService _dialogService = locator<DialogService>();
  //final StopWatchService _stopWatchService = locator<StopWatchService>();
  final _markersService = locator<MarkerService>();
  final _navigationService = locator<NavigationService>();
  final _qrCodeService = locator<QRCodeService>();
  Set<Marker> _markersTmp = {};
  //StreamSubscription<int>? _timerSubscription;
  Position? _pos;
  List<UserFavPlaces>? userFavouritePlaces;
  List<Places>? places;
  List<AFKMarker>? markers;

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
  void addMarker({required AFKMarker afkmarker}) {
    setBusy(true);

    _markersTmp.add(
      Marker(
          markerId: MarkerId(afkmarker.id),
          position: LatLng(afkmarker.lat!, afkmarker.lon!),
          infoWindow: InfoWindow(snippet: 'Vancouver'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () async {
            bool adminMode = false;
            if (userIsAdmin) {
              adminMode = await showAdminDialogAndGetResponse();
              if (adminMode) {
                String qrCodeString =
                    _qrCodeService.getQrCodeStringFromMarker(marker: afkmarker);
                navigationService.navigateTo(Routes.qRCodeView,
                    arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
              }
            }
            if (!userIsAdmin || adminMode == false) {
              if (hasActiveQuest == false) {
                displayQuestBottomSheet(
                  markers: afkmarker,
                );
              } else {
                // final activeQuestLenght= questService.activatedQuest!.length;
                _dialogService.showDialog(
                    title: "'You Currently Have a Running Quest !!!");
              }
            }
          }),
    );
    setBusy(false);
    notifyListeners();
  }

  @override
  void handleQrCodeScanEvent(QuestQRCodeScanResult result) {
    if (result.isEmpty) {
      return;
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
    } else {
      if (result.marker != null) {
        log.i("Scanned marker belongs to currently active quest");
        snackbarService.showSnackbar(
            title: "Collected Marker!",
            message: "Successfully collected marker",
            duration: Duration(seconds: 2));
      }
      if (result.quests != null) {
        log.i("Found quests associated to the scanned start marker.");
        snackbarService.showSnackbar(
            title: "Start quest?",
            message: "Not yet fully implemented!",
            duration: Duration(seconds: 2));
      }
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    setBusy(true);
    try {
      _googleMapController = controller;
      _pos = geolocation.getUserPosition;
      //This is the Initial Marker In the Map.
      getQuestMarkers();
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

  Future startQuest() async {
    setBusy(true);
    try {
      final quest = await questService.getQuest(questId: "QuestDummyId");

      /// Once The user Click on Start a Quest. It tks her/him to new Page
      ///Differents Markers will Display as Part of the quest as well The App showing the counting of the
      ///Quest.
      await questService.startQuest(quest: quest, uids: [currentUser.uid]);
      _navigationService.replaceWith(Routes.activeQuestView);

/*            
Clock Timer       
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
                      */

    } catch (e) {
      log.e("Could not start quest, error thrown: $e");
    }
  }

  void getQuestMarkers() {
    setBusy(true);
    markers = _markersService.getSetMarkers;

    if (markers!.isNotEmpty) {
      for (AFKMarker _m in markers!) {
        addMarker(afkmarker: _m);
      }
      _markersTmp = _markersTmp;
      log.v('These Are the Values in the current Markers $_markersTmp');
      setBusy(false);
      notifyListeners();
    } else {
      log.i('Markers are Empty');
    }
  }

  Future<void> createMarkers() async {
    // TODO: Get this from firestore api and set up proper dummy data in dummy_datamodels.dart
    setBusy(true);
    await _markersService.createMarkers(
        markers: AFKMarker(
            id: "9hJodek7hlwwUVl0VgzN",
            qrCodeId: "QRCode2Id",
            lat: 37.487846,
            lon: -122.236115,
            questId: 'QuestId'));
    await _markersService.createMarkers(
        markers: AFKMarker(
            id: "nc9tNP2lSdzbjjC1p574",
            qrCodeId: "QRCode2Id",
            lat: 37.75675,
            lon: -122.45027,
            questId: 'QuestId01'));
    await _markersService.createMarkers(
        markers: AFKMarker(
            id: "Marker3Id",
            qrCodeId: "QRCode3Id",
            lat: 37.4219983,
            lon: -122.084,
            questId: 'QuestId02'));

    setBusy(false);
    notifyListeners();
  }

  Future displayQuestBottomSheet({required AFKMarker markers}) async {
    Quest quest = await questService.getQuest(questId: markers.questId!);

    if (quest != null) {
      SheetResponse? sheetResponse = await _bottomSheetService.showBottomSheet(
          title: ' Name: ' + quest.name,
          description: 'Description: ' + quest.description,
          // description: "OR add new payment method +",
          confirmButtonTitle: "Start Quest",
          cancelButtonTitle: "Close");
      if (sheetResponse!.confirmed == true) {
        //Set The Quest that Will Start.
        questService.setStartedQuest(startedQuest: quest);
        //User Will Start a Quest
        checkRunningQuest = true;
        startQuest();
      }
    } else {
      log.w('You Providing an Empty Quest');
    }
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }
}
