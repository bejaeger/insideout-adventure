import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_ui_style.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class QuestViewModel extends BaseModel {
  final log = getLogger("QuestViewModel");
  StreamSubscription? _activeQuestSubscription;
  String lastActivatedQuestInfoText = "Active Quest";
  final GeolocationService _geolocationService = locator<GeolocationService>();
  String? get gpsAccuracyInfo => _geolocationService.gpsAccuracyInfo;

  final StopWatchService _stopWatchService = locator<StopWatchService>();
  final QRCodeService _qrCodeService = locator<QRCodeService>();
  List<Quest> get nearbyQuests => questService.nearbyQuests;

  QuestViewModel() {
    // listen to changes in wallet
    _activeQuestSubscription = questService.activatedQuestSubject.listen(
      (activatedQuest) {
        // if (stats?.status == QuestStatus.active ||
        //     stats?.status == QuestStatus.incomplete) {
        //   // TODO: make this more general! UI response to quest actions!
        //   // TODO: Could be a function to be overridden by specific ACTIVE quest viewmodels
        //   // similar to 'trackData' or 'trackDataVibrationSearch' in quest_service
        //   getActivatedQuestInfoText();
        // }
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

  Future loadQuests() async {
    await questService.loadNearbyQuests();
  }

  List<Quest> getQuestsOfType({required QuestType type}) {
    return questService.extractQuestsOfType(
        quests: nearbyQuests, questType: type);
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
        title: 'Name: ' + quest.name,
        description: 'Description: ' + quest.description,
        mainButtonTitle: quest.type == QuestType.DistanceEstimate
            ? "Go to Quest"
            : "Start Quest",
        secondaryButtonTitle: "Close",
        data: quest);
    if (sheetResponse?.confirmed == true) {
      log.i("Looking at details of quest OR starting quest immediately");
      questService.getQuestUIStyle(quest: quest) == QuestUIStyle.map
          ? await startQuestMain(quest: quest)
          : await navigateToActiveQuestUI(quest: quest);
    }
  }

  Future navigateToActiveQuestUI({required Quest quest}) async {
    log.i("Navigating to view with currently active quest");
    final questViewIndex = quest.type == QuestType.DistanceEstimate ||
            quest.type == QuestType.VibrationSearch
        ? QuestViewType.singlequest
        : QuestViewType.map;
    // ALTERNATIVELY could set flag in quest_service so we don't
    // have to pass around the quest through all the views!!!
    // Would probably be cleaner!!
    await navigationService.navigateTo(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(
        userRole: currentUser.role,
        questViewIndex: questViewIndex,
        initialBottomNavBarIndex: BottomNavBarIndex.quest,
        quest: quest,
      ),
    );
  }

  Future scanQrCode() async {
    QuestQRCodeScanResult result = await navigateToQrcodeViewAndReturnResult();
    await handleQrCodeScanEvent(result);
  }

  Future<QuestQRCodeScanResult> navigateToQrcodeViewAndReturnResult() async {
    final marker = await navigationService.navigateTo(Routes.qRCodeView);
    if (userIsAdmin && marker != null) {
      final adminMode = await showAdminDialogAndGetResponse();
      if (adminMode) {
        String qrCodeString =
            _qrCodeService.getQrCodeStringFromMarker(marker: marker);
        await navigationService.navigateTo(Routes.qRCodeView,
            arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
        return QuestQRCodeScanResult.empty();
      }
    }
    QuestQRCodeScanResult scanResult =
        await questService.handleQrCodeScanEvent(marker: marker);
    return scanResult;
  }

  String getActiveQuestProgressDescription() {
    if (activeQuest.quest.type == QuestType.Hike ||
        activeQuest.quest.type == QuestType.Hunt ||
        activeQuest.quest.type == QuestType.Search) {
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
        activeQuest.quest.type == QuestType.Search) {
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
    } else if (activeQuest.quest.type == QuestType.VibrationSearch) {
      log.wtf(
          "Should never be called, this is handled in ActiveVibrationSearchQuestViewModel.");
    } else {
      lastActivatedQuestInfoText = "UNKNOWN QUEST RUNNING";
    }
    notifyListeners();
  }

  Future checkQuestAndFinishWhenCompleted(
      {bool force = false, bool showDialog = true}) async {
    try {
      dynamic result;
      try {
        setBusy(true);

        // Needed for vibration search
        questService.setUIDeadTime(true);
        result = await questService.evaluateAndFinishQuest(force: force);
        // Needed for vibration search
      } catch (e) {
        if (e is QuestServiceException) {
          baseModelLog.e(e);
          await dialogService.showDialog(
              title: e.prettyDetails, buttonTitle: 'Ok');
          replaceWithMainView(index: BottomNavBarIndex.quest);
          questService.setUIDeadTime(false);
        } else if (e is CloudFunctionsApiException) {
          baseModelLog.e(e);
          await dialogService.showDialog(
              title: e.prettyDetails, buttonTitle: 'Ok');
          questService.setUIDeadTime(false);
        } else {
          baseModelLog.e("Unknown error occured from evaluateAndFinishQuest");
          questService.setUIDeadTime(false);
          setBusy(false);
          rethrow;
        }
        setBusy(false);
        return false;
      }
      if (result is String) {
        DialogResponse<dynamic>? continueQuest;
        if (!force) {
          baseModelLog.w(
              "A warning or error occured when trying to finish the quest. The following warning was thrown: $result");
          continueQuest = await dialogService.showConfirmationDialog(
              title: result.toString(),
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

        await dialogService.showDialog(
            title: "Congratz, you succesfully finished the quest!",
            description: "Earned credits: " +
                questService.previouslyFinishedQuest!.quest.afkCredits
                    .toString() +
                ", time elapsed: " +
                _stopWatchService.secondsToHourMinuteSecondTime(
                    questService.previouslyFinishedQuest!.timeElapsed) +
                "; New balance: " +
                currentUserStats.afkCreditsBalance.toString(),
            buttonTitle: 'Ok');
        replaceWithMainView(index: BottomNavBarIndex.quest);
        questService.setUIDeadTime(false);
        setBusy(false);
        return true;
      }
      setBusy(false);
    } catch (e) {
      setBusy(false);
      await dialogService.showDialog(
          title: "An internal error occured on our side. Sorry!",
          buttonTitle: 'Ok');
      baseModelLog.wtf(
          "An error occured when trying to finish the quest. This should never happen! Error: $e");
      replaceWithMainView(index: BottomNavBarIndex.quest);
    }
  }

  ////////////////////////////
  // needs to be overrriden!
  // Future handleQrCodeScanEvent(QuestQRCodeScanResult result);
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result) async {
    if (result.isEmpty) {
      log.wtf("The object QuestQRCodeScanResult is empty!");
      return Future.value();
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
      dialogService.showDialog(
        title: "Failed to collect marker!",
        description: result.errorMessage!,
      );
    } else {
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
  }

  // Can be overridden!
  void resetQuest() {}

  //////////////////////////////////////////
  /// Clean-up
  ///
  void cancelQuestListener() {
    log.i("Cancelling subscription to vibration search quest");
    _activeQuestSubscription?.cancel();
    _activeQuestSubscription = null;
  }

  @override
  void dispose() {
    _activeQuestSubscription?.cancel();
    super.dispose();
  }
}
