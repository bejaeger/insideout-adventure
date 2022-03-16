import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/map_updates.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_base_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapViewModel extends MapBaseViewModel {
  // Viewmodel that receives callback functions to update map
  // Functions declared at the bottom of this file
  MapViewModel(
      {required this.moveCamera,
      required this.animateCamera,
      required this.configureAndAddMapMarker,
      required this.animateNewLatLon});

  // -----------------------------------------------
  // Services
  final log = getLogger('MapViewModel');
  final QuestService questService = locator<QuestService>();
  final _qrCodeService = locator<QRCodeService>();
  final FlavorConfigProvider flavorConfigProvider =
      locator<FlavorConfigProvider>();

  // -----------------------------
  // Getters
  Position? get userLocation => geolocationService.getUserLivePositionNullable;
  bool get isAvatarView => mapStateService.isAvatarView;

  // -------------------------------------------------
  // State variables
  bool initialized = false;
  String mapStyle = "";

  // last element of cameraBearingZoom determines whether listener should be fired!

  Future initializeMapAndMarkers(
      {required double mapWidth,
      required double mapHeight,
      required double devicePixelRatio}) async {
    await rootBundle.loadString('assets/DayStyle.json').then(
      (string) {
        mapStyle = string;
      },
    );
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

    mapStateService.bearingSubject.listen(
      (bearing) {
        notifyListeners();
      },
    );
    mapStateService.mapEventListener.listen(
      (MapUpdate type) {
        log.wtf("Received Map Update of type $type");
        if (type == MapUpdate.animate) {
          _animateCamera();
        } else if (type == MapUpdate.animateNewLatLon) {
          _animateNewLatLon;
        }
      },
    );
    setBusy(false);
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
    changeCameraBearing(bearing + deltaBearing * 0.4);
    changeCameraZoom(
        (zoom + (scale - 1) * 0.08).clamp(kMinZoomAvatarView, kMaxZoom));
    _moveCamera();
    previousRotation = rotation;
  }

  void _animateNewLatLon() {
    if (newLat != null && newLon != null) {
      animateNewLatLon(lat: newLat!, lon: newLon!);
    }
    // reset to avoid any unnecessary state
    mapStateService.resetNewLatLon();
  }

  void _moveCamera(
      {double? customBearing,
      double? customZoom,
      double? customTilt,
      double? customLat,
      double? customLon}) {
    moveCamera(
        bearing: customBearing ?? bearing,
        zoom: customZoom ?? zoom,
        tilt: customTilt ?? tilt,
        lat: customLat ?? userLocation!.latitude,
        lon: customLon ?? userLocation!.longitude);
  }

  void _animateCamera(
      {double? customBearing,
      double? customZoom,
      double? customTilt,
      double? customLat,
      double? customLon}) {
    animateCamera(
        bearing: customBearing ?? bearing,
        zoom: customZoom ?? zoom,
        tilt: customTilt ?? tilt,
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
      mapStateService.setIsAvatarView(false);
    } else {
      _animateCameraToAvatarView();
      mapStateService.setIsAvatarView(true);
    }
    notifyListeners();
  }

  final LayoutService layoutService = locator<LayoutService>();
  bool get isShowingQuestDetails => layoutService.isShowingQuestDetails;
  void switchIsShowingQuestDetails() {
    layoutService.switchIsShowingQuestDetails();
    notifyListeners();
  }

  void showQuestDetails({required Quest quest}) {
    // to be able to reset camera from quest (nice UX)
    takeSnapshotOfCameraPosition();

    if (quest.startMarker != null) {
      if (!isAvatarView) {
        changeCameraTilt(90);
      }
      changeCameraZoom(kMaxZoom);
      _animateCamera(
          customLat: quest.startMarker!.lat, customLon: quest.startMarker!.lon);
    }
    switchIsShowingQuestDetails();
  }

  void takeSnapshotOfCameraPosition() {
    mapStateService.previousBearing = bearing;
    mapStateService.previousZoom = zoom;
    mapStateService.previousTilt = tilt;
  }

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
              final result = await displayQuestBottomSheet(
                quest: quest,
                startMarker: afkmarker,
              );
              if (result?.confirmed == true) {
                // showQuestDetails
                showQuestDetails(quest: quest);
              }
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
    // TODO: implement dispose
    super.dispose();
  }

  ///////////////////////////////////////////////////////////////////
  // Map Callback functions
  final void Function(
      {required double bearing,
      required double zoom,
      required double tilt,
      required double lat,
      required double lon}) moveCamera;
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
  final void Function({
    required double lat,
    required double lon,
  }) animateNewLatLon;
}
