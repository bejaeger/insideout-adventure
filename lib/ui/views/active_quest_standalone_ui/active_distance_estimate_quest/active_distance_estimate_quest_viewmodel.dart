import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/helpers/distance_check_status_model.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/distance_check_status.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ! Likely DEPRECATED

class ActiveDistanceEstimateQuestViewModel extends ActiveQuestBaseViewModel {
  // Instead of these functions here I should have override functions
  // That all work in QuestViewModel!

  final GeolocationService _geolocationService = locator<GeolocationService>();

  double? startingLat;
  double? startingLon;

  int numberTries = 0;
  double distanceTravelled = 0;
  late double distanceToTravel;
  int get numberOfAvailableTries => kNumberTriesToRevealDistance - numberTries;
  double get kMaxDeviationOfGoalInMeters =>
      distanceToTravel * kMaxDeviationOfGoalInPercent;
  // Finished Check!?

  double? _currentSpeed;
  double? get currentSpeed => _currentSpeed;
  int? get currentAccuracy => _geolocationService.currentGPSAccuracy;

  bool startedQuest = false;
  bool questSuccessfullyFinished = false;

  // User ACTION!
  Future probeDistance() async {
    if (numberOfAvailableTries == 1 && !useSuperUserFeatures) {
      final result = await dialogService.showDialog(
          title: "Last Try!",
          description: "Are you sure you want to reveal the distance?",
          buttonTitle: "YES",
          cancelTitle: "NO");
      if (result?.confirmed == false) {
        return;
      }
    }
    final Position currentPosition =
        await _geolocationService.getUserLivePosition;

    if (!(await checkAccuracy(
        position: currentPosition,
        minAccuracy: kMinRequiredAccuracyDistanceEstimate))) {
      return;
    }
    final distanceTravelledTest = _geolocationService.distanceBetween(
        lat1: currentPosition.latitude,
        lon1: currentPosition.longitude,
        lat2: startingLat,
        lon2: startingLon);
    numberTries = numberTries + 1;
    distanceTravelled = distanceTravelledTest;

    questTestingService.maybeRecordData(
        trigger: QuestDataPointTrigger.userAction,
        userEventDescription:
            "distance probed: ${distanceTravelled.toStringAsFixed(2)} m",
        pushToNotion: true,
        position: currentPosition);

    // distanceTravelled = 1;

    ////////////////////////////////////////////////////
    /// Temporary testing purposes
    if (useSuperUserFeatures) {
      _currentSpeed = _geolocationService.getUserLivePositionNullable?.speed;
    }

    // -----------------------------------------------------
    // We create a completer and parse it to the calculation below.
    // Then we display a pop-up that we give the completer as input.
    // The pop-up window shows a progress indicator and
    // displays a success or error dialog when the completer is completed
    var distanceCheckCompleter = Completer<DistanceCheckStatus>();
    try {
      _evaluateDistanceTravelled(
          distanceTravelled: distanceTravelled,
          completer: distanceCheckCompleter);
    } catch (e) {
      log.wtf("Something very mysterious went wrong, error thrown: $e");
      distanceCheckCompleter.complete(DistanceCheckStatus.internalFailure);
    }

    final result = await _showDistanceCheckDialog(
        completer: distanceCheckCompleter,
        distanceTravelled: distanceTravelled);

    if (result?.confirmed == true) {
      // this means everything went fine!
      // Show statistics display
      questSuccessfullyFinished = true;
    }

    if (activeQuestNullable?.status == QuestStatus.failed) {
      if (useSuperUserFeatures) {
        log.i("You are in admin mode and have infinite tries!");
      } else {
        log.i("Found that quest failed! cancelling incomplete quest");
        await activeQuestService.cancelIncompleteQuest();
        replaceWithMainView(index: BottomNavBarIndex.quest);
      }
    }

    notifyListeners();
  }

  @override
  bool isQuestCompleted(
      {double distanceTravelled = 0, double distanceToTravel = 999999}) {
    if (flavorConfigProvider.dummyQuestCompletionVerification) {
      return true;
    } else {
      return (distanceTravelled >
              (distanceToTravel - kMinDistanceToCatchTrophyInMeters) &&
          distanceTravelled <
              (distanceToTravel + kMinDistanceToCatchTrophyInMeters));
    }
  }

  // evaluates the distance and and completes the completer for the
  // dialog to update
  Future _evaluateDistanceTravelled(
      {required double distanceTravelled,
      required Completer<DistanceCheckStatus> completer}) async {
    // artificial delay to make it exciting for user!
    await Future.delayed(Duration(seconds: 1));

    final completed = isQuestCompleted(
        distanceToTravel: distanceToTravel,
        distanceTravelled: distanceTravelled);
    if (completed) {
      // additional delay!
      await Future.delayed(Duration(seconds: 1));
      log.i("SUCCESS! Successfully estimated $distanceToTravel");
      activeQuestService.setSuccessAsQuestStatus();
      completer.complete(DistanceCheckStatus.success);
      return;
    } else {
      if (numberOfAvailableTries <= 0) {
        activeQuestService.setAndPushActiveQuestStatus(QuestStatus.failed);
        completer.complete(DistanceCheckStatus.failed);
      } else {
        if (distanceTravelled < distanceToTravel) {
          completer.complete(DistanceCheckStatus.notenough);
        } else {
          completer.complete(DistanceCheckStatus.toofar);
        }
      }
    }
    return;
  }

  Future _showDistanceCheckDialog(
      {required Completer<DistanceCheckStatus> completer,
      required double distanceTravelled}) async {
    log.i("We are starting the dialog");
    final dialogResult = await dialogService.showCustomDialog(
      variant: DialogType.CheckTravelledDistance,
      data: {
        "distanceCheckStatus": DistanceCheckStatusModel(
          futureStatus: completer.future,
          distanceInMeter: distanceTravelled,
        ),
        "quest": activeQuest,
      },
    );
    return dialogResult;
  }

  @override
  Future initialize({required Quest quest}) async {
    super.initialize(quest: quest);
    resetPreviousQuest();
    distanceToTravel = quest.distanceToTravelInMeter!;
  }

  // 1. Start quest
  @override
  Future maybeStartQuest(
      {required Quest? quest, void Function()? notifyParentCallback}) async {
    if (quest != null) {
      resetPreviousQuest();
      if (quest.distanceToTravelInMeter == null) {
        await showGenericInternalErrorDialog();
        replaceWithMainView(index: BottomNavBarIndex.quest);
        return;
      }
      log.i("Starting distance estimate quest with name ${quest.name}");
      final position = await _geolocationService.getUserLivePosition;
      if (!(await checkAccuracy(
          position: position,
          minAccuracy: kMinRequiredAccuracyDistanceEstimate))) {
        if (await useSuperUserFeature()) {
          snackbarService.showSnackbar(
              title: "Starting quest as super user",
              message:
                  "Although accuracy is low: ${position.accuracy.toStringAsFixed(0)}");
        } else {
          await resetSlider();
          return false;
        }
      }
      log.i(
          "Starting quest by setting initial position to lat = $startingLat, lon = $startingLon");
      startingLat = position.latitude;
      startingLon = position.longitude;

      final result = await startQuestMain(quest: quest);
      if (result == false) {
        return;
      }
      log.v("Started quest");
      // start listener that updates position regularly
      activeQuestService.listenToPosition(
          distanceFilter: kDistanceFilterDistanceEstimate, pushToNotion: true);
      //await Future.delayed(Duration(seconds: 1));
      startedQuest = true;
      notifyListeners();
    } else {
      log.i("Not starting quest, quest is probably already running");
    }
  }

  // Future showInstructions() async {
  //   await dialogService.showDialog(
  //       title: "How it works",
  //       description:
  //           "Start the quest and then walk ${distanceToTravel.toStringAsFixed(0)} meters (air distance). If you think the distance is correct, check it. You only have $kNumberTriesToRevealDistance tries!");
  // }

  @override
  void resetPreviousQuest() {
    distanceTravelled = 0;
    numberTries = 0;
    startedQuest = false;
    super.resetPreviousQuest();
  }

  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }
}
