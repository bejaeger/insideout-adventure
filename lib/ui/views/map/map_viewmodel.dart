import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/directions/directions.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';

class MapViewModel extends BaseModel {
  final log = getLogger('MapViewModel');
  final _geolocationService = locator<GeolocationService>();

  //Quest? userQuest;
  final _bottomSheetService = locator<BottomSheetService>();
  final QuestService questService = locator<QuestService>();
  final DialogService _dialogService = locator<DialogService>();
  //final StopWatchService _stopWatchService = locator<StopWatchService>();
  final _markersService = locator<MarkerService>();
  final _navigationService = locator<NavigationService>();
  final _qrCodeService = locator<QRCodeService>();
  Set<Marker> _markersTmp = {};
  //List<Places>? places;
  List<AFKMarker>? markers;
  var _userPostion;
  //bool _tappedMarkers = false;

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

  CameraPosition initialCameraPosition() {
    log.i('Your Position Inside  initialCameraPosition is $_userPostion');

    final CameraPosition _initialCameraPosition = CameraPosition(
        target: LatLng(_userPostion.latitude, _userPostion.longitude), zoom: 8);
    return _initialCameraPosition;
  }

  // bool get tappedMarkers => _tappedMarkers;
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
            Quest _quest = await questService.getQuest(questId: afkmarker.id);

            // userQuest = _quest;
            //log.i('This is a User Quest $userQuest');
            bool adminMode = false;
            //Set The Quest that Will Start.
            if (_quest != null) {
              questService.setStartedQuest(startedQuest: _quest);
            }

            // _tappedMarkers = true;
            //  notifyListeners();
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
                await displayQuestBottomSheet(
                  markers: afkmarker,
                );
              } else {
                _dialogService.showDialog(
                    title: "'You Currently Have a Running Quest !!!");
              }
            }
          }),
    );
    setBusy(false);
    notifyListeners();
  }

  Future scanQrCodeWithActiveQuest() async {
    QuestQRCodeScanResult result = await navigateToQrcodeViewAndReturnResult();
    handleQrCodeScanEvent(result);
  }

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

  setCurrentUserPosition() {
    setBusy(true);
    try {
      if (_geolocationService.getUserPosition != null) {
        _userPostion = _geolocationService.getUserPosition;
        log.i('Your Position Values is $_userPostion');
      } else {
        log.wtf('Your Position Values is Null Look at it: $_userPostion');
      }
    } catch (e) {}
    setBusy(false);
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    setBusy(true);
    _googleMapController = controller;
    try {
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
      await questService.startQuest(quest: quest);
      await _navigationService.replaceWith(Routes.questView);
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
    } else {
      log.i('Markers are Empty');
    }
    setBusy(false);
    notifyListeners();
  }

  Future displayQuestBottomSheet({required AFKMarker markers}) async {
    Quest quest = await questService.getQuest(questId: markers.questId!);
    if (quest != null) {
      SheetResponse? sheetResponse = await _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.questInformation,
          title: ' Name: ' + quest.name,
          description: 'Description: ' + quest.description,
          mainButtonTitle: "Start Quest",
          secondaryButtonTitle: "Close");

      if (sheetResponse!.confirmed == true) {
        //Set The Quest that Will Start.
        questService.setStartedQuest(startedQuest: quest);
        //User Will Start a Quest
        checkRunningQuest = true;
        await startQuest();
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