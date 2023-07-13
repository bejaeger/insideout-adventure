import 'dart:async';
import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/map_updates.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/services/quests/active_quest_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:afkcredits/utils/utilities.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:insideout_ui/insideout_ui.dart';

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
  final log = getLogger('MapViewModel');
  final ActiveQuestService activeQuestService = locator<ActiveQuestService>();
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();

  bool get isAvatarView => mapStateService.isAvatarView;
  List<Quest> get nearbyQuests => questService.getNearByQuest;
  bool get isFingerOnScreen => mapStateService.isFingerOnScreen;
  bool get showAvatarAndMapEffects => userService.isShowAvatarAndMapEffects;
  bool get showReloadQuestButton => questService.showReloadQuestButton;
  bool get isReloadingQuests => questService.isReloadingQuests;

  StreamSubscription? _bearingListenerSubscription;
  StreamSubscription? _mapEventListenerSubscription;
  bool initialized = false;
  String mapStyle = "";
  DateTime startedRotating = DateTime.now();

  // TODO: This function is only called for the ward!
  Future initializeMapAndMarkers() async {
    if (!isGuardianAccount) {
      mapStyle = await rootBundle.loadString(kMapStylePath);
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
      } else {
        await showGenericInternalErrorDialog();
      }
    }
    try {
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
          } else if (type == MapUpdate.notify) {
            notifyListeners();
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
      // Otherwise map won't react at first when switching from guardian
      // view to the ward view.
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

    await Future.delayed(Duration(milliseconds: 160));
    if (DateTime.now().difference(startedRotating).inMilliseconds > 150) {
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
    layoutService.setIsMovingCamera(true);
    changeCameraTilt(0);
    changeCameraBearing(0);
    changeCameraZoom(lastBirdViewZoom ?? kInitialZoomBirdsView);
    await animateCameraViewModel(
        customLat:
            userLocation!.latitude, // + 0.005 * zoom / kInitialZoomBirdsView,
        forceUseLocation: forceUseLocation);
    // animations on android take 1 second
    layoutService.setIsMovingCamera(false);
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

  // Function called by ward account!
  void extractStartMarkersAndAddToMap() {
    bool showCompletedQuests =
        userService.currentUserSettings.isShowingCompletedQuests;
    if (nearbyQuests.isNotEmpty) {
      for (Quest _q in nearbyQuests) {
        bool completed = userService.hasCompletedQuest(questId: _q.id);
        if (completed &&
            !showCompletedQuests &&
            _q.type == QuestType.TreasureLocationSearch) {
          continue;
        }
        if (_q.startMarker != null) {
          AFKMarker _m = _q.startMarker!;
          addMarkerToMap(
            quest: _q,
            afkmarker: _m,
            isStartMarker: _m == _q.startMarker,
            completed: completed,
          );
          hideMarkerInfoWindowNow(markerId: _m.id);
        }
      }
    } else {
      log.i('Markers are Empty');
    }
    if (!isGuardianAccount && appConfigProvider.isDevFlavor) {
      addARObjectToMap(
          onTap: onARObjectMarkerTap,
          lat: 49.27215968930406,
          lon: -123.15749607547962,
          isGreen: true);
    }
  }

  void addMarkerToMap({
    required Quest quest,
    required AFKMarker afkmarker,
    Future Function()? onMarkerTapCustom,
    Future Function(MarkerAnalysisResult)? handleMarkerAnalysisResultCustom,
    bool isStartMarker = false,
    bool completed = false,
    String? infoWindowText,
    bool isGuardianAccount = false,
  }) {
    configureAndAddMapMarker(
      quest: quest,
      afkmarker: afkmarker,
      completed: completed,
      isStartMarker: isStartMarker,
      infoWindowText: infoWindowText,
      isGuardianAccount: isGuardianAccount,
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
    if (hasActiveQuest == false) {
      if (afkmarker == quest.startMarker) {
        dynamic result;
        if (!isAvatarView && selectedQuest == null) {
          // marker info window shows automatically (google map). hide it when not in avatar view
          hideMarkerInfoWindowNow(markerId: afkmarker.id);
          result = await displayQuestBottomSheet(
            quest: quest,
            completed: completed,
            startMarker: afkmarker,
          );
        }
        // When we select the quest from the bottom sheet OR are in avatar view
        // we smoothly animate to the quest
        if (result?.confirmed == true || isAvatarView) {
          animateToQuestDetails(quest: quest);
        }
      } else {
        if (quest.type != QuestType.QRCodeHike) {
          showMarkerInfoWindowNow(markerId: afkmarker.id);
          await Future.delayed(Duration(milliseconds: 1500));
          hideMarkerInfoWindowNow(markerId: afkmarker.id);
        } else {
          await dialogService.showDialog(
              title: "Checkpoint",
              description: "Start the quest and collect this checkpoint.");
        }
      }
    } else {
      if (useSuperUserFeatures) {
        // ! DEVELOPMENT FEATURE ONLY!
        // ! ALLOW testing quests by pressing on markers on map!
        log.i("Quest active, handling qrCodeScanEvent");
        if (appConfigProvider.allowDummyMarkerCollection) {
          MarkerAnalysisResult markerResult = await activeQuestService
              .analyzeMarkerAndUpdateQuest(marker: afkmarker);
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
    if (!useSuperUserFeatures) {
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

  void animateToQuestDetails({required Quest quest}) async {
    if (isShowingQuestDetails) {
      log.w(
          "for some reason we already show the quest details. Should not happen");
      return;
    }

    takeSnapshotOfCameraPosition();

    activeQuestService.setSelectedQuest(quest);
    // for rotation animation in avatar view
    activeQuestService.questCenteredOnMap = true;

    animateMapToQuestLocation(quest: quest);
  }

  void animateMapToQuestLocation({required Quest quest}) async {
    if (isGuardianAccount) {
      animateMapToQuestGuardianAccount(quest: quest);
    } else {
      animateMapToQuestWardAccount(quest: quest);
    }
  }

  void animateMapToQuestGuardianAccount({required Quest quest}) async {
    log.v("Animating map to quest markers in guardian account");
    resetMapMarkers();
    addAllMarkersNumbered(quest: quest);
    animateCameraToBetweenQuestMarkers(quest: quest);
    await Future.delayed(
        Duration(milliseconds: (800 * mapAnimationSpeedFraction()).round()));
    showMarkerInfoWindowNumbers(quest: quest);
  }

  void animateMapToQuestWardAccount({required Quest quest}) async {
    showMarkerInfoWindowNow(markerId: quest.startMarker?.id);

    layoutService.setIsMovingCamera(true);

    if (quest.type == QuestType.TreasureLocationSearch) {
      if (quest.startMarker != null) {
        changeCameraTilt(90);
        changeCameraZoom(kMaxZoom);
        mapStateService.setIsAvatarView(true);
        animateCameraViewModel(
            customLat: quest.startMarker!.lat,
            customLon: quest.startMarker!.lon,
            force: true);
      }
      mapStateService.setIsAvatarView(true);

      if (quest.startMarker != null) {
        resetMapMarkers();
        addMarkerToMap(quest: quest, afkmarker: quest.startMarker!);
      }
    } else if (quest.type == QuestType.GPSAreaHike ||
        quest.type == QuestType.GPSAreaHike) {
      // ? Map animation is handled in initializer of gps_area_hike_viewmodel.dart (overlay viewmodel)
      // ? Because we need quest information there

      // this is however still needed here. Not exactly clear why
      // need this slight delay for better navigation.
      await Future.delayed(Duration(milliseconds: 300));
      mapStateService.setIsAvatarView(false);
      changeCameraTilt(0);
      notifyListeners();

      // ? Cannot add the markers here because we need a custom function for
      // ? handleMarkerAnalysisResult
      // ? All handled in gps_area_hike_viewmodel.dart

    }
    Future.delayed(
        Duration(seconds: 1), () => layoutService.setIsMovingCamera(false));
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

  void addAllMarkersNumbered({required Quest quest}) async {
    int counter = 0;
    for (AFKMarker m in quest.markers) {
      counter += 1;
      addMarkerToMap(
        quest: quest,
        afkmarker: m,
        isStartMarker: m == quest.startMarker,
        infoWindowText: m == quest.startMarker
            ? "Start"
            : counter == quest.markers.length
                ? "Finish"
                : "Checkpoint $counter",
      );
    }
  }

  void showMarkerInfoWindowNumbers({required Quest quest}) async {
    // Wait to first show markers on map after notifyListeners() has been
    // called in the relevant viewmodel (e.g. guardian_home_viewmodel)
    for (AFKMarker m in quest.markers) {
      showMarkerInfoWindow(markerId: m.id);
      await Future.delayed(Duration(milliseconds: 1000));
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

  void animateCameraToBetweenQuestMarkers({required Quest quest}) {
    List<List<double>> latLngListToAnimate =
        quest.markers.map((m) => [m.lat!, m.lon!]).toList();
    // add ghost latLong positions (in-place) to avoid  zooming
    // too far if only two positions very close by are shown!
    // TODO: Could add more ghost markers this cause sometimes the zoom is too much
    // TODO:  e.g. if line between markers is parallel to the north-south direction
    potentiallyAddGhostLatLng(latLngList: latLngListToAnimate);

    Future.delayed(
      Duration(milliseconds: 0),
      () => animateCameraToBetweenCoordinates(latLngList: latLngListToAnimate),
    );
  }

  // Same function as above but takes latLngList instead of quest
  void animateCameraToBetweenCoordinatesWithPadding(
      {required List<List<double>> latLngList}) {
    potentiallyAddGhostLatLng(latLngList: latLngList);
    Future.delayed(
      Duration(milliseconds: 0),
      () => animateCameraToBetweenCoordinates(latLngList: latLngList),
    );
  }

  void potentiallyAddGhostLatLng({required List<List<double>> latLngList}) {
    latLngList.add(geolocationService.getLatLngShiftedLatInList(
        latLng: latLngList[0], offset: 150));
    latLngList.add(geolocationService.getLatLngShiftedLatInList(
        latLng: latLngList[0], offset: -150));
    latLngList.add(geolocationService.getLatLngShiftedLonInList(
        latLng: latLngList[0], offset: 80));
    latLngList.add(geolocationService.getLatLngShiftedLonInList(
        latLng: latLngList[0], offset: -80));
  }

  void updateMapDisplayAllCollectedMarkersInQuest() {
    updateMapDisplay(afkmarker: activeQuest.quest.startMarker);
    for (AFKMarker m in activeQuest.quest.markers) {
      if (activeQuestService.isMarkerCollected(marker: m)) {
        updateMapDisplay(afkmarker: m);
      }
    }
  }

  void updateMapDisplay({required AFKMarker? afkmarker}) {
    if (afkmarker == null) {
      return;
    }
    updateMapAreas(afkmarker: afkmarker);
    updateMapMarkers(
      afkmarker: afkmarker,
      collected: activeQuestService.isMarkerCollected(marker: afkmarker),
    );
    notifyListeners();
  }

  void checkForNewQuests({void Function()? callback}) {
    // check distance between currentLat and currentLon of map and
    // lat and lon where quests were previously downloaded
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
      log.e("The object QuestQRCodeScanResult is empty!");
      return false;
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
      await dialogService.showDialog(
        title: "Can't find checkpoint!",
        description: result.errorMessage!,
      );
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

  Future fadeOutAndZoomCamera(double? lat, double? lon) async {
    mapStateService.takeBeforeARSnapshotOfCameraPosition();
    layoutService.setIsFadingOutOverlay(true);
    changeCameraTilt(90);
    changeCameraZoom(40); // zoom in while fading out for UI effect
    if (lat != null && lon != null) {
      animateCameraViewModel(customLat: lat, customLon: lon, force: true);
    }
    await Future.delayed(Duration(milliseconds: 800));
  }

  Future onARObjectMarkerTap(double lat, double lon, bool isCoin) async {
    // This triggers an fade out animation and save the current camera position
    await fadeOutAndZoomCamera(lat, lon);
    if (appConfigProvider.isARAvailable) {
      return await openARView(isCoin);
    } else {
      await showCollectedMarkerDialog();
      mapStateService.restoreBeforeArCameraPositionAndAnimate(
          moveInsteadOfAnimate: true);
      await Future.delayed(Duration(milliseconds: 200));
      layoutService.setIsFadingOutOverlay(false);
      return true;
    }
  }

  void clearAllMapData() {
    resetAllMapMarkersAndAreas();
    resetSnapshotOfCameraPosition();
    mapStateService.setIsAvatarView(true);
  }

  Future openARView(bool isCoin) async {
    dynamic res = await navToArObjectView(isCoin);
    return res is bool && res == true;
  }

  @override
  void dispose() {
    _mapEventListenerSubscription?.cancel();
    _mapEventListenerSubscription = null;
    _bearingListenerSubscription?.cancel();
    _bearingListenerSubscription = null;
    super.dispose();
  }

  // Declaration of map callback functions

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
  final void Function({
    required Quest quest,
    required AFKMarker afkmarker,
    required Future Function() onTap,
    bool isStartMarker,
    bool completed,
    String? infoWindowText,
    bool isGuardianAccount,
  }) configureAndAddMapMarker;
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
      {required void Function(double lat, double lon, bool isGreen) onTap,
      required double lat,
      required double lon,
      required bool isGreen}) addARObjectToMap;
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
