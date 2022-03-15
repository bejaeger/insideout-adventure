import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/maps/map_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rxdart/rxdart.dart';

class MapViewModel extends QuestViewModel {
  MapViewModel(
      {required this.moveCamera,
      required this.animateCamera,
      required this.configureAndAddMapMarker});

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

  // used for animating camera when pressing on quest marker
  // double _mapWidth = 0;
  // double _mapHeight = 0;
  // double _devicePixelRatio = 0;

  String mapStyle = "";

  // last element of cameraBearingZoom determines whether listener should be fired!

  final bearingSubject = BehaviorSubject<double>.seeded(kInitialBearing);
  double get bearing => bearingSubject.value;
  double tilt = kInitialTilt;
  void changeCameraTilt(double tiltIn) {
    tilt = tiltIn;
  }

  double zoom = kInitialZoom;
  void changeCameraZoom(double zoomIn) {
    zoom = zoomIn;
  }

  void changeCameraBearing(double bearingIn) {
    bearingSubject.add(bearingIn);
  }

  Future initializeMapAndMarkers(
      {required double mapWidth,
      required double mapHeight,
      required double devicePixelRatio}) async {
    await rootBundle.loadString('assets/DayStyle.json').then(
      (string) {
        mapStyle = string;
      },
    );
    // _mapWidth = mapWidth;
    // _mapHeight = mapHeight;
    // _devicePixelRatio = devicePixelRatio;
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

    bearingSubject.listen(
      (bearing) {
        notifyListeners();
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
    changeCameraBearing(bearing + deltaBearing * 0.4);
    changeCameraZoom((zoom + (scale - 1) * 0.08).clamp(17, 19));
    _moveCamera();
    previousRotation = rotation;
  }

  void _moveCamera() {
    moveCamera(
        getBearing: bearing,
        getZoom: zoom,
        getTilt: tilt,
        currentLat: userLocation!.latitude,
        currentLon: userLocation!.longitude);
  }

  void _animateCamera({double? customLat, double? customLon}) {
    animateCamera(
        bearing: bearing,
        zoom: zoom,
        tilt: tilt,
        lat: customLat ?? userLocation!.latitude,
        lon: customLon ?? userLocation!.longitude);
  }

  void _animateCameraToBirdsView() {
    changeCameraTilt(0);
    changeCameraZoom(13);
    _animateCamera(customLat: userLocation!.latitude + 0.005);
  }

  void _animateCameraToAvatarView() {
    changeCameraTilt(90);
    changeCameraZoom(kInitialZoom);
    _animateCamera();
  }

  void changeMapZoom() {
    if (isAvatarView) {
      _animateCameraToBirdsView();
      mapService.setIsAvatarView(false);
    } else {
      _animateCameraToAvatarView();
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
    configureAndAddMapMarker(
      quest: quest,
      afkmarker: afkmarker,
      onTap: () async {
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
              // if (mapController != null) {
              //   final screenCoordinates = await mapController!
              //       .getScreenCoordinate(
              //           LatLng(afkmarker.lat!, afkmarker.lon!));
              //   // some magic to move the marker to the desired position!
              //   double xMove =
              //       (-_mapWidth * _devicePixelRatio / 2 + screenCoordinates.x) /
              //           _devicePixelRatio;
              //   double yMove = (-_mapHeight * _devicePixelRatio / 2 +
              //               screenCoordinates.y) /
              //           _devicePixelRatio +
              //       150;
              //   // TODO: Moves camera to marker. Avoid for now!
              //   // await mapController!
              //   //     .animateCamera(CameraUpdate.scrollBy(xMove, yMove));
              //   // await Future.delayed(Duration(milliseconds: 200));
              // } else {
              //   log.e(
              //       "google map controller is not available, can't update position!");
              // }
              await displayQuestBottomSheet(
                quest: quest,
                startMarker: afkmarker,
              );
            } else {
              if (quest.type != QuestType.QRCodeHike) {
                dialogService.showDialog(
                    title: "Checkpoint",
                    description: "Start the quest and reach this checkpoint.");
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
    );
    notifyListeners();
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

  // @override
  // BitmapDescriptor defineMarkersColour(
  //     {required AFKMarker afkmarker, required Quest? quest}) {
  //   return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  // }
  //   if (hasActiveQuest) {
  //     final index = activeQuest.quest.markers
  //         .indexWhere((element) => element == afkmarker);
  //     if (!activeQuest.markersCollected[index]) {
  //       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  //     } else {
  //       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  //     }
  //   } else {
  //     if (quest?.type == QuestType.QRCodeHike) {
  //       return BitmapDescriptor.defaultMarkerWithHue(
  //           BitmapDescriptor.hueOrange);
  //     } else if (quest?.type == QuestType.TreasureLocationSearch) {
  //       return BitmapDescriptor.defaultMarkerWithHue(
  //           BitmapDescriptor.hueViolet);
  //     } else {
  //       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  //     }
  //   }
  // }

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

  void rotateToNorth() {
    if (userLocation == null) return;
    changeCameraBearing(0);
    _moveCamera();
  }

  @override
  void dispose() {
    // cameraZoom.close();
    // cameraBearing.close();
    // cameraTilt.close();
    bearingSubject.close();
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
      {required double bearing,
      required double zoom,
      required double tilt,
      required double lat,
      required double lon}) animateCamera;
  final void Function(
      {required Quest quest,
      required AFKMarker afkmarker,
      required Future Function() onTap}) configureAndAddMapMarker;
}
