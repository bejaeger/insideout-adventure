import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/helpers/distance_check_status_model.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/enums/distance_check_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_common_dialog_viewmodel.dart';

class TravelledDistanceDialogViewModel extends QuestCommonDialogViewModel {
  final log = getLogger("TravelledDistanceDialogViewModel");
  DistanceCheckStatusModel? distanceCheckStatusModel;
  DistanceCheckStatus? distanceCheckStatus;

  CollectCreditsStatus status;
  TravelledDistanceDialogViewModel({required this.status})
      : super(status: status);

  String? title;
  String? description;
  String? mainButtonTitle;
  String? secondaryButtonTitle;

  waitForProcess({required dynamic request}) async {
    if (request.data["distanceCheckStatus"] == null) {
      log.w(
          "Somehow the completer could not be parsed to distance check dialog!");
      _setStatusText(DistanceCheckStatus.warning, request);
    } else {
      setBusy(true);
      distanceCheckStatusModel = request.data["distanceCheckStatus"]!;
      await _waitForTransferAndSetStatusText(
          distanceCheckStatusModel!, request);
      setBusy(false);
    }
  }

  Future _waitForTransferAndSetStatusText(
      DistanceCheckStatusModel distanceCheckStatusModel,
      dynamic request) async {
    distanceCheckStatus = await distanceCheckStatusModel.futureStatus;
    _setStatusText(distanceCheckStatus!, request,
        distanceCheckStatusModel.distanceInMeter);
  }

// TODO: Ultimately put in app strings file!
  void _setStatusText(DistanceCheckStatus distanceCheckStatus, dynamic request,
      [double? distanceInMeter]) {
    String addString = "";
    if (distanceInMeter != null) {
      addString = "You walked " +
          getDistance(distanceInMeter) +
          " of " +
          getDistanceToTravel() +
          " Meters. ";
    }
    if (distanceCheckStatus == DistanceCheckStatus.almost) {
      title = "You are almost there!";
      description = addString; // + "Try again in the next try";
      mainButtonTitle = "Got it";
    } else if (distanceCheckStatus == DistanceCheckStatus.toofar) {
      title = "Too far!";
      description = addString; //  + "You went slightly too far, try again!";
      mainButtonTitle = "Got it";
    } else if (distanceCheckStatus == DistanceCheckStatus.notenough) {
      title = "Not there yet!";
      description =
          addString; //  + "You still have some way to go, try again!";
      mainButtonTitle = "Got it";
    } else if (distanceCheckStatus == DistanceCheckStatus.success) {
      title = "SUCCESS";
      description = addString +
          "You earned " +
          request.data["quest"].quest.afkCredits.toStringAsFixed(0) +
          " AFK Credits!";
      mainButtonTitle = "Get Credits!";
    } else if (distanceCheckStatus == DistanceCheckStatus.failed) {
      log.i(
          "The order was succesfull but there was no pre-purchased gift card available!");
      title = "Unsuccesful";
      description =
          addString + "Unfortunately, you didn't succeed this time, try again!";
      mainButtonTitle = "Got it";
    } else {
      title = "Error";
      description = addString +
          "Distance check not successfull. Are you sure you have GPS activated?";
      mainButtonTitle = "Go Back";
    }
  }

  String getDistance(double distanceInMeter) {
    return distanceInMeter.toStringAsFixed(0);
  }

  String getDistanceToTravel() {
    return activeQuest.quest.distanceToTravelInMeter!.toStringAsFixed(0);
  }
}
