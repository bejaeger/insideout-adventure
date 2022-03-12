import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_base_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

class MapOverviewViewModel extends MapBaseViewModel {
  final log = getLogger('MapViewModel');
  final _geolocationService = locator<GeolocationService>();

  //Quest? userQuest;
  final QuestService questService = locator<QuestService>();
  final _qrCodeService = locator<QRCodeService>();
  final FlavorConfigProvider flavorConfigProvider =
      locator<FlavorConfigProvider>();
  bool initialized = false;
  bool ignoreRotationGestures = false;

  GoogleMapController? _googleMapController;
  GoogleMapController? get getGoogleMapController => _googleMapController;

  // used for animating camera
  double _mapWidth = 0;
  double _mapHeight = 0;
  double _devicePixelRatio = 0;

  Set<Marker> markersOnMap = {};
  String mapStyle = "";

  Future initializeMapAndMarkers(
      {required double mapWidth,
      required double mapHeight,
      required double devicePixelRatio}) async {
    await rootBundle.loadString('assets/DayStyle.json').then(
      (string) {
        mapStyle = string;
      },
    );
    _mapWidth = mapWidth;
    _mapHeight = mapHeight;
    _devicePixelRatio = devicePixelRatio;
    if (hasActiveQuest) return;
    initialized = false;
    log.i("Initializing map view");
    setBusy(true);
    try {
      if (_geolocationService.getUserLivePositionNullable == null) {
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
        if (flavorConfigProvider.enableGPSVerification) {
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
      // await loadQuests();
      extractStartMarkersAndAddToMap();
      notifyListeners();
    } catch (e) {
      log.wtf("Error when loading quest, this should never happen. Error: $e");
      await showGenericInternalErrorDialog();
    }
    setBusy(false);
  }

  double currentBearing = 0.0;
  void rotate({
    required double dxPan,
    required double dyPan,
    required double dxGlob,
    required double dyGlob,
    required double screenWidth,
    required double screenHeight,
  }) {
    bool isLeft = dxGlob < screenWidth / 2;
    bool isRight = !isLeft;
    bool isBelowAvatar = dyGlob < (screenHeight / 2 + 100);
    bool isAboveAvatar = !isBelowAvatar;
    if (isLeft) {
      currentBearing += dyPan;
    }
    if (isRight) {
      currentBearing -= dyPan;
    }
    if (isBelowAvatar) {
      currentBearing -= dxPan;
    }
    if (isAboveAvatar) {
      currentBearing += dxPan;
    }
    getGoogleMapController!.moveCamera(
      CameraUpdate.newCameraPosition(
          getZoomedInCameraPosition(newBearing: currentBearing)),
    );
  }

  CameraPosition getZoomedInCameraPosition({double? newBearing}) {
    return CameraPosition(
      bearing: newBearing != null ? newBearing * 0.4 : currentBearing * 0.4,
      target: LatLng(_geolocationService.getUserLivePositionNullable!.latitude,
          _geolocationService.getUserLivePositionNullable!.longitude),
      zoom: 17.8,
      tilt: 90,
    );
  }

  CameraPosition getZoomedOutCameraPosition({double? newBearing}) {
    return CameraPosition(
      bearing: newBearing != null ? newBearing * 0.4 : currentBearing * 0.4,
      target: LatLng(_geolocationService.getUserLivePositionNullable!.latitude,
          _geolocationService.getUserLivePositionNullable!.longitude),
      zoom: 13,
      tilt: 90,
    );
  }

  bool zoomedIn = true;
  void changeZoom() {
    if (zoomedIn) {
      getGoogleMapController!.moveCamera(
        CameraUpdate.newCameraPosition(getZoomedOutCameraPosition()),
      );
      ignoreRotationGestures = true;
      zoomedIn = false;
    } else {
      getGoogleMapController!.moveCamera(
        CameraUpdate.newCameraPosition(getZoomedInCameraPosition()),
      );
      ignoreRotationGestures = false;
      zoomedIn = true;
    }
    notifyListeners();
  }

  @override
  CameraPosition initialCameraPosition() {
    if (!hasActiveQuest) {
      if (_geolocationService.getUserLivePositionNullable != null) {
        final CameraPosition _initialCameraPosition =
            getZoomedInCameraPosition();
        return _initialCameraPosition;
      } else {
        return CameraPosition(
          target: getDummyCoordinates(),
          tilt: 90,
          zoom: 17.5,
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
            target: LatLng(
                _geolocationService.getUserLivePositionNullable!.latitude,
                _geolocationService.getUserLivePositionNullable!.longitude),
            zoom: 13);
        return _initialCameraPosition;
      }
    }
  }

  @override
  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker}) {
    markersOnMap.add(
      Marker(
        markerId: MarkerId(afkmarker
            .id), // google maps marker id of start marker will be our quest id
        position: LatLng(afkmarker.lat!, afkmarker.lon!),
        infoWindow: InfoWindow(
            title: afkmarker == quest.startMarker ? "START HERE" : "GO HERE"),
        // InfoWindow(snippet: quest.name),
        icon: defineMarkersColour(quest: quest, afkmarker: afkmarker),
        onTap: () async {
          // event triggered when user taps marker

          if (getGoogleMapController != null) {
            // needed to avoid navigating to that marker!
            getGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(
                await getGoogleMapController!.getVisibleRegion(), 0));
          }

          dynamic adminMode = false;
          if (useSuperUserFeatures) {
            adminMode = await showAdminDialogAndGetResponse();
            if (adminMode == true) {
              String qrCodeString =
                  _qrCodeService.getQrCodeStringFromMarker(marker: afkmarker);
              navigationService.navigateTo(Routes.qRCodeView,
                  arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
            }
          }
          if (!useSuperUserFeatures || adminMode == false) {
            if (hasActiveQuest == false) {
              if (afkmarker == quest.startMarker) {
                if (getGoogleMapController != null) {
                  final screenCoordinates = await getGoogleMapController!
                      .getScreenCoordinate(
                          LatLng(afkmarker.lat!, afkmarker.lon!));
                  // some magic to move the marker to the desired position!
                  double xMove = (-_mapWidth * _devicePixelRatio / 2 +
                          screenCoordinates.x) /
                      _devicePixelRatio;
                  double yMove = (-_mapHeight * _devicePixelRatio / 2 +
                              screenCoordinates.y) /
                          _devicePixelRatio +
                      150;
                  await getGoogleMapController!
                      .animateCamera(CameraUpdate.scrollBy(xMove, yMove));
                  // await Future.delayed(Duration(milliseconds: 200));
                } else {
                  log.e(
                      "google map controller is not available, can't update position!");
                }
                await displayQuestBottomSheet(
                  quest: quest,
                  startMarker: afkmarker,
                );
              } else {
                if (quest.type != QuestType.QRCodeHike) {
                  dialogService.showDialog(
                      title: "Checkpoint",
                      description:
                          "Start the quest and reach this checkpoint.");
                } else {
                  dialogService.showDialog(
                      title: "Marker",
                      description: "Start the quest and collect this marker.");
                }
              }
            } else {
              // what happens when the user collects a marker
              log.i("Quest active, handling qrCodeScanEvent");
              if (flavorConfigProvider.allowDummyMarkerCollection) {
                MarkerAnalysisResult markerResult =
                    await activeQuestService.analyzeMarker(marker: afkmarker);
                await handleMarkerAnalysisResult(markerResult);
              }
            }
          }
          log.i("adminMode = $adminMode");
        },
      ),
    );
  }

  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) async {
    log.i("Handling marker analysis result");
    if (result.isEmpty) {
      log.wtf("The object QuestQRCodeScanResult is empty!");
      return false;
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
      // if (result.errorType != MarkerCollectionFailureType.alreadyCollected) {
      await dialogService.showDialog(
        title: "Can't collect marker!",
        description: result.errorMessage!,
      );
      // }
      return false;
    } else {
      if (!hasActiveQuest && result.quests == null) {
        await dialogService.showDialog(
            title:
                "The scanned marker is not a start of a quest. Please go to the starting point");
        return false;
      }

      // TODO: Double-check what happens here!
      if (result.marker != null) {
        return true;
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
      return false;
    }
  }

  @override
  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest}) {
    if (hasActiveQuest) {
      final index = activeQuest.quest.markers
          .indexWhere((element) => element == afkmarker);
      if (!activeQuest.markersCollected[index]) {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      } else {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      }
    } else {
      if (quest?.type == QuestType.QRCodeHike) {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      } else if (quest?.type == QuestType.TreasureLocationSearch) {
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      } else {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      }
    }
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
    } else {
      log.i('Markers are Empty');
    }
  }

  @override
  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
    _googleMapController = controller;
  }
}
