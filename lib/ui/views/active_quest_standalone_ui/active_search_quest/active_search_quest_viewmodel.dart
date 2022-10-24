import 'dart:async';
import 'dart:math';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/quests/search_quest_location/search_quest_location.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quests/direction_status.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../enums/collect_credits_status.dart';

// Singleton ViewModel!

class SearchQuestViewModel extends ActiveQuestBaseViewModel {
  // ----------------------------------
  // services
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final log = getLogger("SearchQuestViewModel");

  // ------------------------------------------
  // getters
  int? get currentGPSAccuracy => _geolocationService.currentGPSAccuracy;
  bool get isFirstDistanceCheck => numberTimesFired == 0;
  int get numCheckpointsReached => activeQuestService.getNumberMarkersCollected;
  int get numMarkers =>
      activeQuestService.getNumberMarkers -
      1; // -1 cause we don't wanna count start marker

  // ----------------
  // state
  DirectionStatus directionStatus = DirectionStatus.notstarted;
  bool isCheckingDistance = false;
  bool isNearGoal = false;

  List<SearchQuestLocation> checkpoints = [];

  double currentDistanceInMeters = -1;
  double previousDistanceInMeters = -1;
  int numberTimesFired = 0;
  bool allowCheckingPosition = true;

  // markers on map
  Set<Marker> markersOnMap = {};
  void Function()? notifyParentView;

  @override
  Future initialize(
      {required Quest quest, void Function()? notifyParentCallback}) async {
    notifyParentView = notifyParentCallback;
    setBusy(true);
    // here the calibration listener is called
    // !(maybe this is done twice at the moment as we also do it in QuestDetailsOverlayViewModel
    await super.initialize(quest: quest);
    // Add listener with a small distance filter to get most precise
    // start position!
    resetPreviousQuest();
    loadQuestMarkers(quest: quest);
    // await setInitialDistance(quest: quest);
    setBusy(false);
  }

  Future maybeStartQuest(
      {required Quest? quest, void Function()? notifyParentCallback}) async {
    if (quest != null) {
      notifyParentCallback = notifyParentCallback;
      log.i("Starting vibration search quest with name ${quest.name}");

      final position = await _geolocationService.getUserLivePosition;
      if (!(await checkAccuracy(
          position: position,
          minAccuracy: kMinRequiredAccuracyLocationSearch))) {
        if (useSuperUserFeatures) {
          if (await useSuperUserFeature()) {
            /*   Notifications()
                .unlockedAchievement(message: "Active Tresuare Location"); */

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
        log.e("Quest was not started!");
        return;
      }

      if (notifyParentCallback != null) {
        notifyParentCallback();
      }
      mapViewModel.resetMapMarkers();
      // quest started!
      // start listening to position
      // Notifications().createPermanentNotification(
      //     title: "Search quest ongoing", message: "Walk and find the credits.");

      activeQuestService.listenToPosition(
        distanceFilter: kMinDistanceFromLastCheckInMeters,
        //distanceFilter: 0,
        pushToNotion: true,
        recordPositionDataEvent: false,
        // skipFirstStreamEvent: true,
        // Maybe we should add a filterGPSData function that only
        // allows the user to check location based on certain conditions
        viewModelCallback: (position) async {
          if (allowCheckingPosition == false) {
            if (isUpdatingPositionAllowed(position: position)) {
              // ? The following two lines mean that
              // ? we manually check for updated positions
              // ? let's to it automatic for now, see below
              // setAllowCheckingPosition(true);
              // notifyListeners();

              await checkDistance();
            }
          }
          // this will move the map. Should happen more often than is the
          // case for the treasure location search! Add additional filtering!?
          setNewLatLon(lat: position.latitude, lon: position.longitude);
          animateOnNewLocation();
        },
      );

      snackbarService.showSnackbar(
          title: "Quest started",
          message: "Start to walk and try to get closer",
          duration: Duration(milliseconds: 1500));
      await checkDistance();
    } else {
      log.i("Not starting quest, quest is probably already running");
    }
  }

  bool isAtNextMarker({bool forceNoDummy = false}) {
    // return true;
    if (!hasActiveQuest) {
      log.wtf(
          "No quest is active! This function should have never been called!");
      return false;
    } else {
      // option to add dummy checks for testing purposes
      if (appConfigProvider.allowDummyMarkerCollection && !forceNoDummy) {
        return true;
      } else {
        // this is the true check configured in constants.dart
        return currentDistanceInMeters < kMinDistanceToCatchTrophyInMeters;
      }
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
      if (appConfigProvider.dummyQuestCompletionVerification) {
        return true;
      } else {
        if (numMarkers == numCheckpointsReached + 1) {
          if (appConfigProvider.allowDummyMarkerCollection) {
            return true;
          } else {
            return currentDistanceInMeters < kMinDistanceToCatchTrophyInMeters;
          }
        } else {
          return false;
        }
      }
    }
  }

  Future completeDistanceCheckAndUpdateQuestStatus(
      {bool forceNoDummy = false}) async {
    // TODO: We want to add some more advanced logic here!
    // TODO: To support multiple locations for the search quest

    final nearNextMarker = isAtNextMarker(forceNoDummy: forceNoDummy);
    if (nearNextMarker) {
      // Found next location
      if (isQuestCompleted()) {
        // TODO: Could start uploading credits already here!
        // TODO: And pass a "inProgress" status to showSuccessDialog() plus a completer!

        directionStatus = DirectionStatus.nearGoal;
        showNextARObjects(
          // Need to wrap up quest here!
          onCollected: () async {
            await handleQuestCompletedEvent();

            // reset map markers and add all quest markers back
            // ? (Not really sure if this is the best location to execute this code)
            mapViewModel.resetMapMarkers();
            mapViewModel.addAllQuestMarkers();
          },
        );
      } else {
        // TODO: Add alternative here when this is not the LAST marker yet!
        AFKMarker? nextMarker = activeQuestService.getNextMarker();
        directionStatus = DirectionStatus.nextNextMarker;
        showNextARObjects(
          // Need to wrap up quest here!
          onCollected: () async {
            // await showNextMarkerAwaitingDialog();
            await handleNextMarkerAwaiting(marker: nextMarker);
          },
        );
      }
      // notify map
      mapsService.notify();

      await vibrateRightDirection();
      await vibrateRightDirection();
      await vibrateRightDirection();
      await vibrateRightDirection();
    } else {
      late String? logString;
      // update UI on quest update
      if (checkpoints.elementAt(max(checkpoints.length - 2, 0)).distanceToGoal >
          checkpoints.last.distanceToGoal) {
        // directionStatus = "Getting closer!";
        directionStatus = DirectionStatus.closer;
        logString =
            "Updated: Right direction (${checkpoints.last.distanceToGoal.toStringAsFixed(2)} m left)";
        notifyListeners();
        await vibrateRightDirection();
      } else {
        directionStatus = DirectionStatus.further;
        logString =
            "Updated: Wrong direction (${checkpoints.last.distanceToGoal.toStringAsFixed(2)} m left)";
        notifyListeners();
        await vibrateWrongDirection();
      }

      // TODO push quest event
      questTestingService.maybeRecordData(
        trigger: QuestDataPointTrigger.userAction,
        userEventDescription: logString,
        pushToNotion: true,
      );
    }
  }

  Future handleNextMarkerAwaiting({AFKMarker? marker}) async {
    log.v("Handle next marker awaiting event");
    mapViewModel.resetMapMarkers();
    mapViewModel.notifyListeners();

    directionStatus = DirectionStatus.checkingDistance;
    isCheckingDistance = true;
    // isAnimatingCamera = true;
    notifyListeners();

    await activeQuestService.analyzeMarkerAndUpdateQuest(marker: marker);

    log.v("Checking distance!");
    await Future.wait([
      fetchNewPosition(),
      Future.delayed(Duration(milliseconds: 2000)),
    ]);

    // snackbarService.showSnackbar(title: "Let's gooooo!", message: "");
    directionStatus = DirectionStatus.nextMarkerWaiting;

    isCheckingDistance = false;
    // isAnimatingCamera = false;
    notifyListeners();
  }

  Future handleQuestCompletedEvent() async {
    // ! This is partially duplicated from hike_quest_viewmodel() atm!
    // ! Could maybe put this into active_quest_base_viewmodel.dart
    // ! as it is a long piece of code!
    isAnimatingCamera = true;
    // for listeners that disable lottie animation
    layoutService.setIsMovingCamera(true);
    setBusy(true);

    // Need to set this so the functions below do the right thing
    activeQuestService.setSuccessAsQuestStatus();
    // for UI!
    questFinished = true;
    notifyListeners();

    CollectCreditsStatus collectCreditsStatus = CollectCreditsStatus.todo;
    try {
      final results = await Future.wait(
        [
          handleSuccessfullyFinishedQuest(showDialogs: false),
          Future.delayed(Duration(milliseconds: 1000))
        ],
      );
      collectCreditsStatus = results[0];
    } catch (e) {
      log.e(e);
      showGenericInternalErrorDialog();
      collectCreditsStatus = CollectCreditsStatus.todo;
    }

    await showSuccessDialog(collectCreditsStatus: collectCreditsStatus);

    // we need to do this because we set showDialogs == false above!
    activeQuestService.cleanUpFinishedQuest();
    isAnimatingCamera = false;
    layoutService.setIsMovingCamera(false);

    // We need to notify the parent here so that common success UI can be shown!
    if (notifyParentView != null) {
      notifyParentView!();
    }
    setBusy(false);
  }

  @override
  void resetPreviousQuest() {
    // cancelQuestListener();
    markersOnMap = {};
    checkpoints = [];
    directionStatus = DirectionStatus.notstarted;
    questSuccessfullyFinished = false;
    currentDistanceInMeters = -1;
    previousDistanceInMeters = -1;
    numberTimesFired = 0;
    setIsCheckingDistance(false);
    setAllowCheckingPosition(true);
    super.resetPreviousQuest();
  }

  void setAllowCheckingPosition(bool allow) {
    log.v("Set allow checking position");
    allowCheckingPosition = allow;
  }

  // !DUPLICATED!? WITH addCheckpoint!?
  Future setInitialDistance({required Quest? quest}) async {
    if (quest == null) return;
    final position = await _geolocationService.getUserLivePosition;
    double newDistanceInMeters =
        getNewDistanceToNextMarker(newPosition: position);
    checkpoints.add(SearchQuestLocation(
        distanceToGoal: newDistanceInMeters,
        currentLat: position.latitude,
        currentLon: position.longitude,
        currentAccuracy: position.accuracy));
    previousDistanceInMeters = currentDistanceInMeters;
    currentDistanceInMeters = newDistanceInMeters;
    log.i("Setting initial data for Search Quest $newDistanceInMeters meters");
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

    // check distance to goal!
    addCheckpoint(newPosition: position);
    return true;
  }

  Future checkDistance({bool forceNoDummy = false}) async {
    if (isFirstDistanceCheck) {
      // first time the button is hit!
      // not sure if this is needed still
      if (hasActiveQuest) {
        setIsCheckingDistance(true);
        await Future.wait([
          setInitialDistance(quest: activeQuest.quest),
          artificialDelay(),
        ]);
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
        completeDistanceCheckAndUpdateQuestStatus(forceNoDummy: forceNoDummy);
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
    double newDistance = getNewDistanceToNextMarker(newPosition: newPosition);
    log.i("Updating distance to next marker to $newDistance meters");
    double distanceToPreviousCheckpoint =
        getDistanceToPreviousCheckpoint(newPosition: newPosition);
    checkpoints.add(
      SearchQuestLocation(
        distanceToGoal: newDistance,
        distanceToPreviousPosition: distanceToPreviousCheckpoint,
        currentLat: newPosition.latitude,
        currentLon: newPosition.longitude,
        currentAccuracy: newPosition.accuracy,
        previousLat: checkpoints.last.currentLat,
        previousLon: checkpoints.last.currentLon,
        previousAccuracy: checkpoints.last.currentAccuracy,
      ),
    );
    previousDistanceInMeters = currentDistanceInMeters;
    currentDistanceInMeters = newDistance;
  }

  double getNewDistanceToNextMarker({required Position newPosition}) {
    if (activeQuestNullable != null) {
      AFKMarker? nextMarker = activeQuestService.getNextMarker();
      if (nextMarker == null) {
        log.e(
            "No next marker found! Is the quest already completed? This should probably not happen!");
        return -1;
      }

      final newDistanceInMeters = _geolocationService.distanceBetween(
        lat1: newPosition.latitude,
        lon1: newPosition.longitude,
        lat2: nextMarker.lat,
        lon2: nextMarker.lon,
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

  // Return true of gps accuracy is reasonable, false otherwise
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

  ///////////////////////////////////////////////////
  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }

  // void cancelQuestListener() {
  //   log.i("Cancelling subscription to vibration search quest");
  //   _activeVibrationQuestSubscription?.cancel();
  //   _activeVibrationQuestSubscription = null;
  // }

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
    // cancelQuestListener();
    super.dispose();
  }

  Future artificialDelay() async {
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 400));
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
