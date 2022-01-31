import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_ui_style.dart';
import 'package:afkcredits/enums/super_user_dialog_type.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:open_settings/open_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:battery_plus/battery_plus.dart';

abstract class QuestViewModel extends BaseModel {
  final log = getLogger("QuestViewModel");
  StreamSubscription? _activeQuestSubscription;
  String lastActivatedQuestInfoText = "Active Quest";
  Quest? get currentQuest => questService.currentQuest;
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final MarkerService _markerService = locator<MarkerService>();
  final QuestTestingService questTestingService =
      locator<QuestTestingService>();
  String? get gpsAccuracyInfo => _geolocationService.gpsAccuracyInfo;
  int? get currentGPSAccuracy => _geolocationService.currentGPSAccuracy;
  final FlavorConfigProvider flavorConfigProvider =
      locator<FlavorConfigProvider>();
  bool get isDevFlavor => flavorConfigProvider.flavor == Flavor.dev;
  final QRCodeService qrCodeService = locator<QRCodeService>();
  //Getter From the Neary By Quests.
  List<Quest> get nearbyQuests => questService.getNearByQuest;
  List<double> distancesFromQuests = [];
  bool validatingMarker = false;
  bool showStartSwipe = true;
  bool get isNearStartMarker => !flavorConfigProvider.enableGPSVerification
      ? true
      : (_geolocationService.distanceToStartMarker > 0) &&
          (_geolocationService.distanceToStartMarker <
              kMaxDistanceFromMarkerInMeter);

  bool get listenedToNewPosition => _geolocationService.listenedToNewPosition;
  int get currentPositionDistanceFilter =>
      _geolocationService.currentPositionDistanceFilter;

  QuestViewModel() {
    // listen to changes in wallet
    log.i("Setting up active quest listener");
    _activeQuestSubscription = questService.activatedQuestSubject.listen(
      (activatedQuest) {
        if (activeQuestNullable?.quest.type == QuestType.QRCodeHike) {
          lastActivatedQuestInfoText = getActiveQuestProgressDescription();
        }
        // TODO: Check the number of rebuilds that is required here!
        notifyListeners();

        if (activatedQuest?.status == QuestStatus.success ||
            activatedQuest?.status == QuestStatus.cancelled ||
            activatedQuest?.status == QuestStatus.failed) {
          cancelQuestListener();
        }
      },
    );
  }

  Future initialize({required Quest quest}) async {
    questService.currentQuest = quest;
    startPositionCalibrationListener(quest: quest);
    await _geolocationService.setDistanceToStartMarker(
        lat: quest.startMarker?.lat, lon: quest.startMarker?.lon);
    // start calibration listener
  }

  List<Quest> getQuestsOfType({required QuestType type}) {
    return questService.extractQuestsOfType(
        quests: nearbyQuests, questType: type);
  }

  void startPositionCalibrationListener({required Quest quest}) {
    log.i("Start position calibration listener");
    _geolocationService.listenToPosition(
      distanceFilter: kDistanceFilterForCalibration,
      viewModelCallback: (_) {
        setListenedToNewPosition(true);
        _geolocationService.setDistanceToStartMarker(
            lat: quest.startMarker?.lat, lon: quest.startMarker?.lon);
        notifyListeners();
      },
    );
  }

  void cancelPositionListener() {
    log.i("Cancel position listener");
    _geolocationService.cancelPositionListener();
    setListenedToNewPosition(false);
  }

  ////////////////////////////////////////
  // Navigation and dialogs

  Future startQuestMain(
      {required Quest quest,
      Future Function(int)? periodicFuncFromViewModel,
      bool countStartMarkerAsCollected = false}) async {
    // cancel listener that was only used for calibration
    cancelPositionListener();
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
      baseModelLog.e("Could not start quest, error thrown: $e");
      rethrow;
    }
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

  Future getLocation(
      {bool forceAwait = false, bool forceGettingNewPosition = true}) async {
    try {
      if (_geolocationService.getUserLivePositionNullable == null) {
        await _geolocationService.getAndSetCurrentLocation(
            forceGettingNewPosition: forceGettingNewPosition);
      } else {
        if (forceAwait) {
          await _geolocationService.getAndSetCurrentLocation(
              forceGettingNewPosition: forceGettingNewPosition);
        } else {
          _geolocationService.getAndSetCurrentLocation(
              forceGettingNewPosition: forceGettingNewPosition);
        }
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
        log.wtf("Could not get location of user");
        await showGenericInternalErrorDialog();
      }
    }
  }

  Future getDistancesToStartOfQuests() async {
    if (nearbyQuests.isNotEmpty) {
      log.i("Check distances for current quest list");

      // need to use normal for loop to await results
      for (var i = 0; i < nearbyQuests.length; i++) {
        if (nearbyQuests[i].startMarker != null) {
          double distance =
              await _geolocationService.distanceBetweenUserAndCoordinates(
                  lat: nearbyQuests[i].startMarker!.lat,
                  lon: nearbyQuests[i].startMarker!.lon);
          nearbyQuests[i] =
              nearbyQuests[i].copyWith(distanceFromUser: distance);
        }
      }
    } else {
      log.w(
          "Curent quests empty, or distance check not required. Can't check distances");
    }
    log.i("Notify listeners");
    notifyListeners();
  }

  Future onQuestInListTapped(Quest quest) async {
    log.i("Quest list item tapped!!!");
    if (hasActiveQuest == false) {
      // if (questService.getQuestUIStyle(quest: quest) == QuestUIStyle.map) {
      //   await displayQuestBottomSheet(
      //     quest: quest,
      //   );
      // } else {
      await navigateToActiveQuestUI(quest: quest);

      // ! This notify listeners is important as the
      // the view renders the state based on whether a quest is active or not
      notifyListeners();
      // }
    } else {
      dialogService.showDialog(title: "You Currently Have a Running Quest !!!");
    }
  }

  Future displayQuestBottomSheet(
      {required Quest quest, AFKMarker? startMarker}) async {
    SheetResponse? sheetResponse = await bottomSheetService.showCustomSheet(
        variant: BottomSheetType.questInformation,
        title: quest.name,
        enterBottomSheetDuration: Duration(milliseconds: 300),
        // exitBottomSheetDuration: Duration(milliseconds: 1),
        // curve: Curves.easeInExpo,
        // curve: Curves.linear,
        barrierColor: Colors.black45,
        description: quest.description,
        mainButtonTitle: quest.type == QuestType.DistanceEstimate
            ? "Go to Quest"
            : "Go to Quest",
        secondaryButtonTitle: "Close",
        data: quest);
    if (sheetResponse?.confirmed == true) {
      log.i("Looking at details of quest OR starting quest immediately");
      questService.getQuestUIStyle(quest: quest) == QuestUIStyle.map
          ? await navigateToActiveQuestUI(quest: quest)
          : await navigateToActiveQuestUI(quest: quest);
    }
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
    } else {
      return "collecting all markers";
    }
  }

  Future navigateToActiveQuestUI({required Quest quest}) async {
    log.i("Navigating to view with currently active quest");

    if (quest.type == QuestType.TreasureLocationSearch) {
      await navigationService.navigateTo(
          Routes.activeTreasureLocationSearchQuestView,
          arguments:
              ActiveTreasureLocationSearchQuestViewArguments(quest: quest));
    } else if (quest.type == QuestType.DistanceEstimate) {
      await navigationService.navigateTo(Routes.activeDistanceEstimateQuestView,
          arguments: ActiveDistanceEstimateQuestViewArguments(quest: quest));
    } else if (quest.type == QuestType.QRCodeSearch ||
        quest.type == QuestType.QRCodeSearchIndoor ||
        quest.type == QuestType.QRCodeHuntIndoor) {
      await navigationService.navigateTo(Routes.activeQrCodeSearchView,
          arguments: ActiveQrCodeSearchViewArguments(quest: quest));
    } else if (quest.type == QuestType.QRCodeHike ||
        quest.type == QuestType.GPSAreaHike ||
        quest.type == QuestType.Hunt) {
      await navigationService.navigateTo(Routes.activeMapQuestView,
          arguments: ActiveMapQuestViewArguments(quest: quest));
    }
    // } else if (quest.type == QuestType.Hike) {
    //   navigationService.navigateTo(Routes.activeDistanceEstimateQuestView);
    // }

    // final questViewIndex =
    //     questService.getQuestUIStyle(quest: quest) == QuestUIStyle.map
    //         ? QuestViewType.map
    //         : QuestViewType.singlequest;
    // // if (quest.type == QuestType.DistanceEstimate) {
    // //   navigationService.navigateTo(Routes.activeDistanceEstimateQuestView,
    // //       arguments: ActiveDistanceEstimateQuestViewArguments(quest: quest));
    // // } else {
    // // Use the following to keep bottom nav bar!
    // await navigationService.navigateTo(
    //   Routes.bottomBarLayoutTemplateView,
    //   arguments: BottomBarLayoutTemplateViewArguments(
    //     userRole: currentUser.role,
    //     questViewIndex: questViewIndex,
    //     initialBottomNavBarIndex: BottomNavBarIndex.quest,
    //     quest: quest,
    //   ),
    // );
    // }
  }

  Future scanQrCode() async {
    // navigate to qr code view, validate results in quest service, and continue
    MarkerAnalysisResult result = await navigateToQrcodeViewAndReturnResult();
    if (result.isEmpty) {
      log.wtf("The object QuestQRCodeScanResult is empty!");
      return;
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
      dialogService.showDialog(
        title: "Failed to collect marker!",
        description: result.errorMessage!,
      );
      return;
    }
    return await handleMarkerAnalysisResult(result);
  }

  Future<MarkerAnalysisResult> navigateToQrcodeViewAndReturnResult() async {
    final marker = await navigationService.navigateTo(Routes.qRCodeView);
    if (useSuperUserFeatures && marker != null) {
      final adminMode = await showAdminDialogAndGetResponse();
      if (adminMode == true) {
        String qrCodeString =
            qrCodeService.getQrCodeStringFromMarker(marker: marker);
        await navigationService.navigateTo(Routes.qRCodeView,
            arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
        return MarkerAnalysisResult.empty();
      }
    }
    validatingMarker = true;
    MarkerAnalysisResult scanResult =
        await questService.analyzeMarker(marker: marker);
    validatingMarker = false;
    return scanResult;
  }

  String getActiveQuestProgressDescription() {
    if (activeQuest.quest.type == QuestType.QRCodeHike ||
        activeQuest.quest.type == QuestType.Hunt ||
        activeQuest.quest.type == QuestType.QRCodeSearch) {
      final returnString = "Collected " +
          numMarkersCollected.toString() +
          " of " +
          activeQuest.markersCollected.length.toString() +
          " markers";
      return returnString;
    } else {
      return "";
    }
  }

  /////////////////////////////////////
  /// Vibration Search Quest
  ////////////////////////////////////////

  // MAYBE THIS COULD BE An abstract class to be overridden by the
  // specific viewmodels for the particular quests!
  // To disentangle stuff!
  Future getActivatedQuestInfoText() async {
    log.v("Checking quest info after quest was updated");
    if (questService.isUIDeadTime == true) {
      log.i(
          "NOT checking quest info after quest was updated because UI dead time is active");
      return;
    }
    if (activeQuest.quest.type == QuestType.QRCodeHike ||
        activeQuest.quest.type == QuestType.Hunt ||
        activeQuest.quest.type == QuestType.QRCodeSearch) {
      lastActivatedQuestInfoText = "Active quest - " +
          getHourMinuteSecondsTime +
          /*        " " +
            model.activeQuest.timeElapsed
                .toString() f+ */
          " elapsed - " +
          numMarkersCollected.toString() +
          " / " +
          activeQuest.markersCollected.length.toString() +
          " markers";
    } else if (activeQuest.quest.type == QuestType.DistanceEstimate) {
      lastActivatedQuestInfoText = "Estimating Distance";
    } else if (activeQuest.quest.type == QuestType.TreasureLocationSearch) {
      log.wtf(
          "Should never be called, this is handled in ActiveVibrationSearchQuestViewModel.");
    } else {
      lastActivatedQuestInfoText = "UNKNOWN QUEST RUNNING";
    }
    notifyListeners();
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
        baseModelLog.w("Quest is incomplete, show dialog");
        continueQuest = await dialogService.showConfirmationDialog(
            title: WarningQuestNotFinished,
            cancelTitle: "Cancel Quest",
            confirmationTitle: "Continue Quest");
      } else {
        baseModelLog.w("You are forcing to end the quest");
      }

      if (continueQuest?.confirmed == true) {
        await questService.continueIncompleteQuest();
        questService.setUIDeadTime(false);
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
        questService.cancelIncompleteQuest();

        resetQuest();
        replaceWithMainView(index: BottomNavBarIndex.quest);
        baseModelLog.i("replaced view with mapView");
      }
      questService.setUIDeadTime(false);
    } else {
      if (questService.previouslyFinishedQuest == null) {
        baseModelLog.wtf(
            "Quest was successfully finished but previouslyFinishedQuest was not set! This should never happen and is due to an internal error in quest service..");
        questService.setUIDeadTime(false);
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
      questService.setUIDeadTime(false);
      setBusy(false);
      return true;
    }
    setBusy(false);
  }

  ////////////////////////////
  // needs to be overrriden!
  // Future handleQrCodeScanEvent(QuestQRCodeScanResult result);
  // ! Check this!
  // DEPRECATED: Not sure if this is every being called!
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) async {
    log.i("Handling marker analysis result");
    if (!hasActiveQuest &&
        (result.quests == null ||
            (result.quests != null && result.quests!.length == 0))) {
      await dialogService.showDialog(
          title:
              "The scanned marker is not a start of a quest. Please go to the starting point");
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

  void displayMarker(AFKMarker marker) {
    String qrCodeString =
        qrCodeService.getQrCodeStringFromMarker(marker: marker);
    navigationService.navigateTo(Routes.qRCodeView,
        arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
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

  // -----------------------------------------
  // Helper functions
  Future checkAccuracy(
      {required Position? position,
      bool showDialog = true,
      double? minAccuracy}) async {
    if (position == null) {
      return false;
    }
    if (useSuperUserFeatures) {
      _geolocationService.setGPSAccuracyInfo(
          position.accuracy, useSuperUserFeatures);
    }
    if (position.accuracy > (minAccuracy ?? kMinLocationAccuracy)) {
      _geolocationService.setGPSAccuracyInfo(position.accuracy);
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

  // String? updateTimeElapsedString() {
  //   if (hasActiveQuest) {
  //     timeElapsed =  _stopWatchService
  //         .secondsToHourMinuteSecondTime(activeQuest.timeElapsed);
  //   }
  // }

  int currentIndex = 0;
  void toggleIndex() {
    if (currentIndex == 0) {
      currentIndex = 1;
    } else {
      currentIndex = 0;
    }
    notifyListeners();
  }

  Future resetSlider() async {
    setBusy(true);
    await Future.delayed(Duration(milliseconds: 50));
    setBusy(false);
  }

  // Can be overridden!
  void resetQuest() {}

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

  //////////////////////////////////////////
  /// Clean-up
  ///
  void cancelQuestListener() {
    log.i("Cancelling subscription to quest");
    _activeQuestSubscription?.cancel();
    _activeQuestSubscription = null;
  }

  @override
  void dispose() {
    _activeQuestSubscription?.cancel();
    resetQuest();
    super.dispose();
  }
}
