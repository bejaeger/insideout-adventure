import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/directions/directions.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/exceptions/mapviewmodel_expection.dart';
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
  final QuestService questService = locator<QuestService>();
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
    if (hasActiveQuest) return;
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
      await loadQuests();
      extractStartMarkersAndAddToMap();
      notifyListeners();
    } catch (e) {
      log.wtf("Error when loading quest, this should never happen. Error: $e");
      await showGenericInternalErrorDialog();
    }
    setBusy(false);
  }

  CameraPosition initialCameraPosition() {
    if (!hasActiveQuest) {
      if (_geolocationService.getUserPosition != null) {
        final CameraPosition _initialCameraPosition = CameraPosition(
            target: LatLng(_geolocationService.getUserPosition!.latitude,
                _geolocationService.getUserPosition!.longitude),
            zoom: 14);
        return _initialCameraPosition;
      } else {
        return CameraPosition(
          target: getDummyCoordinates(),
          zoom: 14,
        );
      }
    } else {
      // HAS ACTIVE QUEST
      if (activeQuest.quest.startMarker != null) {
        final CameraPosition _initialCameraPosition = CameraPosition(
          //In Future I will change these values to dynamically Change the Initial Camera Position
          //Based on teh city
          target: LatLng(activeQuest.quest.startMarker!.lat!,
              activeQuest.quest.startMarker!.lon!),
          zoom: 15,
        );
        return _initialCameraPosition;
      } else {
        // return current user position
        final CameraPosition _initialCameraPosition = CameraPosition(
            target: LatLng(_geolocationService.getUserPosition!.latitude,
                _geolocationService.getUserPosition!.longitude),
            zoom: 13);
        return _initialCameraPosition;
      }
    }
  }

  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker}) {
    _markersTmp.add(
      Marker(
          markerId: MarkerId(afkmarker
              .id), // google maps marker id of start marker will be our quest id
          position: LatLng(afkmarker.lat!, afkmarker.lon!),
          infoWindow: InfoWindow(snippet: quest.name),
          icon: defineMarkersColour(quest: quest, afkmarker: afkmarker),
          onTap: () async {
            // event triggered when user taps marker

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
                await displayQuestBottomSheet(
                  quest: quest,
                  startMarker: afkmarker,
                );
              } else {
                log.i("Quest active, handling qrCodeScanEvent");
                QuestQRCodeScanResult scanResult =
                    await questService.handleQrCodeScanEvent(marker: afkmarker);
                await handleQrCodeScanEvent(scanResult);
              }
            }
          }),
    );
  }

  @override
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result) async {
    if (result.isEmpty) {
      log.wtf("The object QuestQRCodeScanResult is empty!");
      return Future.value();
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
      dialogService.showDialog(
        title: "Failed to collect marker!",
        description: result.errorMessage!,
      );
    } else {
      if (!hasActiveQuest && result.quests == null) {
        await dialogService.showDialog(
            title:
                "The scanned marker is not a start of a quest. Please go to the starting point");
      }

      if (result.marker != null) {
        if (hasActiveQuest) {
          log.i("Scanned marker sucessfully collected!");
          await handleCollectMarkerEvent(afkmarker: result.marker!);
          await dialogService.showDialog(
              title: "Successfully collected marker!",
              description: getActiveQuestProgressDescription());
        }
      }
      if (result.quests != null && result.quests!.length > 0) {
        // TODO: Handle case where more than one quest is returned here!
        // For now, just start first quest!
        if (!hasActiveQuest) {
          log.i("Found quests associated to the scanned start marker.");
          await displayQuestBottomSheet(
            quest: result.quests![0],
            startMarker: result.quests![0].startMarker,
          );
        }
      }
    }
  }

  Future handleCollectMarkerEvent({required AFKMarker afkmarker}) async {
    if (hasActiveQuest == true) {
      updateMapMarkers(afkmarker: afkmarker);
      checkIfQuestFinishedAndFinishQuest();
    } else {
      dialogService.showDialog(
          title: "Quest Not Running",
          description: "Verify Your Quest Because is not running");
    }
  }

  void updateMapMarkers({required AFKMarker afkmarker}) {
    _markersTmp = _markersTmp
        .map((item) => item.markerId == MarkerId(afkmarker.id)
            ? item.copyWith(
                iconParam:
                    defineMarkersColour(afkmarker: afkmarker, quest: null))
            : item)
        .toSet();
    notifyListeners();
  }

  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest}) {
    if (hasActiveQuest) {
      final index = activeQuest.quest.markers
          .indexWhere((element) => element == afkmarker);
      if (!activeQuest.markersCollected[index]) {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      } else {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      }
    } else {
      if (quest?.type == QuestType.Hike) {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      } else if (quest?.type == QuestType.VibrationSearch) {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      } else {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      }
    }
  }

  // TODO: Move to quest service!
  void checkIfQuestFinishedAndFinishQuest() {
    if (questService.isAllMarkersCollected) {
      final _markersCollected = questService.getNumberMarkersCollected;
      log.i(
          "This is The Number of Markers Collected: ${_markersCollected.toString()}");
      checkQuestAndFinishWhenCompleted();
      //finishQuest();
    }
  }

  void onMapCreated(GoogleMapController controller) {
    if (hasActiveQuest) {
      setBusy(true);
      try {
        _googleMapController = controller;
        //Add Starter Marker
        getQuestMarkers();
      } catch (error) {
        throw MapViewModelException(
            message: 'An error occured when creating the map',
            devDetails: "Error message from Map View Model $error ",
            prettyDetails:
                "An internal error occured on our side, sorry, please try again later.");
      }
      setBusy(false);
      notifyListeners();
    } else {
      _googleMapController = controller;
    }
  }

  Future getQuestMarkers() async {
    log.i("Getting quest markers");
    setBusy(true);
    for (AFKMarker _m in activeQuest.quest.markers) {
      addMarkerToMap(quest: activeQuest.quest, afkmarker: _m);
    }
    _markersTmp = _markersTmp;
    log.v('These Are the values of the current Markers $_markersTmp');
    setBusy(false);
    notifyListeners();
  }

  void extractStartMarkersAndAddToMap() {
    if (nearbyQuests.isNotEmpty) {
      for (Quest _q in nearbyQuests) {
        log.v("Add start marker of quest with name ${_q.name} to map");
        if (_q.startMarker != null) {
          AFKMarker _m = _q.startMarker!;
          addMarkerToMap(quest: _q, afkmarker: _m);
        }
      }
      _markersTmp = _markersTmp;
    } else {
      log.i('Markers are Empty');
    }
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }
}
