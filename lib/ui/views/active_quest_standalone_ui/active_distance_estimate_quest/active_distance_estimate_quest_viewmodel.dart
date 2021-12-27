import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/helpers/distance_check_status_model.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/distance_check_status.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  double? get currentAccuracy => _geolocationService.currentGPSAccuracy;

  bool startedQuest = false;
  bool questSuccessfullyFinished = false;

  // User ACTION!
  Future revealDistance() async {
    if (numberOfAvailableTries == 1 && !isSuperUser) {
      final result = await dialogService.showDialog(
          title: "Sure?",
          description:
              "This is your last try, are you sure you want to reveal the distance?",
          buttonTitle: "Yes",
          cancelTitle: "No");
      if (result?.confirmed == false) {
        return;
      }
    }
    setBusy(true);
    final distanceTravelledTest = await _geolocationService
        .distanceBetweenUserAndCoordinates(lat: startingLat, lon: startingLon);
    if (!(await checkAccuracy(
        position: _geolocationService.getUserPosition,
        minAccuracy: kMinRequiredAccuracyDistanceEstimate))) {
      setBusy(false);
      return;
    }
    numberTries = numberTries + 1;
    distanceTravelled = distanceTravelledTest;
    setBusy(false);
    // distanceTravelled = 1;

    ////////////////////////////////////////////////////
    /// Temporary testing purposes
    if (isSuperUser) {
      _currentSpeed = _geolocationService.getUserPosition?.speed;
    }

    // -----------------------------------------------------
    // We create a completer and parse it to the pop-up window.
    // The pop-up window shows a progress indicator and
    // displays a success or error dialog when the completer is completed
    // in _processsPayment.
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
      if (isSuperUser) {
        log.i("You are in admin mode and have infinite tries!");
      } else {
        log.i("Found that quest failed! cancelling incomplete quest");
        await questService.cancelIncompleteQuest();
        replaceWithMainView(index: BottomNavBarIndex.quest);
      }
    }

    notifyListeners();
  }

  @override
  isQuestCompleted(
      {double distanceTravelled = 0, double distanceToTravel = 99999}) {
    if (flavorConfigProvider.dummyQuestCompletionVerification) {
      return (distanceTravelled > (distanceToTravel - 201) &&
          distanceTravelled < (distanceToTravel + 201));
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
      questService.setAndPushActiveQuestStatus(QuestStatus.success);
      completer.complete(DistanceCheckStatus.success);
      return;
    } else {
      if (numberOfAvailableTries <= 0) {
        questService.setAndPushActiveQuestStatus(QuestStatus.failed);
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

  void initialize({required Quest quest}) {
    resetPreviousQuest();
    distanceToTravel = quest.distanceToTravelInMeter!;
  }

  // 1. Start quest
  Future maybeStartQuest({required Quest? quest}) async {
    if (quest != null) {
      resetPreviousQuest();
      if (quest.distanceToTravelInMeter == null) {
        await showGenericInternalErrorDialog();
        replaceWithMainView(index: BottomNavBarIndex.quest);
        return;
      }
      setBusy(true);
      log.i("Starting distance estimate quest with name ${quest.name}");
      final position = await _geolocationService.getAndSetCurrentLocation();
      if (!(await checkAccuracy(
          position: position,
          minAccuracy: kMinRequiredAccuracyDistanceEstimate))) {
        setBusy(false);
        return;
      }
      log.i(
          "Starting quest by setting initial position to lat = $startingLat, lon = $startingLon");
      startingLat = position.latitude;
      startingLon = position.longitude;

      await startQuestMain(quest: quest);
      // snackbarService.showSnackbar(
      //     message: "Tagged position, you can start to walk now :)");
      setBusy(false);
      await Future.delayed(Duration(seconds: 1));
      startedQuest = true;
      notifyListeners();
    } else {
      log.i("Not starting quest, quest is probably already running");
    }
  }

  Future showInstructions() async {
    await dialogService.showDialog(
        title: "How it works",
        description:
            "Start the quest and then walk ${distanceToTravel.toStringAsFixed(0)} meters (air distance). If you think the distance is correct, check it. You only have $kNumberTriesToRevealDistance of tries!");
  }

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

  @override
  void addMarkerToMap({required Quest quest, required AFKMarker afkmarker}) {
    // TODO: implement addMarkerToMap
  }

  @override
  void loadQuestMarkers() {
    // TODO: implement loadQuestMarkers
  }

  @override
  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest}) {
    // TODO: implement defineMarkersColour
    throw UnimplementedError();
  }
}
