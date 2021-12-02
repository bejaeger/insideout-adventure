import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/directions/directions.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked_services/stacked_services.dart';

class MapViewModel extends QuestViewModel {
  final log = getLogger('MapViewModel');
  final _geolocationService = locator<GeolocationService>();

  //Quest? userQuest;
  final _bottomSheetService = locator<BottomSheetService>();
  final QuestService questService = locator<QuestService>();
  final DialogService _dialogService = locator<DialogService>();
  final _qrCodeService = locator<QRCodeService>();
  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();

  int currentIndex = 0;
  void toggleIndex() {
    if (currentIndex == 0) {
      currentIndex = 1;
    } else {
      currentIndex = 0;
    }
    notifyListeners();
  }

  Set<Marker> _markersTmp = {};
  //List<Places>? places;
  List<AFKMarker>? markers;
  List<Quest> get nearbyQuests => questService.nearbyQuests;

  GoogleMapController? _googleMapController;

  Marker? origin;
  Marker? destination;
  Directions? _directionInfo;

  //Get Google Map Controller
  GoogleMapController? get getGoogleMapController => _googleMapController;

  Set<Marker>? get getMarkers => _markersTmp;

  //Get Direction Info
  Directions? get getDirectionInfo => _directionInfo;

  Future initialize() async {
    log.i("Initializing map view");
    setBusy(true);
    try {
      if (_geolocationService.getUserPosition == null) {
        await _geolocationService.getAndSetCurrentLocation();
      } else {
        _geolocationService.getAndSetCurrentLocation();
      }
    } catch (e) {
      if (e is GeolocationServiceException) {
        // if (kIsWeb) {
        //   await dialogService.showDialog(
        //       title: "Sorry", description: "Map not supported on PWA version");
        // } else {
        if (_flavorConfigProvider.enableGPSVerification) {
          await dialogService.showDialog(
              title: "Sorry", description: e.prettyDetails);
        } else {
          if (!shownDummyModeDialog) {
            await dialogService.showDialog(
                title: "Dummy mode active",
                description:
                    "GPS connection not available, you can still try out the quests by tapping on the markers");
            shownDummyModeDialog = true;
          }
        }
        // }
      } else {
        await showGenericInternalErrorDialog();
      }
    }
    try {
      loadQuests();
    } catch (e) {
      log.wtf("Error when loading quest, this should never happen. Error: $e");
      await showGenericInternalErrorDialog();
    }
    setBusy(false);
  }

  CameraPosition? initialCameraPosition() {
    if (_geolocationService.getUserPosition != null) {
      final CameraPosition _initialCameraPosition = CameraPosition(
          target: LatLng(_geolocationService.getUserPosition!.latitude,
              _geolocationService.getUserPosition!.longitude),
          zoom: 13);
      return _initialCameraPosition;
    } else {
      return CameraPosition(
        target: getDummyCoordinates(),
        zoom: 14,
      );
    }
  }

  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker}) {
    _markersTmp.add(
      Marker(
          markerId: MarkerId(afkmarker
              .id), // google maps marker id of start marker will be our quest id
          position: LatLng(afkmarker.lat!, afkmarker.lon!),
          infoWindow: InfoWindow(snippet: quest.name),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () async {
            // ? quest already preloaded
            // Quest _quest = await questService.getQuest(questId: afkmarker.id);

            //log.i('This is a User Quest $userQuest');
            bool adminMode = false;

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
                  quest: quest,
                  startMarker: afkmarker,
                );
              } else {
                _dialogService.showDialog(
                    title: "You Currently Have a Running Quest !!!");
              }
            }
          }),
    );
  }

  Future onQuestInListTapped(Quest quest) async {
    log.i("Quest list item tapped!!!");
    if (hasActiveQuest == false) {
      await displayQuestBottomSheet(
        quest: quest,
      );
    } else {
      _dialogService.showDialog(
          title: "You Currently Have a Running Quest !!!");
    }
  }

  @override
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result) async {
    if (result.isEmpty) {
      return Future.value();
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
      if (result.quests != null && result.quests!.length > 0) {
        // TODO: Handle case where more than one quest is returned here!
        // For now, just start first quest!
        log.i("Found quests associated to the scanned start marker.");
        await displayQuestBottomSheet(
          quest: result.quests![0],
          startMarker: result.quests![0].startMarker,
        );
      } else {
        await dialogService.showDialog(
            title:
                "The scanned Marker is not a start of a quest. Please go to the starting point");
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    // setBusy(true);
    _googleMapController = controller;
    // try {
    //   loadQuests();
    // } catch (error) {
    //   throw MapViewModelException(
    //       message: 'An error occured in the defining ',
    //       devDetails: "Error message from Map View Model $error ",
    //       prettyDetails:
    //           "An internal error occured on our side, please apologize and try again later.");
    // }
    // setBusy(false);
  }

  void loadQuests() async {
    await questService.loadNearbyQuests();
    extractStartMarkersAndAddToMap();
    notifyListeners();
  }

  void extractStartMarkersAndAddToMap() {
    if (nearbyQuests.isNotEmpty) {
      for (Quest _q in nearbyQuests) {
        AFKMarker _m = _q.startMarker;
        addMarkerToMap(quest: _q, afkmarker: _m);
      }
      _markersTmp = _markersTmp;
    } else {
      log.i('Markers are Empty');
    }
  }

  Future displayQuestBottomSheet(
      {required Quest quest, AFKMarker? startMarker}) async {
    SheetResponse? sheetResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.questInformation,
        title: ' Name: ' + quest.name,
        description: 'Description: ' + quest.description,
        mainButtonTitle: "Start Quest",
        secondaryButtonTitle: "Close",
        data: quest);
    if (sheetResponse?.confirmed == true) {
      await startQuest(quest: quest);
    }
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }
}
