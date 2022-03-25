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
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapViewModel extends BaseModel
    with MapStateControlMixin, NavigationMixin {
  // Viewmodel that receives callback functions to update map
  // Functions declared at the bottom of this file
  MapViewModel({
    required this.moveCamera,
    required this.animateCamera,
    required this.configureAndAddMapMarker,
    required this.animateNewLatLon,
    required this.resetMapMarkers,
    required this.addARObjectToMap,
  });

  // -----------------------------------------------
  // Services
  final log = getLogger('MapViewModel');
  final QuestService questService = locator<QuestService>();
  final _qrCodeService = locator<QRCodeService>();
  final FlavorConfigProvider flavorConfigProvider =
      locator<FlavorConfigProvider>();

  // -----------------------------
  // Getters
  bool get isAvatarView => mapStateService.isAvatarView;
  bool get suppressOneFingerRotations =>
      mapStateService.suppressOneFingerRotations;
  List<Quest> get nearbyQuests => questService.getNearByQuest;

  // -------------------------------------------------
  // State variables
  StreamSubscription? _bearingListenerSubscription;
  StreamSubscription? _mapEventListenerSubscription;
  bool initialized = false;
  String mapStyle = "";

  // last element of cameraBearingZoom determines whether listener should be fired!

  Future initializeMapAndMarkers() async {
    mapStyle = await rootBundle.loadString('assets/DayStyle.json');
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

    if (_bearingListenerSubscription == null) {
      _bearingListenerSubscription = mapStateService.bearingSubject.listen(
        (bearing) {
          notifyListeners();
        },
      );
    }
    if (_mapEventListenerSubscription == null) {
      _mapEventListenerSubscription = mapStateService.mapEventListener.listen(
        (MapUpdate type) {
          log.i("Received Map Update of type $type");
          if (type == MapUpdate.forceAnimateToLocation) {
            _animateCamera(forceUseLocation: true, force: true);
          }
          if (type == MapUpdate.animate) {
            _animateCamera();
          } else if (type == MapUpdate.animateNewLatLon) {
            _animateNewLatLon();
          } else if (type == MapUpdate.restoreSnapshot) {
            // customLat/Lon in case we were in bird's view
            _animateCamera(
                forceUseLocation: true, customLat: newLat, customLon: newLon);
            mapStateService.resetNewLatLon();
          } else if (type == MapUpdate.restoreSnapshotByMoving) {
            // customLat/Lon in case we were in bird's view
            _moveCamera(
                forceUseLocation: true, customLat: newLat, customLon: newLon);
            mapStateService.resetNewLatLon();
            if (userLocation != null) {
              // needed, cause due to GoogleMap listener currentLocation
              // is overridden. This caused an unintended camera animation to one
              // of the AR objects after zooming out from the QuestDetailsOverlay
              mapStateService.setCurrentatLon(
                  lat: userLocation!.latitude, lon: userLocation!.longitude);
            }
          } else if (type == MapUpdate.addAllQuestMarkers) {
            extractStartMarkersAndAddToMap();
          } else if (type == MapUpdate.animateOnNewLocation) {
            _animateOnNewLocation();
          }
        },
      );
    }
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

  void _animateNewLatLon({bool? force = true}) {
    if (newLat != null && newLon != null) {
      animateNewLatLon(lat: newLat!, lon: newLon!, force: force);
    }
    // reset to avoid any unnecessary state
    mapStateService.resetNewLatLon();
  }

  void _animateOnNewLocation() {
    // if we are in bird view we don't want
    // to move the camera as the user is likely exploring
    // the map? This would disrupt is flow and come unnatural
    if (!isAvatarView) return;
    if (isShowingQuestDetails) return;
    // otherwise we can just animate lat lon as this
    // is the only thing that changed.
    // Also, let's not force it...otherwise, in case
    // an animation is currently running, it would be
    // disrupted
    _animateNewLatLon(force: false);
  }

  void _moveCamera({
    double? customBearing,
    double? customZoom,
    double? customTilt,
    double? customLat,
    double? customLon,
    bool? forceUseLocation,
  }) {
    if ((hasSelectedQuest && !hasActiveQuest) &&
        customLat == null &&
        customLon == null &&
        forceUseLocation != true) {
      if (selectedQuest!.startMarker != null) {
        customLat = selectedQuest!.startMarker!.lat;
        customLon = selectedQuest!.startMarker!.lon;
      }
    }
    moveCamera(
        bearing: customBearing ?? bearing,
        zoom: customZoom ?? zoom,
        tilt: customTilt ?? tilt,
        lat: customLat ?? userLocation!.latitude,
        lon: customLon ?? userLocation!.longitude);
  }

  void _animateCamera({
    double? customBearing,
    double? customZoom,
    double? customTilt,
    double? customLat,
    double? customLon,
    bool? force = true,
    bool? forceUseLocation,
  }) {
    if (hasSelectedQuest &&
        customLat == null &&
        customLon == null &&
        forceUseLocation != true) {
      if (selectedQuest!.startMarker != null) {
        customLat = selectedQuest!.startMarker!.lat;
        customLon = selectedQuest!.startMarker!.lon;
      }
    }
    animateCamera(
        bearing: customBearing ?? bearing,
        zoom: customZoom ?? zoom,
        tilt: customTilt ?? tilt,
        lat: customLat ?? userLocation!.latitude,
        lon: customLon ?? userLocation!.longitude,
        force: force);
  }

  void _animateCameraToBirdsView({bool? forceUseLocation}) {
    changeCameraTilt(0);
    changeCameraBearing(0);
    changeCameraZoom(lastBirdViewZoom ?? kInitialZoomBirdsView);
    _animateCamera(
        customLat:
            userLocation!.latitude, // + 0.005 * zoom / kInitialZoomBirdsView,
        forceUseLocation: forceUseLocation);
  }

  void _animateCameraToAvatarView({bool? forceUseLocation}) async {
    layoutService.setIsMovingCamera(true);
    takeSnapshotOfBirdViewCameraPosition();
    changeCameraTilt(90);
    changeCameraZoom(kInitialZoom);
    _animateCamera(forceUseLocation: forceUseLocation);
    await Future.delayed(Duration(seconds: 1));
    layoutService.setIsMovingCamera(false);
  }

  void changeMapZoom() {
    if (isAvatarView) {
      _animateCameraToBirdsView();
      mapStateService.setIsAvatarView(false);
    } else {
      _animateCameraToAvatarView(forceUseLocation: true);
      mapStateService.setIsAvatarView(true);
    }
    notifyListeners();
  }

  void rotateToNorth() {
    if (userLocation == null) return;
    changeCameraBearing(0);
    // _moveCamera();
    _animateCamera();
  }

  @override
  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker}) {
    configureAndAddMapMarker(
      quest: quest,
      afkmarker: afkmarker,
      onTap: () => onTapMarker(quest: quest, afkmarker: afkmarker),
    );
  }

  Future onTapMarker(
      {required Quest quest, required AFKMarker afkmarker}) async {
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
          dynamic result;
          if (!isAvatarView) {
            result = await displayQuestBottomSheet(
              quest: quest,
              startMarker: afkmarker,
            );
          }
          if (result?.confirmed == true || isAvatarView) {
            // showQuestDetails
            showQuestDetails(quest: quest);
          }
        } else {
          // information dialogs
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
        // quest is active, can we collect this marker?
        // what happens when the user collects a marker
        log.i("Quest active, handling qrCodeScanEvent");
        if (flavorConfigProvider.allowDummyMarkerCollection) {
          MarkerAnalysisResult markerResult =
              await activeQuestService.analyzeMarker(marker: afkmarker);
          await handleMarkerAnalysisResult(markerResult);
        }
      }
    }
    notifyListeners();
  }

  void showQuestDetails({required Quest quest}) {
    if (isShowingQuestDetails) return; // we already show the quest details

    // 1. set selected quest to show on screen
    activeQuestService.setSelectedQuest(quest);
    // to be able to reset camera from quest (nice UX)

    // 2. set bool to show quest to change view
    layoutService.setIsShowingQuestDetails(true);

    // 3. take snapshot so we can easily restore current view
    takeSnapshotOfCameraPosition();

    // 4. animate camera to quest start
    highlightQuestOnMap(quest: quest);

    notifyListeners();
  }

  void highlightQuestOnMap({required Quest quest}) {
    // TODO: Maybe this needs to become more advanced
    // TODO: for different types of quests

    // animate camera
    if (quest.startMarker != null) {
      changeCameraTilt(90);
      changeCameraZoom(kMaxZoom);

      _animateCamera(
          customLat: quest.startMarker!.lat,
          customLon: quest.startMarker!.lon,
          force: true);
    }
    mapStateService.setIsAvatarView(true);

    // ONLY markers relevant to quest
    if (quest.startMarker != null) {
      resetMapMarkers();
      addMarkerToMap(quest: quest, afkmarker: quest.startMarker!);
    }
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
    addARObjectToMap(
        onTap: onARObjectMarkerTap,
        lat: 49.26813866276503,
        lon: -122.98950899176373,
        isCoin: true);
    addARObjectToMap(
        onTap: onARObjectMarkerTap,
        lat: 49.26843866276503,
        lon: -122.99103899176373,
        isCoin: false);
  }

  Future onARObjectMarkerTap(double lat, double lon, bool isCoin) async {
    // TODO: These are just examples for now. Make this general

    // 2. First take snapshot
    takeSnapshotOfCameraPosition();

    // 3. is showing AR View
    layoutService.setIsShowingARView(true);

    // 4. Open AR view with nice zoom in and fade out triggered
    await openARView(lat, lon, isCoin);
  }

  Future openARView(double lat, double lon, bool isCoin) async {
    changeCameraTilt(90);
    changeCameraZoom(40); // ridiculous zoom (will be clipped)
    _animateCamera(customLat: lat, customLon: lon, force: true);
    await Future.delayed(Duration(milliseconds: 1000));
    navToArObjectView(isCoin);
  }

  void nextCharacter() {
    mapStateService.characterNumber = (characterNumber + 1) % 6;
    notifyListeners();
  }

  @override
  void dispose() {
    // cameraZoom.close();
    // cameraBearing.close();
    // cameraTilt.close();
    // TODO: implement dispose
    _mapEventListenerSubscription?.cancel();
    _mapEventListenerSubscription = null;
    _bearingListenerSubscription?.cancel();
    _bearingListenerSubscription = null;
    super.dispose();
  }

  ///////////////////////////////////////////////////////////////////
  // Map Callback functions

  final void Function({
    required double bearing,
    required double zoom,
    required double tilt,
    required double lat,
    required double lon,
  }) moveCamera;
  final void Function(
      {required double bearing,
      required double zoom,
      required double tilt,
      required double lat,
      required double lon,
      bool? force}) animateCamera;
  final void Function(
      {required Quest quest,
      required AFKMarker afkmarker,
      required Future Function() onTap}) configureAndAddMapMarker;
  final void Function({required double lat, required double lon, bool? force})
      animateNewLatLon;
  final void Function() resetMapMarkers;
  final void Function(
      {required void Function(double lat, double lon, bool isCoin) onTap,
      required double lat,
      required double lon,
      required bool isCoin}) addARObjectToMap;
}
