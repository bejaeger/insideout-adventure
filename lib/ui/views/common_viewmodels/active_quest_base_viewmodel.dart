import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/super_user_dialog_type.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/active_quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/utils/utilities.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:open_settings/open_settings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class ActiveQuestBaseViewModel extends BaseModel
    with MapStateControlMixin {
  final MapStateService mapsService = locator<MapStateService>();
  final QuestTestingService questTestingService =
      locator<QuestTestingService>();
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final ActiveQuestService activeQuestService = locator<ActiveQuestService>();
  final MapViewModel mapViewModel = locator<MapViewModel>();
  final log = getLogger("ActiveQuestBaseViewModel");

  bool get isDevFlavor => appConfigProvider.flavor == Flavor.dev;
  bool get isNearStartMarker => !appConfigProvider.enableGPSVerification
      ? true
      : (geolocationService.distanceToStartMarker > 0) &&
          (geolocationService.distanceToStartMarker <
              kMaxDistanceFromMarkerInMeter);
  Quest? get currentQuest => activeQuestService.currentQuest;
  // timeElapsed is a reactive value
  String get timeElapsed => activeQuestService.getMinutesElapsedString();
  double get distanceToStartMarker => geolocationService.distanceToStartMarker;
  bool get isCalculatingDistanceToStartMarker => distanceToStartMarker < 0;
  bool get showStartSwipe => !activeQuestService.hasActiveQuest;
  bool get questCenteredOnMap => activeQuestService.questCenteredOnMap;
  bool get hasActivatedQuestToBeStarted =>
      activeQuestService.hasActiveQuestToBeStarted;
  ActivatedQuest? get questToBeStarted => activeQuestService.questToBeStarted;

  bool questSuccessfullyFinished = false;
  bool questFinished = false;
  bool showCollectedMarkerAnimation = false;
  // to show progress indicator to make user aware something is happening in the background
  bool isAnimatingCamera = false;
  bool redoQuest = false;

  bool isQuestCompleted();

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

  // always called when quest is started
  Future startQuestMain(
      {required Quest quest,
      Future Function(int)? periodicFuncFromViewModel,
      bool countStartMarkerAsCollected = false}) async {
    // cancels listener that was only used for calibration
    cancelPositionListener();

    // not used atm
    // if (await checkIfBatterySaveModeOn()) {
    //   resetSlider();
    //   return false;
    // }

    try {
      questTestingService.maybeInitialize(user: currentUser);

      final isQuestStarted = await activeQuestService.startQuest(
          quest: quest,
          uids: [currentUser.uid],
          periodicFuncFromViewModel: periodicFuncFromViewModel,
          countStartMarkerAsCollected: countStartMarkerAsCollected);

      if (isQuestStarted is String) {
        await dialogService.showDialog(
            title: "You cannot start the quest", description: isQuestStarted);
        resetSlider();
        return false;
      }

      // Quest started
      activeQuestService.resetSelectedQuest();
      // ^ by resetting this the UI will react and knows that an active quest is present, not only the "selected" quest

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

  Future cancelOrFinishQuest(
      {bool force = false, bool showDialog = true}) async {
    if (!hasActiveQuest) {
      log.w("No active quest present to cancel");
      return;
    }

    DialogResponse<dynamic>? response = DialogResponse(confirmed: false);
    if (!force) {
      log.w("Quest is incomplete, show dialog");
      response = await dialogService.showConfirmationDialog(
          barrierDismissible: true,
          title: WarningQuestNotFinished,
          cancelTitle: "CANCEL QUEST",
          confirmationTitle: "CONTINUE QUEST");
    } else {
      log.w("You are forcing to end the quest");
    }

    if (response?.confirmed == true) {
      await activeQuestService.continueIncompleteQuest();
    }
    if (response?.confirmed == false || force) {
      if (questTestingService.isRecordingLocationData &&
          !questTestingService.isAllQuestDataPointsPushed()) {
        log.v("push quest data to notion");
        await dialogService.showCustomDialog(
            barrierDismissible: true,
            variant: DialogType.SuperUserSettings,
            data: SuperUserDialogType.sendDiagnostics);
      }
      await activeQuestService.cancelIncompleteQuest();

      resetPreviousQuest();
      popQuestDetails();
    }
    setBusy(false);
  }

  // All this is essential and should probably be unit tested
  void popQuestDetails() async {
    layoutService.setIsFadingOutQuestDetails(true);
    layoutService.setIsMovingCamera(true);

    restorePreviousCameraPositionAndAnimate();

    mapViewModel.resetAndAddBackAllMapMarkersAndAreas();

    if (navigatedFromQuestList) {
      showQuestListOverlay();
      changeNavigatedFromQuestList(false);
    }

    await Future.delayed(
        Duration(milliseconds: (800 * mapAnimationSpeedFraction()).round()));

    layoutService.setIsMovingCamera(false);
    layoutService.setIsFadingOutQuestDetails(false);

    // for rotation camera movements in avatar view
    activeQuestService.questCenteredOnMap = false;

    // reset selected quest -> don't show quest details anymore
    // reset previouslyFinishedQuest
    activeQuestService.resetSelectedAndMaybePreviouslyFinishedQuest();

    // cancel position listener that was used for calibration and add main location listener
    cancelPositionListener();
    activeQuestService.addMainLocationListener();

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

  // adds AR marker to map and decides how to collect it with onCollected callback
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
      isGreen: true,
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
    notifyListeners();
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
    // TODO: Could add more ghost markers this cause sometimes the zoom is too much
    // TODO:  e.g. if line between markers is parallel to the north-south direction
    mapViewModel.potentiallyAddGhostLatLng(latLngList: latLngListToAnimate);

    Future.delayed(
      Duration(milliseconds: delay),
      () => mapViewModel.animateCameraToBetweenCoordinates(
          latLngList: latLngListToAnimate),
    );
  }

  // animate to user position
  Future animateCameraToUserPosition() async {
    mapViewModel.animateNewLatLon(
        lat: geolocationService.getUserLivePositionNullable!.latitude,
        lon: geolocationService.getUserLivePositionNullable!.longitude,
        force: true);
    activeQuestService.questCenteredOnMap = false;
    notifyListeners();
  }

  // showDialogs = true determines that dialogs should be shown on exceptions
  // showDialogs = false specifies that exceptions are handled by returning
  Future<CollectCreditsStatus> handleQuestCompletedEventBase(
      {bool showDialogs = true}) async {
    if (activeQuestNullable?.status == QuestStatus.success) {
      log.i("Found that quest was successfully finished!");
      try {
        final res = await activeQuestService.handleSuccessfullyFinishedQuest(
            disposeQuest: showDialogs);
        if (res == WarningFirestoreCallTimeout) {
          if (showDialogs) {
            await dialogService.showDialog(
                title: "Unstable network connection",
                description: "Make sure you have data connection");
          }
          return CollectCreditsStatus.noNetwork;
        }
        return CollectCreditsStatus.done;
      } catch (e) {
        if (e is QuestServiceException) {
          log.e(e);
          if (showDialogs) {
            await dialogService.showDialog(
                title: e.prettyDetails, buttonTitle: 'Ok');
          }
          return CollectCreditsStatus.todo;
        } else {
          log.e("Unknown error occured from evaluateAndFinishQuest");
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

  // Function to call when quest was detected to be finished in individual viewmodel
  // We can parse it a collectCreditsStatus to check whether
  // we still need to collect the credits in the view or not!
  Future showSuccessDialog(
      {CollectCreditsStatus collectCreditsStatus =
          CollectCreditsStatus.todo}) async {
    activeQuestService.setSuccessAsQuestStatus();
    log.i("SUCCESSFULLY FOUND trophy");

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
      questSuccessfullyFinished = true;
    }
    notifyListeners();
    return questSuccessfullyFinished;
  }

  Future showFoundTreasureDialog() async {
    await dialogService.showCustomDialog(
      variant: DialogType.FoundTreasure,
      data: activeQuest,
    );
  }

  bool showCompletedQuestNote() {
    if (redoQuest) {
      return false;
    } else {
      return userService.hasCompletedQuest(questId: selectedQuest?.id);
    }
  }

  void switchRedoQuestAndRebuildUI() {
    redoQuest = !redoQuest;
    notifyListeners();
  }

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
        } else if (result?.confirmed == false) {
          return false;
        }
        return true;
      }
      return true;
    } catch (e) {
      log.e("Could not check battery save mode!");
      log.e("Error: $e");
      return false;
    }
  }

  void navigateBackFromSingleQuestView({bool replaceView = false}) {
    // screen is black otherwise
    layoutService.setIsFadingOutOverlay(false);
    // cancel calibration position listener
    cancelPositionListener();
    // add main location listener
    activeQuestService.addMainLocationListener();
    geolocationService.resetStoredDistancesToMarkers();
    if (replaceView) {
      replaceWithHomeView();
    } else {
      popView();
    }
    restorePreviousCameraPositionAndAnimate(moveInsteadOfAnimate: true);
  }

  Future maybeStartQuest(
      {required Quest? quest, void Function()? notifyGuardianCallback});

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
    await checkCanVibrate();
    if (canVibrate!) {
      log.v("Phone is supposed to vibrate now");
      // vibrate for default (500ms on android, about 500ms on iphone)
      await Vibrate.vibrate();
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
