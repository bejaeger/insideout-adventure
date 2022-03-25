import 'dart:async';
import 'dart:math';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/quests/treasure_search/treasure_search_location.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quests/direction_status.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Singleton ViewModel!

class ActiveTreasureLocationSearchQuestViewModel
    extends ActiveQuestBaseViewModel {
  final GeolocationService _geolocationService = locator<GeolocationService>();

  int? get currentGPSAccuracy => _geolocationService.currentGPSAccuracy;
  StreamSubscription? _activeVibrationQuestSubscription;
  DirectionStatus directionStatus = DirectionStatus.notstarted;
  bool isTrackingDeadTime = false;
  bool skipUpdatingQuestStatus = false;
  bool isCheckingDistance = false;
  bool isNearGoal = false;

  List<TreasureSearchLocation> checkpoints = [];
  final log = getLogger("ActiveTreasureLocationSearchQuestViewModel");

  double currentDistanceInMeters = -1;
  double previousDistanceInMeters = -1;
  int numberTimesFired = 0;
  bool get isFirstDistanceCheck => numberTimesFired == 0;
  bool allowCheckingPosition = true;

  // markers on map
  Set<Marker> markersOnMap = {};

  @override
  Future initialize({required Quest quest}) async {
    setBusy(true);
    await super.initialize(quest: quest);
    // Add listener with a small distance filter to get most precise
    // start position!
    resetPreviousQuest();
    loadQuestMarkers(quest: quest);
    // await setInitialDistance(quest: quest);
    setBusy(false);
  }

  Future maybeStartQuest(
      {required Quest? quest, void Function()? onStartQuestCallback}) async {
    if (quest != null) {
      log.i("Starting vibration search quest with name ${quest.name}");

      final position = await _geolocationService.getUserLivePosition;
      if (!(await checkAccuracy(
          position: position,
          minAccuracy: kMinRequiredAccuracyLocationSearch))) {
        if (useSuperUserFeatures) {
          if (await useSuperUserFeature()) {
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
      result = await startQuestMain(quest: quest);

      if (result is bool && result == false) {
        navigateBack();
        return;
      }

      if (onStartQuestCallback != null) {
        onStartQuestCallback();
      }
      showStartSwipe = false;
      mapViewModel.resetMapMarkers();
      // quest started!
      // start listening to position
      await Future.wait([
        activeQuestService.listenToPosition(
            distanceFilter: kMinDistanceFromLastCheckInMeters,
            pushToNotion: true,
            recordPositionDataEvent: false,
            // skipFirstStreamEvent: true,

            // Maybe we should add a filterGPSData function that only
            // allows the user to check location based on certain conditions
            viewModelCallback: (position) {
              if (allowCheckingPosition == false) {
                if (isUpdatingPositionAllowed(position: position)) {
                  setAllowCheckingPosition(true);
                  notifyListeners();
                }
              }
              // TODO: Should probably happen more often!
              // this will move the map. Should happen more often than is the
              // case for the treasure location search! Add additional filtering!?
              setNewLatLon(lat: position.latitude, lon: position.longitude);
              animateOnNewLocation();
            }),
        Future.delayed(Duration(seconds: 1))
      ]);
      snackbarService.showSnackbar(
          title: "Quest started", message: "Check your initial distance");

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
        return true;
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

      // TODO: Could start uploading credits already here!
      // TODO: And pass a "inProgress" status to showSuccessDialog() plus a completer!

      await showFoundTreasureDialog();
      directionStatus = DirectionStatus.nearGoal;
      showNextARObjects();
      notifyListeners();
      // await showSuccessDialog();

    } else {
      late String? logString;
      // update UI on quest update
      if (checkpoints.elementAt(checkpoints.length - 2).distanceToGoal >
          checkpoints.last.distanceToGoal) {
        await vibrateRightDirection();
        // directionStatus = "Getting closer!";
        directionStatus = DirectionStatus.closer;
        logString =
            "Updated: Right direction (${checkpoints.last.distanceToGoal.toStringAsFixed(2)} m left)";
      } else {
        await vibrateWrongDirection();
        directionStatus = DirectionStatus.further;
        logString =
            "Updated: Wrong direction (${checkpoints.last.distanceToGoal.toStringAsFixed(2)} m left)";
      }
      notifyListeners();
      // TODO push quest event
      questTestingService.maybeRecordData(
        trigger: QuestDataPointTrigger.userAction,
        userEventDescription: logString,
        pushToNotion: true,
      );
    }
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
    questTestingService.maybeRecordData(
      trigger: QuestDataPointTrigger.userAction,
      userEventDescription:
          "Initial distance: ${currentDistanceInMeters.toStringAsFixed(2)} m",
      pushToNotion: true,
    );
  }

  Future fetchNewPosition() async {
    if (activeQuestService.activatedQuest == null) {
      log.wtf("No quest is active to check distance to finish line");
      return "No quest is currently active, please start the quest first";
    }
    ActivatedQuest tmpActivatedQuest = activeQuestService.activatedQuest!;
    if (isTrackingDeadTime) {
      log.v("Skipping distance to goal check because tracking dead time is on");
      return "You can't check the distance at the moment because other processes are running";
    }

    // TODO: Think whether we should rather use the NEW Current location and
    // restart the listener so it fires after another "DISTANCEFILTER" distance
    // TODO: ALTERNATIVE: have smaller distanceFilter and additional filter to
    // select when user can update location
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
    // // DUMMY
    // if (allow || flavorConfigProvider.dummyQuestCompletionVerification) {

    if (true) {
      setSkipUpdatingQuestStatus(false);

      // check distance to goal!
      addCheckpoint(newPosition: position);
      return true;
    }
    // else {
    //   log.v("Not checking distance to goal!");
    //   return "Walk further";
    // }
  }

  Future checkDistance() async {
    if (isFirstDistanceCheck) {
      // first time the button is hit!
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
      fetchNewPosition(),
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
    log.i("Updating distance to goal to $newDistance meters");
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

  bool isUpdatingPositionAllowed({required Position position}) {
    double propagatedAccuracy = getPropagatedAccuracy(newPosition: position);
    if (propagatedAccuracy < kMinDistanceFromLastCheckInMeters * 3) {
      questTestingService.maybeRecordData(
        onlyIfDatabaseAlreadyCreated: true,
        pushToNotion: true,
        trigger: QuestDataPointTrigger.liveQuestUICallback,
        userEventDescription: "Allow position check",
      );
      log.v("Allow position check");
      return true;
    } else {
      questTestingService.maybeRecordData(
          trigger: QuestDataPointTrigger.liveQuestUICallback,
          onlyIfDatabaseAlreadyCreated: true,
          userEventDescription:
              "Don't allow updating position because accuracy is low (propagated acc: ${propagatedAccuracy.toStringAsFixed(2)} m)!",
          pushToNotion: true);
      log.v("Don't allow position check");
      return false;
    }
  }

  // check whether distance can be checked based on accuracy,
  // distance to last check, and quest configuration

  // This is currently not used as we use a position listener
  // which seems to perform much better!
  // TODO THIS IS POSSIBLY DEPRECATED
  bool isDistanceCheckAllowed({required Position newPosition}) {
    if (activeQuestService.activatedQuest == null) {
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
        activeQuestService.activatedQuest!.lastDistanceInMeters;
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
    if (activeQuestService.activatedQuest != null) {
      //void updateTime(int seconds) {

      // set initial data!
      // if (seconds == 1) {
      //   setInitialDistance();
      // }
      dynamic push;
      if (seconds % 5 == 0) {
        push = await fetchNewPosition();
        // if (push is String) {
        //   directionStatus = push;
        //   notifyListeners();
        // }
        activeQuestService.updateTimeOnQuest(
            activeQuestService.activatedQuest!, seconds);
      }

      // push quest
      if (push is bool && push == true) {
        setTrackingDeadTime(true);
        await Future.delayed(
            Duration(seconds: kDeadTimeAfterVibrationInSeconds));
        if (activeQuestService.activatedQuest!.status != QuestStatus.success)
          setTrackingDeadTime(false);
      }

      // Cancel after long time
      if (seconds >= kMaxQuestTimeInSeconds) {
        log.wtf(
            "Cancel quest after $kMaxQuestTimeInSeconds seconds, it was probably forgotten that the quest is still running!");
        // TODO: Could also be override function
        setTrackingDeadTime(false);
        await activeQuestService.cancelIncompleteQuest();
        return;
      }
    }
  }

  Future showInstructions() async {
    await dialogService.showDialog(
        title: "How it works",
        description:
            "Try to get to the treasure by checking the distance regularly. You have to walk to refresh the location checker. The trohphy is clever and sometimes moves around!!");
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
