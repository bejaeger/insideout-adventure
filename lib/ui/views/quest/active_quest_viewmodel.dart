import 'dart:async';
import 'package:afkcredits/apis/direction_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/directions/directions.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';

class ActiveQuestViewModel extends QuestViewModel {
  final log = getLogger('ActiveQuestViewModel');
  final geolocation = locator<GeolocationService>();
  final _directionsAPI = locator<DirectionsAPI>();
  final QuestService questService = locator<QuestService>();
  final DialogService _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _stopWatchService = locator<StopWatchService>();
  final _qrCodeService = locator<QRCodeService>();

  Quest get startedQuest => questService.getStartedQuest!;

  BitmapDescriptor? sourceIcon;
  int idx = 0;
  Set<Marker> _markersTmp = {};
  GoogleMapController? _googleMapController;
  Marker? origin;
  Marker? destination;
  Directions? _directionInfo;

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
      target:
          LatLng(startedQuest.startMarker.lat!, startedQuest.startMarker.lon!),
      zoom: 12,
    );

    return _initialCameraPosition;
  }

  Future _finishCompletedQuest({required int numMarkersCollected}) async {
    //final result = await questService.evaluateAndFinishQuest();

    //Stop The Timer;
    _stopWatchService.stopTimer();

    //Running Quest Been Finshed.
    checkRunningQuest = false;
    //final result = await questService.finishQuest();

    try {
      //Add all the information of the Quest in the Firebase.
      dynamic result;
      try {
        setBusy(true);
        result = await questService.evaluateAndFinishQuest();
        setBusy(false);
      } catch (e) {
        setBusy(false);
        if (e is QuestServiceException) {
          await _dialogService.showDialog(
              title: e.prettyDetails, buttonTitle: 'Ok');
          _navigationService.replaceWith(Routes.mapView);
          return;
        } else {
          log.e("Unknown error occured from evaluateAndFinishQuest");
          rethrow;
        }
      }
      if (result is String) {
        log.wtf(
            "An error occured when trying to finish the quest. The following warning was thrown: $result");
      } else {
        await _dialogService.showDialog(
            title: "Congratz, you succesfully finished the quest!",
            buttonTitle: 'Ok');
        _navigationService.replaceWith(Routes.mapView);
      }
    } catch (e) {
      setBusy(false);
      await _dialogService.showDialog(
          title: "An internal error occured on our side. Sorry!",
          buttonTitle: 'Ok');
      log.wtf(
          "An error occured when trying to finish the quest. This should never happen!");
      _navigationService.replaceWith(Routes.mapView);
    }
  }

  BitmapDescriptor defineMarkersColour({required AFKMarker afkmarker}) {
    final index =
        activeQuest.quest.markers.indexWhere((element) => element == afkmarker);
    if (!activeQuest.markersCollected[index]) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
  }

  void updateMapMarkers({required AFKMarker afkmarker}) {
    _markersTmp = _markersTmp
        .map((item) => item.markerId == MarkerId(afkmarker.id)
            ? item.copyWith(
                iconParam: defineMarkersColour(afkmarker: afkmarker))
            : item)
        .toSet();
    notifyListeners();
  }

  // Add Markers to the Map
  void addMarker({required AFKMarker afkmarker}) {
    _markersTmp.add(
      Marker(
          markerId: MarkerId(afkmarker.id),
          position: LatLng(afkmarker.lat!, afkmarker.lon!),
          infoWindow: InfoWindow(title: afkmarker.id),
          // icon: (_startedQuest!.startMarker.id == markers.id)
          icon: defineMarkersColour(afkmarker: afkmarker),
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
              QuestQRCodeScanResult scanResult =
                  await questService.handleQrCodeScanEvent(marker: afkmarker);
              await handleQrCodeScanEvent(scanResult);
            }
          }),
    );
  }

  Future handleCollectMarkerEvent({required AFKMarker afkmarker}) async {
    if (hasActiveQuest == true) {
      updateMapMarkers(afkmarker: afkmarker);
      checkIfQuestFinishedAndFinishQuest();
    } else {
      _dialogService.showDialog(
          title: "Quest Not Running",
          description: "Verify Your Quest Because is not running");
    }
  }

  Future scanQrCodeWithActiveQuest() async {
    QuestQRCodeScanResult result = await navigateToQrcodeViewAndReturnResult();
    await handleQrCodeScanEvent(result);
  }

  @override
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result) async {
    if (result.isEmpty) {
      return;
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
      snackbarService.showSnackbar(
          title: "Failed to collect marker!",
          message: result.errorMessage!,
          duration: Duration(seconds: 2));
    } else {
      if (result.marker != null) {
        log.i("Scanned marker sucessfully collected!");
        await handleCollectMarkerEvent(afkmarker: result.marker!);
        snackbarService.showSnackbar(
            title: "Collected Marker!",
            message: "Successfully collected marker",
            duration: Duration(seconds: 2));
      }
      // if (result.quests != null) {
      //   log.i("Found quests associated to the scanned start marker.");
      //   snackbarService.showSnackbar(
      //       title: "Start quest?",
      //       message: "Not yet fully implemented!",
      //       duration: Duration(seconds: 2));
      // }
    }
  }

  // TODO: Move to quest service!
  void checkIfQuestFinishedAndFinishQuest() {
    if (questService.isAllMarkersCollected) {
      final _markersCollected = questService.getNumberMarkersCollected;
      log.i(
          "This is The Number of Markers Collected: ${_markersCollected.toString()}");
      _finishCompletedQuest(numMarkersCollected: _markersCollected);
      //finishQuest();
    }
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

  void initializeStartedQuest() {
    sourceIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    log.i('You Have Started This Quest $startedQuest');
    // TODO: What is this getDirections about?
    // Throws an error in direction.dart datamodel
    // getDirections(
    //     origin: LatLng(
    //         startedQuest.startMarker.lat!, startedQuest.startMarker.lon!),
    //     destination: LatLng(
    //         startedQuest.finishMarker.lat!, startedQuest.finishMarker.lon!));
  }

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
    for (AFKMarker _m in startedQuest.markers) {
      addMarker(afkmarker: _m);
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
