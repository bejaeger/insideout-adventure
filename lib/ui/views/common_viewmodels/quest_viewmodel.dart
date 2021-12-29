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
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class QuestViewModel extends BaseModel {
  final log = getLogger("QuestViewModel");
  StreamSubscription? _activeQuestSubscription;
  String lastActivatedQuestInfoText = "Active Quest";
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  String? get gpsAccuracyInfo => _geolocationService.gpsAccuracyInfo;
  final FlavorConfigProvider flavorConfigProvider =
      locator<FlavorConfigProvider>();
  final QRCodeService qrCodeService = locator<QRCodeService>();
  List<Quest> get nearbyQuests => questService.nearbyQuests;
  List<double> distancesFromQuests = [];
  bool validatingMarker = false;

  QuestViewModel() {
    // listen to changes in wallet
    log.i("Setting up active quest listener");
    _activeQuestSubscription = questService.activatedQuestSubject.listen(
      (activatedQuest) {
        if (activeQuestNullable?.quest.type == QuestType.Hike) {
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

  List<Quest> getQuestsOfType({required QuestType type}) {
    return questService.extractQuestsOfType(
        quests: nearbyQuests, questType: type);
  }

  Future getLocation({bool forceAwait = false}) async {
    try {
      if (_geolocationService.getUserPosition == null) {
        await _geolocationService.getAndSetCurrentLocation();
      } else {
        if (forceAwait) {
          await _geolocationService.getAndSetCurrentLocation();
        } else {
          _geolocationService.getAndSetCurrentLocation();
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
      if (questService.getQuestUIStyle(quest: quest) == QuestUIStyle.map) {
        await displayQuestBottomSheet(
          quest: quest,
        );
      } else {
        await navigateToActiveQuestUI(quest: quest);
      }
    } else {
      dialogService.showDialog(title: "You Currently Have a Running Quest !!!");
    }
  }

  Future displayQuestBottomSheet(
      {required Quest quest, AFKMarker? startMarker}) async {
    SheetResponse? sheetResponse = await bottomSheetService.showCustomSheet(
        variant: BottomSheetType.questInformation,
        title: quest.name,
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

  Future navigateToActiveQuestUI({required Quest quest}) async {
    log.i("Navigating to view with currently active quest");

    if (quest.type == QuestType.TreasureLocationSearch) {
      navigationService.navigateTo(Routes.activeTreasureLocationSearchQuestView,
          arguments:
              ActiveTreasureLocationSearchQuestViewArguments(quest: quest));
    } else if (quest.type == QuestType.DistanceEstimate) {
      navigationService.navigateTo(Routes.activeDistanceEstimateQuestView,
          arguments: ActiveDistanceEstimateQuestViewArguments(quest: quest));
    } else if (quest.type == QuestType.QRCodeSearch ||
        quest.type == QuestType.QRCodeSearchIndoor ||
        quest.type == QuestType.QRCodeHuntIndoor) {
      navigationService.navigateTo(Routes.activeQrCodeSearchView,
          arguments: ActiveQrCodeSearchViewArguments(quest: quest));
    } else if (quest.type == QuestType.Hike || quest.type == QuestType.Hunt) {
      navigationService.navigateTo(Routes.activeMapQuestView,
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
    await handleMarkerAnalysisResult(result);
  }

  Future<MarkerAnalysisResult> navigateToQrcodeViewAndReturnResult() async {
    final marker = await navigationService.navigateTo(Routes.qRCodeView);
    if (isSuperUser && marker != null) {
      final adminMode = await showAdminDialogAndGetResponse();
      if (adminMode) {
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
    if (activeQuest.quest.type == QuestType.Hike ||
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
    if (activeQuest.quest.type == QuestType.Hike ||
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
    } else if (activeQuest.quest.type == QuestType.TreasureLocationSearch ||
        activeQuest.quest.type == QuestType.TreasureLocationSearchAutomatic) {
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
  }

  void displayMarker(AFKMarker marker) {
    String qrCodeString =
        qrCodeService.getQrCodeStringFromMarker(marker: marker);
    navigationService.navigateTo(Routes.qRCodeView,
        arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
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
    if (isSuperUser) {
      _geolocationService.setGPSAccuracyInfo(
          "GPS accuracy: ${position.accuracy.toStringAsFixed(0)} m");
    }
    if (position.accuracy > (minAccuracy ?? kMinLocationAccuracy)) {
      _geolocationService.setGPSAccuracyInfo("Low GPS Accuracy");
      if (showDialog) {
        log.e("Accuracy low: ${position.accuracy}");
        await dialogService.showDialog(
            title: "GPS Accuracy Too Low",
            description:
                "Please walk or wait for a few seconds and try again :)");
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

  void resetSlider() async {
    setBusy(true);
    await Future.delayed(Duration(milliseconds: 50));
    setBusy(false);
  }

  // Can be overridden!
  void resetQuest() {}

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
