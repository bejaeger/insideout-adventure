import 'dart:async';
import 'dart:math';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/quests/treasure_search/treasure_search_location.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quests/direction_status.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Singleton ViewModel!

class ActiveTreasureLocationSearchQuestViewModel
    extends ActiveQuestBaseViewModel {
  final GeolocationService _geolocationService = locator<GeolocationService>();

  double? get currentGPSAccuracy => _geolocationService.currentGPSAccuracy;
  StreamSubscription? _activeVibrationQuestSubscription;
  DirectionStatus directionStatus = DirectionStatus.notstarted;
  bool isTrackingDeadTime = false;
  bool skipUpdatingQuestStatus = false;
  bool isCheckingDistance = false;
  final MarkerService _markerService = locator<MarkerService>();

  List<TreasureSearchLocation> checkpoints = [];
  final log = getLogger("ActiveTreasureLocationSearchQuestViewModel");

  bool? closeby;
  double currentDistanceInMeters = -1;
  double previousDistanceInMeters = -1;
  int numberTimesFired = 0;
  bool get firedOnce => numberTimesFired > 0;
  bool allowCheckingPosition = true;

  void initialize({required Quest quest}) async {
    setBusy(true);
    resetPreviousQuest();
    // await runBusyFuture(_geolocationService.getAndSetCurrentLocation());
    closeby = await _markerService.isUserCloseby(marker: quest.startMarker);
    loadQuestMarkers(quest: quest);
    // await setInitialDistance(quest: quest);
    setBusy(false);
  }

  // AUTOMATIC TRACKING
  void listenToActiveQuest() {
    log.i("Add listener to active vibration search quest");
    if (_activeVibrationQuestSubscription == null) {
      _activeVibrationQuestSubscription =
          questService.activatedQuestSubject.listen(
        (activatedQuest) {
          log.wtf("Listening to quest update");
          if (activatedQuest?.status == QuestStatus.active ||
              activatedQuest?.status == QuestStatus.incomplete) {
            if (!skipUpdatingQuestStatus) {
              completeDistanceCheckAndUpdateQuestStatus();
              skipUpdatingQuestStatus = false;
            }
          }
          if (activatedQuest?.status == QuestStatus.success ||
              activatedQuest?.status == QuestStatus.cancelled ||
              activatedQuest?.status == QuestStatus.failed) {
            cancelQuestListener();
          }
          notifyListeners();
        },
      );
    }
  }

  Future maybeStartQuest({required Quest? quest}) async {
    if (quest != null) {
      log.i("Starting vibration search quest with name ${quest.name}");
      if (quest.type == QuestType.TreasureLocationSearchAutomatic) {
        listenToActiveQuest();
      }

      final position = await _geolocationService.getAndSetCurrentLocation(
          forceGettingNewPosition: false);
      if (!(await checkAccuracy(
          position: position,
          minAccuracy: kMinRequiredAccuracyLocationSearch))) {
        if (isSuperUser) {
          final result = await showAdminDialogAndGetResponse();
          if (result == true) {
            snackbarService.showSnackbar(
                title: "Starting quest as super user",
                message:
                    "Although accuracy is low: ${position.accuracy.toStringAsFixed(0)}");
          } else {
            await resetSlider();
            return false;
          }
        } else {
          await resetSlider();
          return false;
        }
      }

      dynamic result;
      // Two modes
      // 1.  automatic loop to check distance every 5 seconds:
      if (quest.type == QuestType.TreasureLocationSearchAutomatic) {
        result = await startQuestMain(
            quest: quest, periodicFuncFromViewModel: periodicUpdate);
      } else {
        // 2. manual checking!
        result = await startQuestMain(quest: quest);
      }
      if (result is bool && result == false) {
        navigateBack();
        return;
      }
      // await setInitialDistance(quest: quest);
      // addMarkerToMap(
      //     quest: quest,
      //     afkmarker: AFKMarker(
      //         id: "checkpoint " + checkpoints.length.toString(),
      //         qrCodeId: "checkpoint " + checkpoints.length.toString(),
      //         lat: checkpoints.last.currentLat,
      //         lon: checkpoints.last.currentLon));
      await Future.delayed(Duration(seconds: 1));
      showStartSwipe = false;
      notifyListeners();
    } else {
      log.i("Not starting quest, quest is probably already running");
    }
  }

  @override
  bool isQuestCompleted() {
    // return true;
    if (!hasActiveQuest) {
      log.wtf(
          "No quest is active! This function should have never been called!");
      return false;
    } else {
      // option to add dummy checks for testing purposes
      if (flavorConfigProvider.dummyQuestCompletionVerification) {
        return currentDistanceInMeters < 9999; // 9999;
      } else {
        // this is the true check configured in constants.dart
        return currentDistanceInMeters < kMinDistanceToCatchTrophyInMeters;
      }
    }
  }

  Future completeDistanceCheckAndUpdateQuestStatus() async {
    final completed = isQuestCompleted();
    if (completed) {
      // quest succesfully completed
      await showFoundTreasureDialog();
      await showSuccessDialog();
      return;
    }
    // update UI on quest update
    if (checkpoints.elementAt(checkpoints.length - 2).distanceToGoal >
        checkpoints.last.distanceToGoal) {
      await vibrateRightDirection();
      // directionStatus = "Getting closer!";
      directionStatus = DirectionStatus.closer;
    } else {
      await vibrateWrongDirection();
      directionStatus = DirectionStatus.further;
    }
    notifyListeners();
  }

  @override
  void resetPreviousQuest() {
    cancelQuestListener();
    markersOnMap = {};
    checkpoints = [];
    directionStatus = DirectionStatus.notstarted;
    questSuccessfullyFinished = false;
    currentDistanceInMeters = -1;
    previousDistanceInMeters = -1;
    numberTimesFired = 0;
    setTrackingDeadTime(false);
    setIsCheckingDistance(false);
    setAllowCheckingPosition(true);
    super.resetPreviousQuest();
  }

  void setAllowCheckingPosition(bool allow) {
    log.v("Set allow checking position");
    allowCheckingPosition = allow;
  }

  Future setInitialDistance({required Quest? quest}) async {
    if (quest == null) return;
    await _geolocationService.listenToPosition(callback: () {
      setAllowCheckingPosition(true);
      notifyListeners();
    });
    final position = await _geolocationService.getUserLivePosition;
    final newDistanceInMeters = _geolocationService.distanceBetween(
      lat1: position.latitude,
      lon1: position.longitude,
      lat2: quest.finishMarker?.lat,
      lon2: quest.finishMarker?.lon,
    );
    checkpoints.add(TreasureSearchLocation(
        distanceToGoal: newDistanceInMeters,
        currentLat: position.latitude,
        currentLon: position.longitude,
        currentAccuracy: position.accuracy));
    previousDistanceInMeters = currentDistanceInMeters;
    currentDistanceInMeters = newDistanceInMeters;
    log.i(
        "Setting initial data for Treasure Search Quest $newDistanceInMeters meters");
    numberTimesFired++;
    //questService.pushActivatedQuest(tmpActivatedQuest);
  }

  Future checkNewLocation() async {
    if (questService.activatedQuest == null) {
      log.wtf("No quest is active to check distance to finish line");
      return "No quest is currently active, please start the quest first";
    }
    ActivatedQuest tmpActivatedQuest = questService.activatedQuest!;
    if (isTrackingDeadTime) {
      log.v("Skipping distance to goal check because tracking dead time is on");
      return "You can't check the distance at the moment because other processes are running";
    }

    // TODO: Think whether we should rather use the NEW Current location and
    // restart the listener so it fires after another "DISTANCEFILTER" distance
    final position = await _geolocationService.getUserLivePosition;
    // if (!await checkAccuracy(
    //     position: position,
    //     showDialog: false,
    //     minAccuracy: kMinRequiredAccuracyLocationSearch)) {
    //   // TODO: Think if I should try to retrieve CURRENT position once /
    //   log.v(
    //       "Accuracy is ${position.accuracy} and not enough to take next point!");
    //   // setSkipUpdatingQuestStatus(true);
    //   return "GPS Accuracy low, walk further";
    //   // return "GPS Accuracy low, please walk futher and try again";
    // }

    // final bool allow = isDistanceCheckAllowed(newPosition: position);
    // DUMMY
    // if (allow || flavorConfigProvider.dummyQuestCompletionVerification) {
    if (true) {
      setSkipUpdatingQuestStatus(false);

      // check distance to goal!
      final newDistanceInMeters = getNewDistanceToGoal(newPosition: position);
      addCheckpoint(newPosition: position);
      log.i("Updating distance to goal to $newDistanceInMeters meters");
      return true;
    }
    // else {
    //   log.v("Not checking distance to goal!");
    //   return "Walk further";
    // }
  }

  Future checkDistance() async {
    if (!firedOnce) {
      if (hasActiveQuest) {
        setIsCheckingDistance(true);
        await Future.wait([
          setInitialDistance(quest: activeQuest.quest),
          artificialDelay(),
        ]);
        addMarkerToMap(
            quest: activeQuest.quest,
            afkmarker: AFKMarker(
                id: "checkpoint " + checkpoints.length.toString(),
                qrCodeId: "checkpoint " + checkpoints.length.toString(),
                lat: checkpoints.last.currentLat,
                lon: checkpoints.last.currentLon));
        setIsCheckingDistance(false);
        setAllowCheckingPosition(false);
        numberTimesFired++;
        directionStatus = DirectionStatus.unknown;
        notifyListeners();
        return;
      }
    }
    setIsCheckingDistance(true);
    notifyListeners();
    final results = await Future.wait([
      checkNewLocation(),
      artificialDelay(),
    ]);
    if (results[0] is String) {
      // show string on UI, else update distances
      directionStatus = DirectionStatus.denied;
      // directionStatus = results[0];
      showWalkFurtherSnackbar();
      notifyListeners();
    } else if (results[0] is bool && results[0] == true) {
      if (results[0] is bool && results[0] == true) {
        addMarkerToMap(
            quest: activeQuest.quest,
            afkmarker: AFKMarker(
                id: "checkpoint " + checkpoints.length.toString(),
                qrCodeId: "checkpoint " + checkpoints.length.toString(),
                lat: checkpoints.last.currentLat,
                lon: checkpoints.last.currentLon));
        completeDistanceCheckAndUpdateQuestStatus();
      }
    } else {
      log.wtf(
          "Checking new location returned 'false' or something unknwon! Check code!");
    }
    // await Future.delayed(
    //     Duration(seconds: kCheckDistanceReloadDurationInSeconds));
    setIsCheckingDistance(false);
    setAllowCheckingPosition(false);
    notifyListeners();
  }

  void addCheckpoint({required Position newPosition}) {
    double newDistance = getNewDistanceToGoal(newPosition: newPosition);
    double distanceToPreviousCheckpoint =
        getDistanceToPreviousCheckpoint(newPosition: newPosition);
    checkpoints.add(TreasureSearchLocation(
      distanceToGoal: newDistance,
      distanceToPreviousPosition: distanceToPreviousCheckpoint,
      currentLat: newPosition.latitude,
      currentLon: newPosition.longitude,
      currentAccuracy: newPosition.accuracy,
      previousLat: checkpoints.last.currentLat,
      previousLon: checkpoints.last.currentLon,
      previousAccuracy: checkpoints.last.currentAccuracy,
    ));
    previousDistanceInMeters = currentDistanceInMeters;
    currentDistanceInMeters = newDistance;
  }

  double getNewDistanceToGoal({required Position newPosition}) {
    if (activeQuestNullable != null) {
      final newDistanceInMeters = _geolocationService.distanceBetween(
        lat1: newPosition.latitude,
        lon1: newPosition.longitude,
        lat2: activeQuestNullable!.quest.finishMarker?.lat,
        lon2: activeQuestNullable!.quest.finishMarker?.lon,
      );
      return newDistanceInMeters;
    } else {
      log.wtf("No active quest!");
      showGenericInternalErrorDialog();
      return -1;
    }
  }

  double getDistanceToPreviousCheckpoint({required Position newPosition}) {
    if (activeQuestNullable != null) {
      final distance = _geolocationService.distanceBetween(
        lat1: newPosition.latitude,
        lon1: newPosition.longitude,
        lat2: checkpoints.last.currentLat,
        lon2: checkpoints.last.currentLon,
      );
      return distance;
    } else {
      log.wtf("No active quest!");
      showGenericInternalErrorDialog();
      return -1;
    }
  }

  // check whether distance can be checked based on accuracy,
  // distance to last check, and quest configuration
  bool isDistanceCheckAllowed({required Position newPosition}) {
    if (questService.activatedQuest == null) {
      log.wtf("no quest active at the moment");
      return false;
    }
    // check how far user went when last check happened!
    final distanceFromLastCheck =
        getDistanceToPreviousCheckpoint(newPosition: newPosition);

    // treats accuracy as uncorrelated (conservative approach!)
    double propagatedAccuracy = getPropagatedAccuracy(newPosition: newPosition);

    propagatedAccuracy = propagatedAccuracy *
        0.7; // assume that there is some correlation between the two points
    // clamp it to between 30 and 80 to have some consistency.
    double minDistanceFromLastCheck = propagatedAccuracy.clamp(10, 80);

    double? lastDistanceToGoal =
        questService.activatedQuest!.lastDistanceInMeters;
    late bool allow;
    if (lastDistanceToGoal != null) {
      // to allow for more chances to check closer to the finish line to increase
      // chances that due to fluctuations the trophy is found and the user does not get stuck
      // and frustrated when being close to the goal!
      allow = distanceFromLastCheck >
          minDistanceFromLastCheck * (lastDistanceToGoal / 200).clamp(0.25, 1);
    } else {
      allow = distanceFromLastCheck > minDistanceFromLastCheck;
    }
    if (allow) {
      log.v(
          "Allowing distance check! Distance from last check: ${distanceFromLastCheck.toStringAsFixed(0)}. Propagated accuracy: ${propagatedAccuracy.toStringAsFixed(0)}.");
      return true;
    }
    log.v(
        "Not allowing distance check! Distance from last check: ${distanceFromLastCheck.toStringAsFixed(0)}. Propagated accuracy: ${propagatedAccuracy.toStringAsFixed(0)}.");
    return false;
  }

  // returns propagated accuracy from last two points by treating it as uncorrelated
  // -> Very Conservative -> maybe too conservative
  double getPropagatedAccuracy({required Position newPosition}) {
    double prevAcc = checkpoints.last.currentAccuracy;
    double newAcc = newPosition.accuracy;
    return sqrt(prevAcc * prevAcc + newAcc * newAcc);
  }

  void setIsCheckingDistance(bool check) {
    isCheckingDistance = check;
  }

  Future periodicUpdate(int seconds) async {
    if (questService.activatedQuest != null) {
      //void updateTime(int seconds) {

      // set initial data!
      // if (seconds == 1) {
      //   setInitialDistance();
      // }
      dynamic push;
      if (seconds % 5 == 0) {
        push = await checkNewLocation();
        // if (push is String) {
        //   directionStatus = push;
        //   notifyListeners();
        // }
        questService.updateTimeOnQuest(questService.activatedQuest!, seconds);
      }

      // push quest
      if (push is bool && push == true) {
        setTrackingDeadTime(true);
        await Future.delayed(
            Duration(seconds: kDeadTimeAfterVibrationInSeconds));
        if (questService.activatedQuest!.status != QuestStatus.success)
          setTrackingDeadTime(false);
      }

      // Cancel after long time
      if (seconds >= kMaxQuestTimeInSeconds) {
        log.wtf(
            "Cancel quest after $kMaxQuestTimeInSeconds seconds, it was probably forgotten that the quest is still running!");
        // TODO: Could also be override function
        await cancelIncompleteQuest();
        return;
      }
    }
  }

  //-------------------------------------------
  // Helper

  Future vibrateWrongDirection() async {
    await checkCanVibrate();
    if (canVibrate!) {
      final Iterable<Duration> pauses = [
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 500),
      ];
      log.v("Phone is supposed to vibrate now");
      // vibrate - sleep 0.2s - vibrate - sleep 0.2s - vibrate - sleep 0.2s - vibrate
      Vibrate.vibrateWithPauses(pauses);
    }
  }

  Future vibrateRightDirection() async {
    // Check if the device can vibrate
    await checkCanVibrate();
    if (canVibrate!) {
      log.v("Phone is supposed to vibrate now");
      // vibrate for default (500ms on android, about 500ms on iphone)
      Vibrate.vibrate();
      Vibrate.feedback(FeedbackType.success);
    }
  }

  Future checkCanVibrate() async {
    if (canVibrate == null) {
      canVibrate = await Vibrate.canVibrate;
      if (canVibrate!) {
        log.i("Phone is able to vibrate");
      } else {
        log.w("Phone is not able to!");
      }
    }
  }

  Future showInstructions() async {
    await dialogService.showDialog(
        title: "How it works",
        description:
            "Start to walk and check the distance to the trophy regularly. You will see if you get closer or are further away! The trohphy is clever and sometimes moves around!!");
  }

  Future cancelIncompleteQuest() async {
    setTrackingDeadTime(false);
    await questService.cancelIncompleteQuest();
  }

  void setTrackingDeadTime(bool deadTime) {
    log.v("Setting quest data tracking dead time to $deadTime");
    isTrackingDeadTime = deadTime;
  }

  void setSkipUpdatingQuestStatus(bool skipUpdate) {
    log.v("Setting skip react to activated quest change to $skipUpdate");
    skipUpdatingQuestStatus = skipUpdate;
  }

  ///////////////////////////////////////////////////
  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }

  void cancelQuestListener() {
    log.i("Cancelling subscription to vibration search quest");
    _activeVibrationQuestSubscription?.cancel();
    _activeVibrationQuestSubscription = null;
  }

  void showReloadingInfo() {
    snackbarService.showSnackbar(title: "Walk to reload", message: "...");
  }

  void showStartQuestInfo() {
    snackbarService.showSnackbar(title: "Start the quest first", message: "");
  }

  void showWalkFurtherSnackbar() {
    snackbarService.showSnackbar(
        title: "Walk Further", message: "", duration: Duration(seconds: 5));
  }

  @override
  void dispose() {
    cancelQuestListener();
    super.dispose();
  }

  Future artificialDelay() async {
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 1000));
    notifyListeners();
  }

  /////////////////////////////////////////
  ///////////////////////////////////////////
  ////////////////////////////////////////
  // Map functionality

  @override
  void loadQuestMarkers({Quest? quest}) {
    log.i("Loading quest markers");
    if (quest != null) {
      addMarkerToMap(quest: quest, afkmarker: quest.startMarker);
    } else {
      addMarkerToMap(
          quest: activeQuest.quest, afkmarker: activeQuest.quest.startMarker);
      log.v('These Are the values of the current Markers $markersOnMap');
    }
    notifyListeners();
  }

  @override
  void addMarkerToMap({required Quest quest, required AFKMarker? afkmarker}) {
    if (afkmarker == null) return;
    markersOnMap.add(
      Marker(
        markerId: MarkerId(afkmarker
            .id), // google maps marker id of start marker will be our quest id
        position: LatLng(afkmarker.lat!, afkmarker.lon!),
        infoWindow: InfoWindow(snippet: quest.name),
        icon: defineMarkersColour(quest: quest, afkmarker: afkmarker),
      ),
    );
    notifyListeners();
  }

  @override
  BitmapDescriptor defineMarkersColour(
      {required AFKMarker afkmarker, required Quest? quest}) {
    if (afkmarker == quest!.startMarker) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }
}
