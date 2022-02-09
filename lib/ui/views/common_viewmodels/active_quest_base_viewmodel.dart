import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/super_user_dialog_type.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/maps/maps_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_settings/open_settings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';

abstract class ActiveQuestBaseViewModel extends BaseModel {
  // ---------------------------------------------------------
  // Services
  final MapsService mapsService = locator<MapsService>();
  final QuestTestingService questTestingService =
      locator<QuestTestingService>();
  final FlavorConfigProvider flavorConfigProvider =
      locator<FlavorConfigProvider>();
  final log = getLogger("ActiveQuestBaseViewModel");

  // ----------------------------------------------------------
  // getters
  bool get isDevFlavor => flavorConfigProvider.flavor == Flavor.dev;
  bool get isNearStartMarker => !flavorConfigProvider.enableGPSVerification
      ? true
      : (geolocationService.distanceToStartMarker > 0) &&
          (geolocationService.distanceToStartMarker <
              kMaxDistanceFromMarkerInMeter);
  Quest? get currentQuest => questService.currentQuest;
  // timeElapsed is a reactive value
  String get timeElapsed => questService.getMinutesElapsedString();
  double get distanceToStartMarker => geolocationService.distanceToStartMarker;
  bool get isCalculatingDistanceToStartMarker => distanceToStartMarker < 0;
  // -----------------------------------------------------------
  // UI state
  bool showCollectedMarkerAnimation = false;
  bool showStartSwipe = true;

  bool questSuccessfullyFinished = false;
  bool questFinished = false;

  bool questCenteredOnMap = true;

  // TODO: maybe deprecated
  String lastActivatedQuestInfoText = "Active Quest";

  // ------------------------------------------
  // Functions to override!
  // TODO: Check this!
  bool isQuestCompleted();
  // void updateMapMarkers({required AFKMarker afkmarker}) {}

  ///------------------------------------------------------------
  /// Main Functions
  /// -----------------------------------------------------------
  @mustCallSuper
  Future initialize({required Quest quest}) async {
    // sets current quest in service so it is accessible anywhere
    questService.currentQuest = quest;

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
    if (await checkIfBatterySaveModeOn()) {
      resetSlider();
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
      final isQuestStarted = await questService.startQuest(
          quest: quest,
          uids: [currentUser.uid],
          periodicFuncFromViewModel: periodicFuncFromViewModel,
          countStartMarkerAsCollected: countStartMarkerAsCollected);

      // this will also change the MapViewModel to show the ActiveQuestView
      if (isQuestStarted is String) {
        await dialogService.showDialog(
            title: "Sorry could not start the quest",
            description: isQuestStarted);
        resetSlider();
        return false;
      }
      showStartSwipe = false;
      // Quest succesfully started!
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
        await questService.continueIncompleteQuest();
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
        await questService.cancelIncompleteQuest();

        resetPreviousQuest();
        replaceWithMainView(index: BottomNavBarIndex.quest);
        log.i("replaced view with mapView");
      }
    } else {
      if (questService.previouslyFinishedQuest == null) {
        log.wtf(
            "Quest was successfully finished but previouslyFinishedQuest was not set! This should never happen and is due to an internal error in quest service..");
        setBusy(false);
        throw Exception(
            "Internal Error: For developers, please set the variable 'previouslyFinishedQuest' in the quest service.");
      }
      // Quest succesfully finished!
      await dialogService.showCustomDialog(
        variant: DialogType.CollectCredits,
        data: questService.previouslyFinishedQuest!,
      );
      replaceWithMainView(index: BottomNavBarIndex.quest);
      setBusy(false);
      return true;
    }
    setBusy(false);
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
        await questService.handleSuccessfullyFinishedQuest();
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
        title: quest.name + " - " + describeEnum(quest.type).toString(),
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
    questService.setSuccessAsQuestStatus();
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
      // this means everything went fine!
      // Show statistics display
      questSuccessfullyFinished = true;
    }
    // cancelQuestListener();
    notifyListeners();
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
      [questService]; // _reactiveServices;
  void _reactToServices(List<ReactiveServiceMixin> reactiveServices) {
    _reactiveServices = reactiveServices;
    for (var reactiveService in _reactiveServices) {
      reactiveService.addListener(_indicateChange);
    }
  }

  Future showCollectedMarkerDialog() async {
    await dialogService.showCustomDialog(variant: DialogType.CollectedMarker);
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
      viewModelCallback: (position) {
        setListenedToNewPosition(true);
        geolocationService.setDistanceToStartMarker(
            lat: quest.startMarker?.lat,
            lon: quest.startMarker?.lon,
            position: position);
        notifyListeners();
      },
    );
  }

  void cancelPositionListener() {
    log.i("Cancel position listener");
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

  void navigateBackFromSingleQuestView() {
    cancelPositionListener();
    geolocationService.resetStoredDistancesToMarkers();
    navigationService.back();
  }

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
    showStartSwipe = true;
    validatingMarker = false;
  }
}
