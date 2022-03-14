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
import 'package:afkcredits/services/maps/map_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_base_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rxdart/rxdart.dart';

class MapOverviewViewModel extends MapBaseViewModel {
  MapOverviewViewModel(
      {required this.moveCamera,
      required this.animateCameraToAvatarView,
      required this.animateCameraToBirdsView});

  // -----------------------------------------------
  // Services
  final log = getLogger('MapViewModel');
  final MapService mapService = locator<MapService>();
  final QuestService questService = locator<QuestService>();
  final _qrCodeService = locator<QRCodeService>();
  final FlavorConfigProvider flavorConfigProvider =
      locator<FlavorConfigProvider>();

  // -----------------------------
  // Getters
  Position? get userLocation => geolocationService.getUserLivePositionNullable;
  bool get isAvatarView => mapService.isAvatarView;

  // -------------------------------------------------
  // State variables
  bool initialized = false;

  GoogleMapController? mapController;

  // used for animating camera
  double _mapWidth = 0;
  double _mapHeight = 0;
  double _devicePixelRatio = 0;

  Set<Marker> markersOnMap = {};
  String mapStyle = "";

  final cameraBearingZoom =
      BehaviorSubject<List<double>>.seeded([kInitialBearing, kInitialZoom]);
  double _tilt = kInitialTilt;
  void changeCameraTilt(double tilt) {
    _tilt = tilt;
  }

  void changeCameraZoom(double zoom) {
    cameraBearingZoom.add([cameraBearingZoom.value[0], zoom]);
  }

  void changeCameraBearing(double bearing) {
    cameraBearingZoom.add([bearing, cameraBearingZoom.value[1]]);
  }

  double get getBearing => cameraBearingZoom.value[0];
  double get getZoom => cameraBearingZoom.value[1];
  double get getTilt => _tilt;

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
      if (userLocation == null) {
        await geolocationService.getAndSetCurrentLocation();
      } else {
        geolocationService.getAndSetCurrentLocation();
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

    cameraBearingZoom.listen(
      (_) {
        moveCamera(
            getBearing: getBearing,
            getZoom: getZoom,
            getTilt: getTilt,
            currentLat: userLocation!.latitude,
            currentLon: userLocation!.longitude);
      },
    );

    setBusy(false);
  }

  // void moveZoomedInCamera() {
  //   if (mapController != null) {
  //     mapController!.moveCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           bearing: getBearing,
  //           target: LatLng(
  //               userPosition!.latitude,
  //               userPosition!.longitude),
  //           zoom: getZoom,
  //           tilt: getTilt,
  //         ),
  //       ),
  //     );
  //   }
  // }

  void dontMoveCamera() async {
    mapController!.moveCamera(CameraUpdate.scrollBy(0, 0));
  }

  double previousRotation = 0;
  void rotate({
    required double dxPan,
    required double dyPan,
    required double dxGlob,
    required double dyGlob,
    required double scale,
    required double rotation,
    required double screenWidth,
    required double screenHeight,
  }) {
    bool isLeft = dxGlob < screenWidth / 2;
    bool isRight = !isLeft;
    bool isBelowAvatar = dyGlob < (screenHeight / 2 + 200);
    bool isAboveAvatar = !isBelowAvatar;
    double deltaBearing = 0;
    if (isLeft) {
      deltaBearing += dyPan;
    }
    if (isRight) {
      deltaBearing -= dyPan;
    }
    if (isBelowAvatar) {
      deltaBearing -= dxPan;
    }
    if (isAboveAvatar) {
      deltaBearing += dxPan;
    }
    double deltaRotation = previousRotation - rotation;
    if (rotation != 0.0) {
      deltaBearing = deltaRotation.clamp(-0.010, 0.010) * 200;
    }
    // moveZoomedInCamera(bearing: deltaBearing + cameraBearing.value);
    cameraBearingZoom.add(
      [
        getBearing + deltaBearing * 0.4,
        (getZoom + (scale - 1) * 0.1).clamp(17, 19)
      ],
    );
    previousRotation = rotation;
    // cameraZoom.add(cameraZoom.value * (1 + (scale - 1) * 0.5).clamp(17, 18.5));
    // mapController!.moveCamera(
    //   CameraUpdate.newCameraPosition(
    //       getZoomedInCameraPosition(newBearing: currentBearing, scale: scale)),
    // );
  }

  // final cameraBearing = BehaviorSubject<double>.seeded(0.0);
  // final cameraTilt = BehaviorSubject<double>.seeded(90);

  CameraPosition getZoomedInCameraPosition(
      {double? newBearing, double scale = 1.0}) {
    // cameraZoom.add(17.8);
    changeCameraTilt(90);
    return CameraPosition(
      bearing: getBearing,
      target: LatLng(userLocation!.latitude, userLocation!.longitude),
      // zoom: (17.8 * (1 + (scale - 1) * 0.5)).clamp(17, 18.5),
      zoom: getZoom,
      tilt: getTilt,
      //tilt: (90 * (1 + (scale - 1) * 10)).clamp(60, 90),
    );
  }

  CameraPosition getZoomedOutCameraPosition({double? newBearing}) {
    _tilt = 0;
    return CameraPosition(
      bearing: getBearing,
      target: LatLng(userLocation!.latitude - 0.005, userLocation!.longitude),
      zoom: 13,
      tilt: getTilt,
    );
  }

  void changeMapZoom() {
    if (isAvatarView) {
      changeCameraTilt(0);
      animateCameraToBirdsView(
          getBearing: getBearing,
          getZoom: getZoom,
          getTilt: getTilt,
          currentLat: userLocation!.latitude,
          currentLon: userLocation!.longitude);
      mapService.setIsAvatarView(false);
    } else {
      animateCameraToAvatarView(
          getBearing: getBearing,
          getZoom: getZoom,
          getTilt: getTilt,
          currentLat: userLocation!.latitude,
          currentLon: userLocation!.longitude);
      mapService.setIsAvatarView(true);
    }
    notifyListeners();
  }

  // @override
  // CameraPosition initialCameraPosition() {
  //   if (!hasActiveQuest) {
  //     if (userPosition != null) {
  //       final CameraPosition _initialCameraPosition =
  //           getZoomedInCameraPosition();
  //       return _initialCameraPosition;
  //     } else {
  //       log.wtf(
  //           "THIS SHOULD NOT HAPPEN: geolocation not loaded before map was opened");
  //       return CameraPosition(
  //         target: getDummyCoordinates(),
  //         tilt: 90,
  //         zoom: 17.5,
  //       );
  //     }
  //   } else {
  //     // HAS ACTIVE QUEST
  //     if (activeQuest.quest.startMarker != null) {
  //       final CameraPosition _initialCameraPosition = CameraPosition(
  //         //In Future I will change these values to dynamically Change the Initial Camera Position
  //         //Based on teh city
  //         target: LatLng(activeQuest.quest.startMarker!.lat!,
  //             activeQuest.quest.startMarker!.lon!),
  //         zoom: 15,
  //       );
  //       return _initialCameraPosition;
  //     } else {
  //       // return current user position
  //       final CameraPosition _initialCameraPosition = CameraPosition(
  //           target: LatLng(
  //               userPosition!.latitude,
  //               userPosition!.longitude),
  //           zoom: 13);
  //       return _initialCameraPosition;
  //     }
  //   }
  // }

  @override
  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker}) {
    markersOnMap.add(
      Marker(
        markerId: MarkerId(afkmarker
            .id), // google maps marker id of start marker will be our quest id
        position: LatLng(afkmarker.lat!, afkmarker.lon!),
        //infoWindow:
        //  InfoWindow(
        //     title: afkmarker == quest.startMarker ? "START HERE" : "GO HERE"),
        // InfoWindow(snippet: quest.name),
        icon: defineMarkersColour(quest: quest, afkmarker: afkmarker),
        onTap: () async {
          // event triggered when user taps marker

          if (mapController != null) {
            // needed to avoid navigating to that marker!
            // mapController!.moveCamera(CameraUpdate.newLatLngBounds(
            //     await mapController!.getVisibleRegion(), 0));
            dontMoveCamera();
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
                if (mapController != null) {
                  final screenCoordinates = await mapController!
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
                  // TODO: Moves camera to marker. Avoid for now!
                  // await mapController!
                  //     .animateCamera(CameraUpdate.scrollBy(xMove, yMove));
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
    // controller.setMapStyle(mapStyle);
    // _googleMapController = controller;
  }

  @override
  void dispose() {
    // cameraZoom.close();
    // cameraBearing.close();
    // cameraTilt.close();
    cameraBearingZoom.close();
    // TODO: implement dispose
    super.dispose();
  }

  ///////////////////////////////////////////////////////////////////
  // Map Callback functions
  final void Function(
      {required double getBearing,
      required double getZoom,
      required double getTilt,
      required double currentLat,
      required double currentLon}) moveCamera;
  final void Function(
      {required double getBearing,
      required double getZoom,
      required double getTilt,
      required double currentLat,
      required double currentLon}) animateCameraToBirdsView;
  final void Function(
      {required double getBearing,
      required double getZoom,
      required double getTilt,
      required double currentLat,
      required double currentLon}) animateCameraToAvatarView;
}
