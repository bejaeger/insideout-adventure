import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/layout/bottom_bar_layout_view.dart';

abstract class QuestViewModel extends BaseModel {
  final _stopWatchService = locator<StopWatchService>();

  final log = getLogger("QuestViewModel");
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

  // needs to be overrriden!
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result);

  Future checkQuestAndFinishWhenCompleted() async {
    try {
      dynamic result;
      try {
        setBusy(true);
        result = await questService.evaluateAndFinishQuest();
        setBusy(false);
      } catch (e) {
        setBusy(false);
        if (e is QuestServiceException) {
          await dialogService.showDialog(
              title: e.prettyDetails, buttonTitle: 'Ok');
          replaceWithMainView(index: BottomNavBarIndex.map);
          return;
        } else if (e is CloudFunctionsApiException) {
          await dialogService.showDialog(
              title: e.prettyDetails, buttonTitle: 'Ok');
          return;
        } else {
          log.e("Unknown error occured from evaluateAndFinishQuest");
          rethrow;
        }
      }
      if (result is String) {
        log.w(
            "A warning or error occured when trying to finish the quest. The following warning was thrown: $result");
        final continueQuest = await dialogService.showConfirmationDialog(
            title: result.toString(),
            cancelTitle: "Cancel Quest",
            confirmationTitle: "Continue Quest");

        if (continueQuest?.confirmed == true) {
          await questService.continueIncompleteQuest();
        } else {
          await questService.cancelIncompleteQuest();
          replaceWithMainView(index: BottomNavBarIndex.map);
          log.i("replaced view with mapView");
        }
      } else {
        if (questService.previouslyFinishedQuest == null) {
          log.wtf(
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
      log.wtf(
          "An error occured when trying to finish the quest. This should never happen! Error: $e");
      replaceWithMainView(index: BottomNavBarIndex.map);
    }
  }


}
