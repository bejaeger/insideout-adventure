import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/app_strings.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/super_user_dialog_type.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/active_quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_settings/open_settings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';

abstract class ActiveQuestBaseViewModel extends BaseModel
    with MapStateControlMixin {
  // ---------------------------------------------------------
  // Services
  final MapStateService mapsService = locator<MapStateService>();
  final QuestTestingService questTestingService =
      locator<QuestTestingService>();
  final AppConfigProvider flavorConfigProvider = locator<AppConfigProvider>();
  final ActiveQuestService activeQuestService = locator<ActiveQuestService>();
  final MapViewModel mapViewModel = locator<MapViewModel>();

  final log = getLogger("ActiveQuestBaseViewModel");

  // ----------------------------------------------------------
  // getters
  bool get isDevFlavor => flavorConfigProvider.flavor == Flavor.dev;
  bool get isNearStartMarker => !flavorConfigProvider.enableGPSVerification
      ? true
      : (geolocationService.distanceToStartMarker > 0) &&
          (geolocationService.distanceToStartMarker <
              kMaxDistanceFromMarkerInMeter);
  Quest? get currentQuest => activeQuestService.currentQuest;
  // timeElapsed is a reactive value
  String get timeElapsed => activeQuestService.getMinutesElapsedString();
  double get distanceToStartMarker => geolocationService.distanceToStartMarker;
  bool get isCalculatingDistanceToStartMarker => distanceToStartMarker < 0;
  // -----------------------------------------------------------
  // UI state
  bool showCollectedMarkerAnimation = false;
  // bool showStartSwipe = true;
  bool get showStartSwipe => !activeQuestService.hasActiveQuest;

  bool questSuccessfullyFinished = false;
  bool questFinished = false;

  bool get questCenteredOnMap => activeQuestService.questCenteredOnMap;

  // TODO: maybe deprecated
  String lastActivatedQuestInfoText = "Active Quest";

  // ------------------------------------------
  // Functions to override!
  bool isQuestCompleted();

  //  {
  //   return false;
  // }
  // void updateMapMarkers({required AFKMarker afkmarker}) {}

  ///------------------------------------------------------------
  /// Main Functions
  /// -----------------------------------------------------------
  @mustCallSuper
  Future initialize({required Quest quest}) async {
    // sets current quest in service so it is accessible anywhere
    activeQuestService.currentQuest = quest;

    // set distance to marker immediately if location was checked within the last 30 seconds.
    maybeSetDistanceToStartMarker(quest: quest);

    // start calibration listener to get accurate position
    // this also sets the distance to the start marker
    startPositionCalibrationListener(quest: quest);
  }

  // Main function always called when quest is started
  Future startQuestMain(
      {required Quest quest,
      Future Function(int)? periodicFuncFromViewModel,
      bool countStartMarkerAsCollected = false}) async {
    // cancel listener that was only used for calibration
    cancelPositionListener();

    // TODO: this might not be needed
    // if (await checkIfBatterySaveModeOn()) {
    //   resetSlider();
    //   return false;
    // }

    // TODO: This might be deprecated as we changed business/app model
    if (!hasEnoughSponsoring(quest: quest)) {
      return false;
    }

    try {
      // if (quest.type == QuestType.VibrationSearch && startFromMap) {
      //   await navigateToVibrationSearchView();
      // }
      questTestingService.maybeInitialize(user: currentUser);

      /// Once The user Click on Start a Quest. It is her/him to new Page
      /// Differents Markers will Display as Part of the quest as well The App showing the counting of the
      /// Quest.
      final isQuestStarted = await activeQuestService.startQuest(
          quest: quest,
          uids: [currentUser.uid],
          periodicFuncFromViewModel: periodicFuncFromViewModel,
          countStartMarkerAsCollected: countStartMarkerAsCollected);

      // this will also change the MapViewModel to show the ActiveQuestView
      if (isQuestStarted is String) {
        await dialogService.showDialog(
            title: "You cannot start the quest", description: isQuestStarted);
        resetSlider();
        return false;
      }

      // Quest is succesfully started so hasActiveQuest == true

      // selected quest is reset...hopefully I'm not accessing it in the active quest
      // by resetting the UI will react and now knows that an active quest is present, not only a "selected" quest
      activeQuestService.resetSelectedQuest();

      // ? needed for TreasureLocationSearch
      if (currentQuest?.type == QuestType.TreasureLocationSearch) {
        changeCameraZoom(kInitialZoomAvatarView);
        animateMap(forceUseLocation: true);
      }
      return true;
    } catch (e) {
      log.e("Could not start quest, error thrown: $e");
      rethrow;
    }
  }

  // function called to cancel quest OR when quest is finished
  // but markers weren't collected yet.
  Future cancelOrFinishQuest(
      {bool force = false, bool showDialog = true}) async {
    if (!hasActiveQuest) {
      log.wtf("No active quest present to cancel");
      return;
    }
    if (activeQuest.status != QuestStatus.success) {
      DialogResponse<dynamic>? continueQuest;
      if (!force) {
        log.w("Quest is incomplete, show dialog");
        continueQuest = await dialogService.showConfirmationDialog(
            title: WarningQuestNotFinished,
            cancelTitle: "CANCEL QUEST",
            confirmationTitle: "CONTINUE QUEST");
      } else {
        log.w("You are forcing to end the quest");
      }

      if (continueQuest?.confirmed == true) {
        await activeQuestService.continueIncompleteQuest();
      }
      if (continueQuest?.confirmed == false || force) {
        // TODO: Handle quest testing service if some positions aren't pushed yet!
        if (questTestingService.isRecordingLocationData &&
            !questTestingService.isAllQuestDataPointsPushed()) {
          log.i("push to notion");
          await dialogService.showCustomDialog(
              variant: DialogType.SuperUserSettings,
              data: SuperUserDialogType.sendDiagnostics);
        }
        // TODO: temporary thing
        bool standaloneUI = activeQuest.quest.type == QuestType.GPSAreaHike ||
            activeQuest.quest.type == QuestType.GPSAreaHunt;

        // will reset activeQuest
        await activeQuestService.cancelIncompleteQuest();

        resetPreviousQuest();
        // TODO: Make these settings more in line!
        if (standaloneUI) {
          replaceWithExplorerHomeView();
          layoutService.setIsFadingOutOverlay(false);
        }
        popQuestDetails();

        //replaceWithMainView(index: BottomNavBarIndex.quest);
        log.i("replaced view with mapView");
      }
    } else {
      if (activeQuestService.previouslyFinishedQuest == null) {
        log.wtf(
            "Quest was successfully finished but previouslyFinishedQuest was not set! This should never happen and is due to an internal error in quest service..");
        setBusy(false);
        throw Exception(
            "Internal Error: For developers, please set the variable 'previouslyFinishedQuest' in the quest service.");
      }
      // Quest succesfully finished!
      await dialogService.showCustomDialog(
        variant: DialogType.CollectCredits,
        data: activeQuestService.previouslyFinishedQuest!,
      );
      replaceWithMainView(index: BottomNavBarIndex.quest);
      setBusy(false);
      return true;
    }
    setBusy(false);
  }

  // TODO: Unit test!
  // All this is essential and should probably be unit tested
  void popQuestDetails() async {
    // set flag to start fade out
    layoutService.setIsFadingOutQuestDetails(true);
    layoutService.setIsMovingCamera(true);

    // Restore camera
    restorePreviousCameraPosition();

    // reset/add back all quests
    mapViewModel.resetAndAddBackAllMapMarkersAndAreas();

    // maybe show quest list again
    if (navigatedFromQuestList) {
      showQuestListOverlay();
      changeNavigatedFromQuestList(false);
    }

    // reset selected quest after delay so the fade out is smooth
    await Future.delayed(Duration(milliseconds: 800));

    // reset flags
    layoutService.setIsMovingCamera(false);
    layoutService.setIsFadingOutQuestDetails(false);

    // reset selected quest -> don't show quest details anymore
    // reset previouslyFinishedQuest
    activeQuestService.resetSelectedAndMaybePreviouslyFinishedQuest();

    // cancel position listener that was used for calibration
    cancelPositionListener();
    activeQuestService.addMainLocationListener();

    // TODO: not sure why this is done!
    // reset distances to markers
    geolocationService.resetStoredDistancesToMarkers();
    notifyListeners();
  }

  Future checkAccuracy(
      {required Position? position,
      bool showDialog = true,
      double? minAccuracy}) async {
    if (position == null) {
      return false;
    }
    if (useSuperUserFeatures) {
      geolocationService.setGPSAccuracyInfo(
          position.accuracy, useSuperUserFeatures);
    }
    if (position.accuracy > (minAccuracy ?? kMinLocationAccuracy)) {
      geolocationService.setGPSAccuracyInfo(position.accuracy);
      if (showDialog) {
        log.e("Accuracy low: ${position.accuracy}");
        await dialogService.showDialog(
            title: "GPS Accuracy Too Low",
            description: "Please walk a few meters and try again :)");
      }
      return false;
    } else {
      return true;
    }
  }

  void showNextARObjects({required Future Function() onCollected}) {
    // TODO: I am not sure if this is the best way to implement this!
    // But maybe it is!?
    final AFKMarker? marker = activeQuestService.getNextMarker();
    if (marker == null || marker.lon == null && marker.lat == null) {
      log.wtf(
          "There is no next marker! This should never happen, investigate!");
      return;
    }
    mapViewModel.resetMapMarkers();
    mapViewModel.addARObjectToMap(
      lat: marker.lat!,
      lon: marker.lon!,
      isCoin: true,
      onTap: (double lat, double lon, bool isCoin) async {
        // 1. Open AR view with nice zoom in and fade out triggered
        bool collected =
            await mapViewModel.onARObjectMarkerTap(lat, lon, isCoin);

        // 2. Handle return value of AR view!
        if (collected) {
          await onCollected();
        } else {
          dialogService.showDialog(
              title: "Collect the final Marker to get credits!");
        }
      },
    );
  }

  Future animateCameraToStartMarker({int? delay}) async {
    double? lat = activeQuestService.selectedQuest?.startMarker?.lat;
    double? lon = activeQuestService.selectedQuest?.startMarker?.lon;
    if (lat != null && lon != null) {
      Future.delayed(
        Duration(milliseconds: delay ?? 0),
        () async => await mapViewModel.animateNewLatLon(
            lat: lat, lon: lon, force: true),
      );
    } else {
      log.e("Could not animate camera to start marker.");
    }
  }

  // navigate camera to show currently visible quest markers
  Future animateCameraToQuestMarkers({int delay = 0}) async {
    if (selectedQuest?.type == QuestType.TreasureLocationSearch) {
      animateCameraToStartMarker(delay: delay);
      return;
    }

    List<List<double>> latLngListToAnimate = activeQuestService
        .markersToShowOnMap(questIn: selectedQuest)
        .map((m) => [m.lat!, m.lon!])
        .toList();
    if ((hasActiveQuest == false || latLngListToAnimate.length == 1) &&
            selectedQuest?.type == QuestType.QRCodeHunt ||
        selectedQuest?.type == QuestType.GPSAreaHike ||
        selectedQuest?.type == QuestType.GPSAreaHunt) {
      latLngListToAnimate.add(geolocationService.getUserLatLngInList);
    }

    // add ghost latLong positions (in-place) to avoid  zooming
    // too far if only two positions very close by are shown!
    potentiallyAddGhostLatLng(latLngList: latLngListToAnimate);

    Future.delayed(
      Duration(milliseconds: delay),
      () => mapViewModel.animateCameraToBetweenCoordinates(
          latLngList: latLngListToAnimate),
    );
  }

  // if only two locations are shown we want to provide more padding on the
  // screen and therefore add ghost markers!
  void potentiallyAddGhostLatLng({required List<List<double>> latLngList}) {
    if (latLngList.length == 2) {
      if (geolocationService.distanceBetween(
              lat1: latLngList[0][0],
              lon1: latLngList[0][1],
              lat2: latLngList[1][0],
              lon2: latLngList[1][1]) <
          150) {
        // add ghost latLng positions for padding of camera!
        latLngList.add(geolocationService.getLatLngShiftedLonInList(
            latLng: latLngList[0], offset: 80));
        latLngList.add(geolocationService.getLatLngShiftedLonInList(
            latLng: latLngList[0], offset: -80));
      }
    }
  }

  // animate to user position
  Future animateCameraToUserPosition() async {
    await mapViewModel.animateNewLatLon(
        lat: geolocationService.getUserLivePositionNullable!.latitude,
        lon: geolocationService.getUserLivePositionNullable!.longitude,
        force: true);
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //         target: LatLng(
    //             geolocationService.getUserLivePositionNullable!.latitude,
    //             geolocationService.getUserLivePositionNullable!.longitude),
    //         zoom: await controller.getZoomLevel()),
    //   ),
    // );
    activeQuestService.questCenteredOnMap = false;
    notifyListeners();
  }

  // show Qr Code instead of animating to marker
  void displayQrCode(AFKMarker marker) {
    String qrCodeString =
        qrCodeService.getQrCodeStringFromMarker(marker: marker);
    navigationService.navigateTo(Routes.qRCodeView,
        arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
  }

  // showDialogs = true determines that dialogs should be shown on exceptions
  // showDialogs = false specifies that exceptions are handled by returning
  // adequate data;
  Future<CollectCreditsStatus> handleSuccessfullyFinishedQuest(
      {bool showDialogs = true}) async {
    if (activeQuestNullable?.status == QuestStatus.success) {
      log.i("Found that quest was successfully finished!");
      try {
        await activeQuestService.handleSuccessfullyFinishedQuest();
        return CollectCreditsStatus.done;
      } catch (e) {
        if (e is QuestServiceException) {
          log.e(e);
          if (showDialogs) {
            await dialogService.showDialog(
                title: e.prettyDetails, buttonTitle: 'Ok');
          }
          return CollectCreditsStatus.todo;
        } else if (e is CloudFunctionsApiException) {
          log.e(e);
          if (showDialogs) {
            await dialogService.showDialog(
                title: e.prettyDetails, buttonTitle: 'Ok');
          }
          return CollectCreditsStatus.noNetwork;
        } else {
          log.e(
              "Unknown error occured f{CollectCreditsStatus collectCreditsStatus}rom evaluateAndFinishQuest");
          setBusy(false);
          rethrow;
        }
      }
    } else {
      log.w(
          "Active quest either null or not successfull. Either way, this function should not have been called!");
      return CollectCreditsStatus.todo;
    }
  }

  // -------------------------------------
  // More common way to treat super user
  Future<bool> useSuperUserFeature() async {
    if (questTestingService.isPermanentAdminMode) {
      return true;
    }
    if (questTestingService.isPermanentUserMode) {
      return false;
    }
    final result = await showAdminDialogAndGetResponse();
    if (result == true) {
      return true;
    } else {
      return false;
    }
  }

  Future resetSlider() async {
    setBusy(true);
    await Future.delayed(Duration(milliseconds: 50));
    setBusy(false);
  }

  Future showQuestInfoDialog({required Quest quest}) async {
    await dialogService.showDialog(
        title: quest.name.toString() + "-" + quest.type.toString(),
        //title: quest.name + " - " + describeEnum(quest.type).toString(),
        description: "Earn ${quest.afkCredits} AFK Credits by " +
            getQuestDescriptionString(quest));
  }

  String getQuestDescriptionString(Quest quest) {
    if (quest.type == QuestType.GPSAreaHike) {
      return "collecting each checkpoint by walking to the shown red areas.";
    } else if (quest.type == QuestType.QRCodeHike) {
      return "finding all QR codes hidden in the highlighted areas.";
    } else if (quest.type == QuestType.DistanceEstimate) {
      return "walking the specified distance.";
    } else if (quest.type == QuestType.TreasureLocationSearch) {
      return "finding the treasure.";
    } else {
      return "collecting all markers";
    }
  }

  // ---------------------------------------------------
  // Function to call when quest was detected to be finished in individual viewmodel
  Future showSuccessDialog(
      {CollectCreditsStatus collectCreditsStatus =
          CollectCreditsStatus.todo}) async {
    activeQuestService.setSuccessAsQuestStatus();
    log.i("SUCCESFFULLY FOUND trophy");

    // Make checkout procedure same for all quest types!
    // Function in quest_viewmodel!
    final result = await dialogService.showCustomDialog(
      variant: DialogType.CollectCredits,
      data: {
        "activeQuest": activeQuestNullable ?? previouslyFinishedQuest,
        "status": collectCreditsStatus,
      },
    );
    if (result?.confirmed == true) {
      // TODO: This is the moment where we should show a summary statistic!

      // TODO: Then we should set previouslyFinishedQuest to null!

      // this means everything went fine!
      // Show statistics display
      questSuccessfullyFinished = true;
    }
    // cancelQuestListener();
    notifyListeners();
    return questSuccessfullyFinished;
  }

  Future showFoundTreasureDialog() async {
    await dialogService.showCustomDialog(
      variant: DialogType.FoundTreasure,
      data: activeQuest,
    );
  }

  //------------------------------------------------------------
  // Reactive Service Mixin Functionality from stacked ReactiveViewModel!
  late List<ReactiveServiceMixin> _reactiveServices;
  ActiveQuestBaseViewModel() {
    _reactToServices(reactiveServices);
  }
  List<ReactiveServiceMixin> get reactiveServices =>
      [activeQuestService]; // _reactiveServices;
  void _reactToServices(List<ReactiveServiceMixin> reactiveServices) {
    _reactiveServices = reactiveServices;
    for (var reactiveService in _reactiveServices) {
      reactiveService.addListener(_indicateChange);
    }
  }

  void maybeSetDistanceToStartMarker({required Quest quest}) async {
    final position = await geolocationService.getUserLivePosition;
    if (position.timestamp != null) {
      if (position.accuracy < 100 &&
          position.timestamp!
              .isAfter(DateTime.now().subtract(const Duration(seconds: 30)))) {
        geolocationService.setDistanceToStartMarker(
            lat: quest.startMarker?.lat,
            lon: quest.startMarker?.lon,
            position: position);
        notifyListeners();
      }
    }
  }

  void startPositionCalibrationListener({required Quest quest}) {
    log.i("Start position calibration listener");
    geolocationService.listenToPosition(
      distanceFilter: kDistanceFilterForCalibration,
      viewModelCallback: (position) async {
        setListenedToNewPosition(true);
        await geolocationService.setDistanceToStartMarker(
            lat: quest.startMarker?.lat,
            lon: quest.startMarker?.lon,
            position: position);
        notifyListeners();
      },
    );
  }

  void cancelPositionListener() {
    geolocationService.cancelPositionListener();
    setListenedToNewPosition(false);
  }

  Future<bool> checkIfBatterySaveModeOn() async {
    // Instantiate it
    try {
      final Battery battery = Battery();
      final isInBatterySaveMode = await battery.isInBatterySaveMode;
      if (isInBatterySaveMode != true) {
        return false;
      } else if (isInBatterySaveMode == true) {
        log.i("Phone is in battery save mode, show dialog");
        final result = await dialogService.showDialog(
          title: "Disable Battery Saver",
          description:
              "For best performance, please disable Power Saver in Settings/Battery.",
          buttonTitle: "SETTINGS",
          cancelTitle: "START ANYWAY",
          barrierDismissible: true,
        );
        if (result?.confirmed == true) {
          try {
            await OpenSettings.openBatterySaverSetting();
            return true;
          } catch (e) {
            log.e("Could not open settings");
            await Future.delayed(Duration(milliseconds: 500));
            await dialogService.showDialog(
              title: "Could Not Open Settings",
              description:
                  "Sorry, we could not open your settings. Please navigate to Settings/Battery yourself.",
            );
            return true;
          }
          // await checkIfBatterySaveModeOn();
        } else if (result?.confirmed == false) {
          return false;
        }
        return true;
        // await Future.delayed(Duration(milliseconds: 300));
      }
      return true;
    } catch (e) {
      log.e("Could not check battery save mode!");
      log.e("Error: $e");
      return false;
    }
  }

  void navigateBackFromSingleQuestView({bool replaceView = false}) {
    // set Fading Out layout to false otherwise screen is black
    layoutService.setIsFadingOutOverlay(false);
    // cancel Position listener
    cancelPositionListener();
    // add main location listener
    activeQuestService.addMainLocationListener();
    // restore distances to markers
    geolocationService.resetStoredDistancesToMarkers();
    // finally navigate back
    if (replaceView) {
      replaceWithHomeView();
    } else {
      popView();
    }
    // restore previous camera position. (not so important for standalone ui)
    restorePreviousCameraPosition(moveInsteadOfAnimate: true);
  }

  //------------------------------------------
  // Functions to override
  Future showInstructions(QuestType? type) async {
    if (type == QuestType.TreasureLocationSearch) {
      await dialogService.showDialog(
          title: "How it works", description: kLocationSearchDescription);
    } else if (type == QuestType.GPSAreaHike) {
      await dialogService.showDialog(
          title: "How it works", description: kGPSAreaHikeDescription);
    } else if (type == QuestType.DistanceEstimate) {
      await dialogService.showDialog(
          title: "How it works", description: kDistanceEstimateDescription);
    } else {
      showGenericInternalErrorDialog();
    }
  }

  Future maybeStartQuest(
      {required Quest? quest, void Function()? onStartQuestCallback});

  //-------------------------------------------
  // Helper

  Future vibrateAlert() async {
    await checkCanVibrate();
    if (canVibrate!) {
      final Iterable<Duration> pauses = [
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 500),
      ];
      log.v("Phone is supposed to vibrate now");
      // vibrate - sleep 0.2s - vibrate - sleep 0.2s - vibrate - sleep 0.2s - vibrate
      await Vibrate.vibrateWithPauses(pauses);
    }
  }

  Future vibrateWrongDirection() async {
    await vibrateAlert();
  }

  Future vibrateRightDirection() async {
    // Check if the device can vibrate
    await checkCanVibrate();
    if (canVibrate!) {
      log.v("Phone is supposed to vibrate now");
      // vibrate for default (500ms on android, about 500ms on iphone)
      await Vibrate.vibrate();
      // Vibrate.feedback(FeedbackType.success);
    }
  }

  Future checkCanVibrate() async {
    if (canVibrate == null) {
      canVibrate = await Vibrate.canVibrate;
      if (canVibrate!) {
        log.i("Phone is able to vibrate");
      } else {
        log.w("Phone is not able to vibrate!");
      }
    }
  }

  @override
  void dispose() {
    for (var reactiveService in _reactiveServices) {
      reactiveService.removeListener(_indicateChange);
    }
    resetPreviousQuest();
    super.dispose();
  }

  void _indicateChange() {
    notifyListeners();
  }

  @mustCallSuper
  void resetPreviousQuest() {
    questSuccessfullyFinished = false;
    validatingMarker = false;
  }
}
