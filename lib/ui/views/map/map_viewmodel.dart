import 'dart:async';
import 'dart:io';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/map_updates.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/active_quest_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show kIsWeb;

class MapViewModel extends BaseModel with MapStateControlMixin {
  // Viewmodel that receives callback functions to update map
  // Functions declared at the bottom of this file
  MapViewModel({
    required this.moveCamera,
    required this.animateCamera,
    required this.configureAndAddMapMarker,
    required this.configureAndAddMapArea,
    required this.animateNewLatLon,
    required this.animateNewLatLonZoomDelta,
    required this.resetMapMarkers,
    required this.resetMapAreas,
    required this.addARObjectToMap,
    required this.animateCameraToBetweenCoordinates,
    required this.fakeAnimate,
    required this.updateMapMarkers,
    required this.updateMapAreas,
    required this.showMarkerInfoWindow,
    required this.hideMarkerInfoWindow,
  });

  // -----------------------------------------------
  // Services
  final log = getLogger('MapViewModel');
  final ActiveQuestService activeQuestService = locator<ActiveQuestService>();
  final _qrCodeService = locator<QRCodeService>();
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();

  // -----------------------------
  // Getters
  bool get isAvatarView => mapStateService.isAvatarView;
  List<Quest> get nearbyQuests => questService.getNearByQuest;
  bool get isFingerOnScreen => mapStateService.isFingerOnScreen;
  DateTime startedRotating = DateTime.now();
  // bool isRotating = false;

  // -------------------------------------------------
  // State variables
  StreamSubscription? _bearingListenerSubscription;
  StreamSubscription? _mapEventListenerSubscription;
  bool initialized = false;
  String mapStyle = "";
  bool get showReloadQuestButton => questService.showReloadQuestButton;
  bool get isReloadingQuests => questService.isReloadingQuests;

  // last element of cameraBearingZoom determines whether listener should be fired!

  // TODO: This function is called for the explorer!
  Future initializeMapAndMarkers() async {
    if (!isParentAccount) {
      mapStyle = await rootBundle.loadString('assets/DayStyle.json');
    }
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
        if (appConfigProvider.enableGPSVerification) {
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

    if (_mapEventListenerSubscription == null) {
      // update map state with...
      _mapEventListenerSubscription = mapStateService.mapEventListener.listen(
        (MapUpdate type) {
          log.i("Received Map Update of type $type");
          if (type == MapUpdate.forceAnimateToLocation) {
            animateCameraViewModel(forceUseLocation: true, force: true);
          }
          if (type == MapUpdate.animate) {
            animateCameraViewModel();
          } else if (type == MapUpdate.animateNewLatLon) {
            _animateNewLatLon();
          } else if (type == MapUpdate.restoreSnapshot) {
            // customLat/Lon in case we were in bird's view
            animateCameraViewModel(
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
    if (!kIsWeb && Platform.isIOS) {
      // Somehow this is needed for iOS.
      // Otherwise map won't react at first when switching from parent
      // view to the explorer view.
      fakeAnimate();
      fakeAnimate();
    }
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
  }) async {
    setIsFingerOnScreen(true);
    startedRotating = DateTime.now();
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
    _moveCamera(questCenteredOnMap: activeQuestService.questCenteredOnMap);
    previousRotation = rotation;

    // TODO: This does not really work!
    // TODO: We want to remove the ripple effects WHILE rotating
    // TODO: This is somehow possible!
    await Future.delayed(Duration(milliseconds: 70));
    if (DateTime.now().difference(startedRotating).inMilliseconds > 65) {
      setIsFingerOnScreen(false);
    }
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

  void _moveCamera(
      {double? customBearing,
      double? customZoom,
      double? customTilt,
      double? customLat,
      double? customLon,
      bool? forceUseLocation,
      bool? questCenteredOnMap}) {
    if ((hasSelectedQuest && !hasActiveQuest) &&
        customLat == null &&
        customLon == null &&
        forceUseLocation != true &&
        questCenteredOnMap == true) {
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

  Future animateCameraViewModel({
    double? customBearing,
    double? customZoom,
    double? customTilt,
    double? customLat,
    double? customLon,
    bool? force = true,
    bool? forceUseLocation,
  }) async {
    if (hasSelectedQuest &&
        customLat == null &&
        customLon == null &&
        forceUseLocation != true) {
      if (selectedQuest!.startMarker != null) {
        customLat = selectedQuest!.startMarker!.lat;
        customLon = selectedQuest!.startMarker!.lon;
      }
    }
    await animateCamera(
        bearing: customBearing ?? bearing,
        zoom: customZoom ?? zoom,
        tilt: customTilt ?? tilt,
        lat: customLat ?? userLocation!.latitude,
        lon: customLon ?? userLocation!.longitude,
        force: force);
  }

  Future animateCameraToBirdsView({bool? forceUseLocation}) async {
    changeCameraTilt(0);
    changeCameraBearing(0);
    changeCameraZoom(lastBirdViewZoom ?? kInitialZoomBirdsView);
    await animateCameraViewModel(
        customLat:
            userLocation!.latitude, // + 0.005 * zoom / kInitialZoomBirdsView,
        forceUseLocation: forceUseLocation);
    // animations on android take 1 second
  }

  Future animateCameraToAvatarView({bool? forceUseLocation}) async {
    layoutService.setIsMovingCamera(true);
    takeSnapshotOfBirdViewCameraPosition();
    changeCameraTilt(90);
    changeCameraZoom(kInitialZoomAvatarView);
    await animateCameraViewModel(forceUseLocation: forceUseLocation);
    layoutService.setIsMovingCamera(false);
  }

  void changeMapZoom() async {
    if (isAvatarView) {
      mapStateService.setIsAvatarView(false);
      notifyListeners();
      await animateCameraToBirdsView();
    } else {
      mapStateService.setIsAvatarView(true);
      notifyListeners();
      await animateCameraToAvatarView(forceUseLocation: true);
    }
    notifyListeners();
  }

  void rotateToNorth() {
    if (userLocation == null) return;
    changeCameraBearing(0);
    // _moveCamera();
    animateCameraViewModel();
  }

  // Function called by explorer account!
  void extractStartMarkersAndAddToMap() {
    if (nearbyQuests.isNotEmpty) {
      for (Quest _q in nearbyQuests) {
        log.v("Add start marker of quest with name ${_q.name} to map");
        if (_q.startMarker != null) {
          AFKMarker _m = _q.startMarker!;
          addMarkerToMap(
              quest: _q,
              afkmarker: _m,
              isStartMarker: _m == _q.startMarker,
              completed: currentUserStats.completedQuestIds.contains(_q.id));
          hideMarkerInfoWindowNow(markerId: _m.id);
        }
      }
    } else {
      log.i('Markers are Empty');
    }
    if (!isParentAccount && appConfigProvider.isDevFlavor) {
      // if (!isParentAccount) {
      addARObjectToMap(
          onTap: onARObjectMarkerTap,
          lat: 49.27215968930406,
          lon: -123.15749607547962,
          isCoin: true);
      // addARObjectToMap(
      //     onTap: onARObjectMarkerTap,
      //     lat: 49.26843866276503,
      //     lon: -122.99103899176373,
      //     isCoin: false);
    }
  }

  void addMarkerToMap(
      {required Quest quest,
      required AFKMarker afkmarker,
      Future Function()? onMarkerTapCustom,
      Future Function(MarkerAnalysisResult)? handleMarkerAnalysisResultCustom,
      bool isStartMarker = false,
      bool completed = false}) {
    configureAndAddMapMarker(
      quest: quest,
      afkmarker: afkmarker,
      completed: completed,
      isStartMarker: isStartMarker,
      onTap: onMarkerTapCustom != null
          ? () => onMarkerTapCustom()
          : () => onMarkerTap(
                quest: quest,
                afkmarker: afkmarker,
                completed: completed,
                handleMarkerAnalysisResultCustom:
                    handleMarkerAnalysisResultCustom,
              ),
    );
  }

  void addAreaToMap({
    required Quest quest,
    required AFKMarker afkmarker,
    Future Function()? onAreaTapCustom,
    bool isStartArea = false,
  }) {
    configureAndAddMapArea(
      quest: quest,
      afkmarker: afkmarker,
      collected: activeQuestService.isMarkerCollected(marker: afkmarker),
      isStartArea: isStartArea,
      onTap: onAreaTapCustom != null
          ? () => onAreaTapCustom()
          : () => onAreaTap(
                quest: quest,
                afkmarker: afkmarker,
              ),
    );
  }

  Future onMarkerTap(
      {required Quest quest,
      required AFKMarker afkmarker,
      required bool completed,
      Future Function(MarkerAnalysisResult)?
          handleMarkerAnalysisResultCustom}) async {
    // --------------------------------------------
    // Maybe use some super user features
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

    // ---------------------------------------------
    // If quest is completed we need to check whether quest can be redone or not!
    if (completed) {
      if (quest.repeatable == 0) {
        await dialogService.showDialog(
            title: "Quest already completed!",
            description: "You cannot redo this quest.",
            buttonTitle: 'OK');
        return;
      } else {
        final result = await dialogService.showDialog(
            title: "Redo quest?",
            description: "You already completed this quest",
            cancelTitle: "NO",
            buttonTitle: 'YES');
        if (!(result?.confirmed == true)) {
          hideMarkerInfoWindowNow(markerId: afkmarker.id);
          return;
        }
      }
    }

    // ------------------------------------------------
    // normal function to be executed when marker is tapped
    if (!useSuperUserFeatures || adminMode == false) {
      if (hasActiveQuest == false) {
        // no quest active
        if (afkmarker == quest.startMarker) {
          dynamic result;
          if (!isAvatarView && selectedQuest == null) {
            // marker info window shows automatically. hide it when not in avatar view
            hideMarkerInfoWindowNow(markerId: afkmarker.id);
            result = await displayQuestBottomSheet(
              quest: quest,
              startMarker: afkmarker,
            );
          }

          // Show dialog for information
          // ? Needs to happen AFTER animateToQuestDetails is called
          if (selectedQuest != null && quest.type == QuestType.GPSAreaHike ||
              quest.type == QuestType.GPSAreaHunt) {
            // need to avoid navigating to that marker!

            // When quest is running
            if (!useSuperUserFeatures || adminMode == false) {
              if (hasActiveQuest) {
                await dialogService.showDialog(
                    title: "You started here",
                    description: "This was the beginning");
              } else {
                if (!isAvatarView && isShowingQuestDetails) {
                  await dialogService.showDialog(
                      title: "The start",
                      description:
                          "Move to this location and start the quest.");
                }
              }
            }
          }

          if (result?.confirmed == true || isAvatarView) {
            // showQuestDetails
            animateToQuestDetails(quest: quest);
          }
        } else {
          // information dialogs
          if (quest.type != QuestType.QRCodeHike) {
            showMarkerInfoWindowNow(markerId: afkmarker.id);
            await Future.delayed(Duration(milliseconds: 1500));
            hideMarkerInfoWindowNow(markerId: afkmarker.id);
            // await dialogService.showDialog(
            //     title: "Checkpoint",
            //     description: "Start the quest and reach this checkpoint.");
          } else {
            await dialogService.showDialog(
                title: "Marker",
                description: "Start the quest and collect this marker.");
          }
        }
      } else {
        // quest is active, can we collect this marker?
        // what happens when the user collects a marker
        log.i("Quest active, handling qrCodeScanEvent");
        if (appConfigProvider.allowDummyMarkerCollection) {
          MarkerAnalysisResult markerResult =
              await activeQuestService.analyzeMarker(marker: afkmarker);
          if (handleMarkerAnalysisResultCustom != null) {
            await handleMarkerAnalysisResultCustom(markerResult);
          } else {
            await handleMarkerAnalysisResult(markerResult);
          }
        }
      }
    }
    notifyListeners();
  }

  Future onAreaTap({required Quest quest, required AFKMarker afkmarker}) async {
    // event triggered when user taps marker
    dynamic adminMode = false;
    if (useSuperUserFeatures) {
      adminMode = await showAdminDialogAndGetResponse();
      if (adminMode == true) {
        String qrCodeString =
            qrCodeService.getQrCodeStringFromMarker(marker: afkmarker);
        navigationService.navigateTo(Routes.qRCodeView,
            arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
      }
    }

    if (!useSuperUserFeatures || adminMode == false) {
      if (afkmarker == quest.startMarker) {
        await dialogService.showDialog(
            title: "The start",
            description: "Move to this location and start the quest.");
      } else {
        await dialogService.showDialog(
            title: "Walk to this area to collect the checkpoint");
      }
    }
  }

  // TODO: This needs to become more advanced!
  void animateToQuestDetails({required Quest quest}) {
    if (isShowingQuestDetails) return; // we already show the quest details

    // set selected quest to show on screen
    activeQuestService.setSelectedQuest(quest);

    // take snapshot so we can easily restore current view
    takeSnapshotOfCameraPosition();

    // Show marker info
    showMarkerInfoWindowNow(markerId: quest.startMarker?.id);

    // animate camera to quest start
    animateQuestToMap(quest: quest);

    notifyListeners();
  }

  void animateQuestToMap({required Quest quest}) async {
    // ----------------------------------
    // -->> START TreasureLocationSearch Quest Section
    if (quest.type == QuestType.TreasureLocationSearch) {
      // animate camera
      if (quest.startMarker != null) {
        changeCameraTilt(90);
        changeCameraZoom(kMaxZoom);
        animateCameraViewModel(
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
      // ----------------------------------
      // <<-- END TreasureLocationSearch Quest Section

      // ----------------------------------
      // -->> START Hike Quest Section
    } else if (quest.type == QuestType.GPSAreaHike ||
        quest.type == QuestType.GPSAreaHike) {
      // ? Map animation is handled in initializer of gps_area_hike_viewmodel.dart (overlay viewmodel)
      // ? Because we need quest information there
      // ? Should I do it here instead?
      // ONLY markers relevant to quest

      // ? Cannot do the following here because we need a custom funciton for
      // ? handleMarkerAnalysisResult
      // ? All handled in gps_area_hike_viewmodel.dart

      // this is however still needed here. Not exactly clear why
      mapStateService.setIsAvatarView(false);

      // if (quest.startMarker != null) {
      //   resetMapMarkers();
      //   // add start marker & area
      //   addMarkerToMap(
      //       quest: quest,
      //       afkmarker: quest.startMarker!,
      //       isStartMarker: true,
      //       handleMarkerAnalysisResultCustom: handleMarkerAnalysisResult);
      //   addAreaToMap(
      //       quest: quest, afkmarker: quest.startMarker!, isStartArea: true);
      //   // add other potential markers and areas
      //   addMarkers(
      //       quest: quest,
      //       handleMarkerAnalysisResultCustom: handleMarkerAnalysisResult);
      //   addAreas(quest: quest);
      // }
      // notifyListeners();

      // <<-- END Hike Quest
      // ---------------------------------------------
    }
  }

  void addMarkers(
      {required Quest quest,
      Future Function(MarkerAnalysisResult)?
          handleMarkerAnalysisResultCustom}) {
    for (AFKMarker _m
        in activeQuestService.markersToShowOnMap(questIn: quest)) {
      if (_m != quest.startMarker) {
        addMarkerToMap(
            quest: quest,
            afkmarker: _m,
            handleMarkerAnalysisResultCustom: handleMarkerAnalysisResultCustom);
      }
    }
  }

  void addAreas({required Quest quest}) {
    for (AFKMarker _m
        in activeQuestService.markersToShowOnMap(questIn: quest)) {
      // don't add area if it's the start marker because that is handled separately
      if (_m != quest.startMarker) {
        addAreaToMap(quest: quest, afkmarker: _m);
      }
    }
  }

  void showMarkerInfoWindowNow({required String? markerId}) {
    showMarkerInfoWindow(markerId: markerId);
    notifyListeners();
  }

  void hideMarkerInfoWindowNow({required String? markerId}) {
    hideMarkerInfoWindow(markerId: markerId);
    notifyListeners();
  }

  void updateMapDisplay({required AFKMarker? afkmarker}) {
    if (afkmarker == null) return;
    updateMapAreas(afkmarker: afkmarker);
    updateMapMarkers(
        afkmarker: afkmarker,
        collected: activeQuest.markersCollected[activeQuest.quest.markers
            .indexWhere((element) => element == afkmarker)]);
    notifyListeners();
  }

  void checkForNewQuests({void Function()? callback}) {
    // check distance between currentLat and currentLon of map and
    // lat and lon where quests were previously downloaded
    // TODO: Maybe put in quest_service
    double distance = geolocationService.distanceBetween(
        lat1: mapStateService.currentLat,
        lon1: mapStateService.currentLon,
        lat2: questService.latAtLatestQuestDownload,
        lon2: questService.lonAtLatestQuestDownload);
    if (distance / 1000 > kDefaultQuestDownloadRadiusInKm) {
      if (!showReloadQuestButton) {
        log.v("Moved camera far enough to promt loading new quests");
        notifyListeners();
        if (callback != null) {
          callback();
        }
      }
      // show button to download new quests within a radius of new lat lon!
      questService.showReloadQuestButton = true;
    } else {
      if (showReloadQuestButton) {
        log.v("Moved camera back so don't show promt to load new quests");
        notifyListeners();
        if (callback != null) {
          callback();
        }
      }
      questService.showReloadQuestButton = false;
    }
  }

  void setIsFingerOnScreen(bool set) async {
    mapStateService.isFingerOnScreenSubject.add(set);
  }

  // TODO: This should be specified via the specific quest viewmodels!
  // TODO: At the moment only done for gps_area_hike.
  // TODO: Might also only be needed to activate cheat feature!
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

  void resetAndAddBackAllMapMarkersAndAreas() {
    resetMapMarkers();
    resetMapAreas();
    extractStartMarkersAndAddToMap();
    notifyListeners();
  }

  void resetAllMapMarkersAndAreas() {
    resetMapMarkers();
    resetMapAreas();
  }

  Future changeSettingsForNewView(double? lat, double? lon) async {
    // 1. First take snapshot
    takeSnapshotOfCameraPosition();

    // 2. set is fading out to show black fade out when AR marker is tapped
    layoutService.setIsFadingOutOverlay(true);

    changeCameraTilt(90);
    changeCameraZoom(40); // ridiculous zoom (will be clipped)
    if (lat != null && lon != null) {
      animateCameraViewModel(customLat: lat, customLon: lon, force: true);
    }
    await Future.delayed(Duration(milliseconds: 800));
  }

  Future onARObjectMarkerTap(double lat, double lon, bool isCoin) async {
    await changeSettingsForNewView(lat, lon);
    if (appConfigProvider.isARAvailable) {
      return await openARView(lat, lon, isCoin);
    } else {
      await showCollectedMarkerDialog();
      layoutService.setIsFadingOutOverlay(false);
      restorePreviousCameraPosition(moveInsteadOfAnimate: true);
      await Future.delayed(Duration(milliseconds: 200));
      layoutService.setIsFadingOutOverlay(false);
      return true;
    }
  }

  void clearAllMapData() {
    resetAllMapMarkersAndAreas();
    resetSnapshotOfCameraPosition();
    // change avatar view back to default
    mapStateService.setIsAvatarView(true);
  }

  Future openARView(double lat, double lon, bool isCoin) async {
    dynamic res = await navToArObjectView(isCoin);
    return res is bool && res == true;
  }

  void nextCharacter() {
    mapStateService.characterNumber = (characterNumber + 1) % 4;
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
  final Future Function(
      {required double bearing,
      required double zoom,
      required double tilt,
      required double lat,
      required double lon,
      bool? force}) animateCamera;
  final void Function(
      {required Quest quest,
      required AFKMarker afkmarker,
      required Future Function() onTap,
      bool isStartMarker,
      bool completed}) configureAndAddMapMarker;
  final void Function(
      {required Quest quest,
      required AFKMarker afkmarker,
      required Future Function() onTap,
      bool isStartArea,
      bool collected}) configureAndAddMapArea;
  final Future Function({required double lat, required double lon, bool? force})
      animateNewLatLon;
  final Future Function(
      {required List<List<double>> latLngList,
      double? padding}) animateCameraToBetweenCoordinates;
  final void Function() fakeAnimate;
  final void Function() resetMapMarkers;
  final void Function() resetMapAreas;
  final void Function(
      {required void Function(double lat, double lon, bool isCoin) onTap,
      required double lat,
      required double lon,
      required bool isCoin}) addARObjectToMap;
  final void Function({required AFKMarker afkmarker, required bool collected})
      updateMapMarkers;
  final void Function({required AFKMarker afkmarker}) updateMapAreas;
  final Future Function(
      {required double lat,
      required double lon,
      required double deltaZoom,
      bool? force}) animateNewLatLonZoomDelta;
  final void Function({required String? markerId}) showMarkerInfoWindow;
  final void Function({required String? markerId}) hideMarkerInfoWindow;
}
