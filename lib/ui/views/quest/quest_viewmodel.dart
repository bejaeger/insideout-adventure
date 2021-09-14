import 'dart:async';
import 'package:afkcredits/apis/direction_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/directions/directions.dart';
import 'package:afkcredits/datamodels/places/places.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/favorite_places/user_fav_places.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class QuestViewModel extends BaseViewModel {
  final log = getLogger('QuestViewModel');
  final geolocation = locator<GeolocationService>();
  final _directionsAPI = locator<DirectionsAPI>();
  //final _bottomSheetService = locator<BottomSheetService>();
  final QuestService questService = locator<QuestService>();
  final DialogService _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _qrcodeService = locator<QRCodeService>();
  final _stopWatchService = locator<StopWatchService>();
  final _userService = locator<UserService>();
  Quest? _startedQuest;
  List<Markers>? setOfCollectedMarkers = [];
  int idx = 0;

  Set<Marker>? _markersTmp = {};
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

  ActivatedQuest get activeQuest => questService.activatedQuest!;

  Set<Marker>? get getMarkers => _markersTmp;

  //Get Direction Info
  Directions? get getDirectionInfo => _directionInfo;

  // ignore: non_constant_identifier_names
  CameraPosition initialCameraPosition() {
    final CameraPosition _initialCameraPosition = CameraPosition(
      //In Future I will change these values to dynamically Change the Initial Camera Position
      //Based on teh city
      target: LatLng(
          _startedQuest!.startMarker.lat!, _startedQuest!.startMarker.lon!),
      zoom: 9,
    );

    return _initialCameraPosition;
  }

  Future finishCompletedQuest({required int numMarkersCollected}) async {
    //Stop The Timer;
    _stopWatchService.stopTimer();

    //Running Quest Been Finshed.
    checkRunningQuest = false;
    //final result = await questService.finishQuest();

    await _dialogService.showDialog(
        title: "Congratz, you succesfully finished the quest!",
        buttonTitle: 'Ok');

    //checkRunningQuest = false;
    //await questService.cancelIncompleteQuest();
    //await _dialogService.showDialog(title: "Quest cancelled");
    //Add all the information of the Quest in the Firebase.
    await questService.finishQuest(
        finishedQuest: _startedQuest,
        userId: _userService.currentUser.uid,
        numMarkersCollected: numMarkersCollected,
        timeElapse: activeQuest.timeElapsed.toString());
    _navigationService.replaceWith(Routes.mapView);

    //await _dialogService.showDialog(title: "Quest cancelled");
    //_navigationService.replaceWith(Routes.mapView);
  }

  Future finishQuest() async {
    try {
      final result = await questService.evaluateAndFinishQuest();
      if (result is String) {
        final continueQuest = await _dialogService.showConfirmationDialog(
            title: result.toString(),
            cancelTitle: "Cancel",
            confirmationTitle: "Continue");
        if (continueQuest?.confirmed == true) {
          await questService.continueIncompleteQuest();
        } else {
          //Running Quest Been Cancelled.
          checkRunningQuest = false;
          await questService.cancelIncompleteQuest();
          await _dialogService.showDialog(title: "Quest cancelled");
          _navigationService.replaceWith(Routes.mapView);
        }
      } else {
        await _dialogService.showDialog(
            title: "Congratz, you succesfully finished the quest!");
      }
    } catch (e) {
      log.e("Could not finish quest, error thrown: $e");
    }
  }

//Add Markers to the Map
  void addMarker({Markers? markers}) {
    setBusy(true);
    _markersTmp!.add(
      Marker(
          markerId: MarkerId(markers!.id),
          position: LatLng(markers.lat!, markers.lon!),
          infoWindow:
              InfoWindow(title: _startedQuest!.name, snippet: 'Vancouver'),
          icon: (_startedQuest!.startMarker.id == markers.id)
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
          onTap: () {
            if (checkRunningQuest == true) {
              ///Remove Marker Should be present.
              ///Once the user click on the marker that marker should go out of the Map as collected one.

              //Keep Track of already Collected Markers.
              if (setOfCollectedMarkers!.length > 0) {
                for (int idx = 0; idx < setOfCollectedMarkers!.length; idx++) {
                  if (setOfCollectedMarkers![idx].qrCodeId ==
                      markers.qrCodeId) {
                    _dialogService.showDialog(
                        description:
                            'qrcode already used ${setOfCollectedMarkers![idx].qrCodeId}! Try another one');
                    foundMarker = true;
                    //reset the Index
                    idx = 0;
                    break;
                  }
                }
                if (foundMarker == false) {
                  setOfCollectedMarkers!.add(markers);
                  //update the Collected Markers.
                  questService.verifyAndUpdateCollectedMarkers(marker: markers);
                } else {
                  //put Back Found Marker to False;
                  foundMarker = false;
                }
              } else {
                //add markers to tco
                setOfCollectedMarkers!.add(markers);
                //update the Collected Markers.
                questService.verifyAndUpdateCollectedMarkers(marker: markers);

                //Convert QRCODE String To Markers
                _qrcodeService.convertQrCodeStringToMarker(
                    qrCodeString: markers.qrCodeId);

                //Convert Markers Into QRCODE
                _qrcodeService.convertMarkerToQrCodeString(marker: markers);
              }

              if (setOfCollectedMarkers!.length ==
                  activeQuest.markersCollected.length) {
                final _markersCollected = setOfCollectedMarkers!.length;
                print(
                    'This is The Number of Markers Collected: ${_markersCollected.toString()}');

                finishCompletedQuest(numMarkersCollected: _markersCollected);
                //finishQuest();
              }

              // _navService.navigateTo(Routes.qRCodeViewMobile);
            } else {
              _dialogService.showDialog(
                  title: "Quest Not Running",
                  description: "Verify Your Quest Because is not running");
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

  void initilizeStartedQuest() {
    _startedQuest = questService.getStartedQuest;

    log.i('You Have Started This Quest $_startedQuest');
    getDirections(
        origin: LatLng(
            _startedQuest!.startMarker.lat!, _startedQuest!.startMarker.lon!),
        destination: LatLng(_startedQuest!.finishMarker.lat!,
            _startedQuest!.finishMarker.lon!));
  }

  Quest get getStartedQuest => _startedQuest!;

  Future<void> onMapCreated(GoogleMapController controller) async {
    setBusy(true);
    try {
      _googleMapController = controller;
      //Add Starter Marker
      getQuestMarkers();
      //addMarker(markers: _startedQuest!.startMarker);
    } catch (error) {
      throw MapViewModelException(
          message: 'An error occured in the defining ',
          devDetails: "Error message from Map View Model $error ",
          prettyDetails:
              "An internal error occured on our side, please apologize and try again later.");
    }
    //getPlaces();
    setBusy(false);
    notifyListeners();
  }

  Future getQuestMarkers() async {
    setBusy(true);
    //places = await geolocation.getPlaces();

    for (Markers _m in _startedQuest!.markers) {
      addMarker(markers: _m);
    }
    _markersTmp = _markersTmp;
    log.v('These Are the Values in the current Markers $_markersTmp');
    setBusy(false);
    notifyListeners();
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }
}
