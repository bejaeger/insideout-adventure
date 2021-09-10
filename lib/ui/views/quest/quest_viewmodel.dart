import 'dart:async';
import 'package:afkcredits/apis/direction_api.dart';
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
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
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
  final _navService = locator<NavigationService>();
  final _qrcodeService = locator<QRCodeService>();
  Quest? _startedQuest;

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
      zoom: 10,
    );

    return _initialCameraPosition;
  }

//Add Markers to the Map
  void addMarker({Markers? markers}) {
    setBusy(true);
    _markersTmp!.add(
      Marker(
          markerId: MarkerId(markers!.id),
          //position: _pos,
          position: LatLng(markers.lat!, markers.lon!),
          infoWindow:
              InfoWindow(title: _startedQuest!.name, snippet: 'Vancouver'),
          icon: (_startedQuest!.startMarker.id == markers.id)
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
          onTap: () {
            if (checkRunningQuest == false) {
            } else {
              ///Remove Marker Should be present.
              ///Once the user click on the marker that marker should go out of the Map
              questService.verifyAndUpdateCollectedMarkers(marker: markers);

              _dialogService.showDialog(
                  title: "'You Currently Have a Running Quest !!!",
                  description:
                      "QRCODE DESCRIPTION: " + markers.qrCodeId.toString());

              //Convert QRCODE String To Markers
              _qrcodeService.convertQrCodeStringToMarker(
                  qrCodeString: markers.qrCodeId);

              //Convert Markers Into QRCODE
              _qrcodeService.convertMarkerToQrCodeString(marker: markers);

              _navService.navigateTo(Routes.qRCodeViewMobile);
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
