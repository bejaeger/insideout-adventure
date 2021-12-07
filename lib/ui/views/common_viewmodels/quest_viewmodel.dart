import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class QuestViewModel extends BaseModel {
  final log = getLogger("QuestViewModel");
  StreamSubscription? _activeQuestSubscription;
  String lastActivatedQuestInfoText = "Active Quest";
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  QuestViewModel() {
    // listen to changes in wallet
    _activeQuestSubscription = questService.activatedQuestSubject.listen(
      (stats) {
        if (stats?.status == QuestStatus.active ||
            stats?.status == QuestStatus.incomplete) {
          // TODO: make this more general! UI response to quest actions!
          // similar to 'trackData' or 'trackDataVibrationSearch' in quest_service
          getActivatedQuestInfoText();
        }

        notifyListeners();
      },
    );
  }

  Future scanQrCodeWithActiveQuest() async {
    QuestQRCodeScanResult result = await navigateToQrcodeViewAndReturnResult();
    await handleQrCodeScanEvent(result);
  }

  Future<QuestQRCodeScanResult> navigateToQrcodeViewAndReturnResult() async {
    final marker = await navigationService.navigateTo(Routes.qRCodeView);
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
  Future getActivatedQuestInfoText() async {
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
      if (activeQuest.lastDistanceInMeters == null ||
          activeQuest.currentDistanceInMeters == null) {
        lastActivatedQuestInfoText = "Vibration Search: No info available";
      } else {
        if (activeQuest.currentDistanceInMeters! <
            kMinDistanceToCatchTrophyInMeters) {
          // This should collect the NEXT marker!!

          // TODO: Make this proper here!
          // Show loading screen, show that the quest is gonna be pushed!
          // ! (What if there is no data connection? Sill need to be able to push the data later on!)

          // This will show a dialog from a viewmodel that is not attached to a view!
          // need to think of something better here!
          // - Maybe when starting a quest from a map we can navigate with an argument that STARTS a quest
          // this would give the authority to the quest model that is actually the active quest
          // - OR: have quest_viewmodel as singleton!
          // - OR: move everything that is here to active_quest_viewmodel and extend to active_quest_viewmodel and make this a singleton!
          questService.setActiveQuestStatus(QuestStatus.success);
          questService.isDeadTime = true;
          baseModelLog.i("SUCCESFFULLY FOUND trophy");
          await dialogService.showDialog(
              title: "SUCCESS!", description: "You found the trophy!");
          setBusy(true);
          await checkQuestAndFinishWhenCompleted();
          setBusy(false);
          return;
        }
        if (activeQuest.lastDistanceInMeters! >
            activeQuest.currentDistanceInMeters!) {
          await vibrateRightDirection();
          lastActivatedQuestInfoText = "On Last Check: getting closer!";
        } else {
          await vibrateWrongDirection();
          lastActivatedQuestInfoText = "On Last Check: getting further away!";
        }
      }
    } else {
      lastActivatedQuestInfoText = "UNKNOWN QUEST RUNNING";
    }
    notifyListeners();
  }

  Future vibrateWrongDirection() async {
    // Check if the device can vibrate
    if (canVibrate == null) {
      canVibrate = await Vibrate.canVibrate;
    } // Vibrate

    if (canVibrate!) {
      final Iterable<Duration> pauses = [
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 500),
      ];
      // vibrate - sleep 0.2s - vibrate - sleep 0.2s - vibrate - sleep 0.2s - vibrate
      Vibrate.vibrateWithPauses(pauses);
    }
  }

  Future vibrateRightDirection() async {
    // Check if the device can vibrate
    if (canVibrate == null) {
      canVibrate = await Vibrate.canVibrate;
    } // Vibrate
    if (canVibrate!) {
      // vibrate for default (500ms on android, about 500ms on iphone)
      Vibrate.vibrate();
    }
  }

  Future checkQuestAndFinishWhenCompleted({bool force = false}) async {
    try {
      dynamic result;
      try {
        setBusy(true);
        result = await questService.evaluateAndFinishQuest(force: force);
        setBusy(false);
      } catch (e) {
        setBusy(false);
        if (e is QuestServiceException) {
          baseModelLog.e(e);
          await dialogService.showDialog(
              title: e.prettyDetails, buttonTitle: 'Ok');
          replaceWithMainView(index: BottomNavBarIndex.map);
          return;
        } else if (e is CloudFunctionsApiException) {
          baseModelLog.e(e);
          await dialogService.showDialog(
              title: e.prettyDetails, buttonTitle: 'Ok');
          return;
        } else {
          baseModelLog.e("Unknown error occured from evaluateAndFinishQuest");
          rethrow;
        }
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
        }
        if (continueQuest?.confirmed == false || force) {
          await questService.cancelIncompleteQuest();
          replaceWithMainView(index: BottomNavBarIndex.map);
          baseModelLog.i("replaced view with mapView");
        }
      } else {
        if (questService.previouslyFinishedQuest == null) {
          baseModelLog.wtf(
              "Quest was successfully finished but previouslyFinishedQuest was not set! This should never happen and is due to an internal error in quest service..");
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
        replaceWithMainView(index: BottomNavBarIndex.map);
      }
    } catch (e) {
      setBusy(false);
      await dialogService.showDialog(
          title: "An internal error occured on our side. Sorry!",
          buttonTitle: 'Ok');
      baseModelLog.wtf(
          "An error occured when trying to finish the quest. This should never happen! Error: $e");
      replaceWithMainView(index: BottomNavBarIndex.map);
    }
  }

  ////////////////////////////
  // needs to be overrriden!
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result);

  //////////////////////////////////////////
  /// Clean-up
  @override
  void dispose() {
    _activeQuestSubscription?.cancel();
    super.dispose();
  }
}
