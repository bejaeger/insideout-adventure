import 'dart:async';
import 'dart:math';
import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/position_retrieval.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_ui_style.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nanoid/nanoid.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:stacked/stacked.dart';

class QuestService with ReactiveServiceMixin {
  QuestService() {
    listenToReactiveValues([_timeElapsed]);
  }

  Quest? _questToUpdate;
  BehaviorSubject<ActivatedQuest?> activatedQuestSubject =
      BehaviorSubject<ActivatedQuest?>();
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();
  final MarkerService _markerService = locator<MarkerService>();
  final CloudFunctionsApi _cloudFunctionsApi = locator<CloudFunctionsApi>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final StopWatchService _stopWatchService =
      locator<StopWatchService>(); // Create instance.
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();
  // map of list of money pools with money Pool id as key
  List<ActivatedQuest> activatedQuestsHistory = [];
  StreamSubscription? _pastQuestsStreamSubscription;
  //Turned local variable pvt
  List<Quest> _nearbyQuests = [];
  final log = getLogger("QuestService");

  ActivatedQuest? previouslyFinishedQuest;

//Created a Getter for near by Quest
  List<Quest> get getNearByQuest => _nearbyQuests;

  Quest? get getQuestToUpdate => _questToUpdate;

  void setQuestToUpdate({required Quest quest}) {
    if (quest.id.isNotEmpty) {
      _questToUpdate = quest;
    }
  }

  // dead time after update
  bool isTrackingDeadTime = false;
  bool isUIDeadTime = false;

  bool get hasActiveQuest => activatedQuest != null;
  ActivatedQuest? get activatedQuest => activatedQuestSubject.valueOrNull;
  Quest? currentQuest;

  Quest? _startedQuest;
  Quest? get getStartedQuest => _startedQuest;
  void setStartedQuest(Quest? quest) {
    _startedQuest = quest;
  }

  String? activatedQuestTrialId;

  bool sortedNearbyQuests = false;
  List<QuestType> allQuestTypes = [];
  // num get numberCollectedMarkers =>

  Future startQuest(
      {required Quest quest,
      required List<String> uids,
      Future Function(int)? periodicFuncFromViewModel,
      bool countStartMarkerAsCollected = false}) async {
    // Get active quest
    ActivatedQuest tmpActivatedQuest =
        _getActivatedQuest(quest: quest, uids: uids);

    // Location check
    if (quest.type != QuestType.DistanceEstimate) {
      try {
        AFKMarker fullMarker = tmpActivatedQuest.quest.markers
            .firstWhere((element) => element.id == quest.startMarker?.id);
        final bool closeby =
            await _markerService.isUserCloseby(marker: fullMarker);
        if (!closeby) {
          log.w("You are not nearby the marker, cannot start quest!");
          return "You are not nearby the marker.";
        }
      } catch (e) {
        log.e("Error thrown when searching for start marker: $e");
        if (e is StateError) {
          log.e(
              "The quest that is to be started does not have a start marker!");
        }
      }
    }

    if (countStartMarkerAsCollected) {
      tmpActivatedQuest.markersCollected[0] = true;
    }

    // ! quest activated!
    // Add quest to behavior subject
    pushActivatedQuest(tmpActivatedQuest);
    // ! this here is important !
    setStartedQuest(quest);
    setNewTrialNumber();
    _questTestingService.maybeInitialize(
      activatedQuest: activatedQuest,
      activatedQuestTrialId: activatedQuestTrialId,
    );

    // Start timer
    _stopWatchService.startTimer();

    if (quest.type == QuestType.QRCodeHuntIndoor ||
        quest.type == QuestType.QRCodeSearch) {
      _stopWatchService.listenToSecondTime(callback: trackTime);
    }

    if (quest.type == QuestType.TreasureLocationSearch) {
      if (periodicFuncFromViewModel != null) {
        _stopWatchService.listenToSecondTime(
            callback: periodicFuncFromViewModel);
      }
    }
    //  else if (quest.type == QuestType.DistanceEstimate) {
    //   _stopWatchService.listenToSecondTime(callback: trackDataDistanceEstimate);
    // }
    else if (quest.type == QuestType.QRCodeHike ||
        quest.type == QuestType.GPSAreaHike) {
      _stopWatchService.listenToSecondTime(callback: trackTime);
    }
    // Quest succesfully started
    _questTestingService.maybeRecordData(
        trigger: QuestDataPointTrigger.userAction,
        userEventDescription: "quest started",
        pushToNotion: true);
    return true;
  }

  Future<void> listenToPosition({
    double distanceFilter = kMinDistanceFromLastCheckInMeters,
    void Function(Position)? viewModelCallback,
    bool pushToNotion = false,
    bool skipFirstStreamEvent = false,
    bool recordPositionDataEvent = true,
  }) async {
    return await _geolocationService.listenToPosition(
        distanceFilter: distanceFilter.round(),
        onData: (Position position) {
          log.v("New position event fired from location listener!");
          if (recordPositionDataEvent) {
            _questTestingService.maybeRecordData(
              trigger: QuestDataPointTrigger.locationListener,
              position: position,
              questTrialId: activatedQuestTrialId,
              activatedQuest: activatedQuest,
              pushToNotion: pushToNotion,
            );
          }
        },
        viewModelCallback: viewModelCallback,
        skipFirstStreamEvent: skipFirstStreamEvent);
  }

  void cancelPositionListener() {
    _geolocationService.cancelPositionListener();
  }

  int get getNumberMarkersCollected => activatedQuest!.markersCollected
      .where((element) => element == true)
      .toList()
      .length;
  // TODO: unit test this?
  bool get isAllMarkersCollected =>
      activatedQuest!.quest.markers.length == getNumberMarkersCollected;

  Future handleSuccessfullyFinishedQuest() async {
    // 1. Get credits collected, time elapsed and other potential data at the end of the quest
    // 2. bookkeep credits
    // 3. clean-up old quest

    // ------------------
    // 1.
    // TODO
    evaluateFinishedQuest();

    // ----------------
    // 2.
    await collectCredits();

    // ---------------
    // 3.
    await uploadAndCleanUpFinishedQuest();

    // Quest succesfully started
    _questTestingService.maybeRecordData(
        trigger: QuestDataPointTrigger.userAction,
        userEventDescription: "Quest succesfully finished",
        pushToNotion: true);
  }

  Future evaluateFinishedQuest() async {
    pushActivatedQuest(activatedQuest!.copyWith(
        status: QuestStatus.success,
        afkCreditsEarned: activatedQuest!.quest.afkCredits));
  }

  Future collectCredits() async {
    if (activatedQuest == null) {
      log.wtf("no active quest to collect credits from");
      return;
    }
    try {
      await _cloudFunctionsApi.bookkeepFinishedQuest(quest: activatedQuest!);
    } catch (e) {
      if (e is CloudFunctionsApiException) {
        if (activatedQuest!.status != QuestStatus.success) {
          continueIncompleteQuest();
        }
        rethrow;
      } else {
        await _firestoreApi.pushFinishedQuest(
            quest:
                activatedQuest!.copyWith(status: QuestStatus.internalFailure));
        disposeActivatedQuest();
        log.wtf(e);
        rethrow;
      }
    }
  }

  Future uploadAndCleanUpFinishedQuest() async {
    // At this point the quest has successfully finished!
    await _firestoreApi.pushFinishedQuest(quest: activatedQuest);
    // keep copy of finished quest to show in success dialog view
    previouslyFinishedQuest = activatedQuest;
    disposeActivatedQuest();
    setUIDeadTime(false);
    setTrackingDeadTime(false);
  }

  // Handle the scenario when a user finishes a hike
  // First evaluate the activated quest data and return values according to that
  Future evaluateAndFinishQuest({bool force = false}) async {
    log.i("Evaluating quest and finishing it if finished");
    // Fetch quest information
    if (activatedQuest == null) {
      log.e(
          "No activated quest present, can't finish anything! This function should have probably never been called!");
      return;
    } else {
      _stopWatchService.stopTimer();
      _stopWatchService.pauseListener();
      trackData(_stopWatchService.getSecondTime(), forceNoPush: true);
      // updateData();

      // TODO: Add evaluation (how many afk credits were earned) for all quest types

      evaluateQuestAndSetStatus();

      if (activatedQuest!.status == QuestStatus.incomplete && !force) {
        log.w("Quest is incomplete. Show message to user");
        return WarningQuestNotFinished;
      }
      if (activatedQuest!.status == QuestStatus.success || force) {
        log.i(
            "Quest successfully finished (or forcing to finish), pushing to firebase!");
        //try {
        // if we end up here it means the quest has finished succesfully!
        await collectCredits();
        // At this point the quest has successfully finished!
        await uploadAndCleanUpFinishedQuest();
      }
    }
  }

  dynamic checkQuestStatus() {
    if (activatedQuest!.status == QuestStatus.incomplete) {
      log.w("Quest is incomplete. Show message to user");
      return WarningQuestNotFinished;
    }
  }

  Future continueIncompleteQuest() async {
    // TODO: recover quest! of all types!

    if (activatedQuest != null) {
      _stopWatchService.resumeListener();
      _stopWatchService.startTimer();
      pushActivatedQuest(activatedQuest!.copyWith(status: QuestStatus.active));
    } else {
      log.e(
          "Can't continue the quest because there is no quest present. This function should have probably never been called! Please check!");
    }
  }

  Future cancelIncompleteQuest() async {
    if (activatedQuest != null) {
      log.i("Cancelling incomplete quest");
      // Quest succesfully started
      // don't await for this call otherwise we will wait forever
      // in case of no data connection. Since we are just cancelling
      // a quest it's not crucial info for the app to immediately react to it.
      // So we can just take the easy route here and don't await the push call.
      _firestoreApi.pushFinishedQuest(
          quest: activatedQuest!.copyWith(status: QuestStatus.cancelled));
      pushActivatedQuest(
          activatedQuest!.copyWith(status: QuestStatus.cancelled));
      disposeActivatedQuest();
      log.i("Cancelled incomplete quest");
    } else {
      log.e(
          "Can't cancel the quest because there is no quest present. This function should have probably never been called! Please check!");
    }
  }

  //////////////////////////////////////////
  //////////////////////////////////////////////////////////
  // Internal & Important functions

  // evaluate the quest
  // Set status of quest according to what is found
  // success: user succesfully finished the quest
  // incomplete: e.g. not all markers were collected
  // also set earned credits
  void evaluateQuestAndSetStatus() {
    log.i("Evaluating quest");

    if (activatedQuest?.status == QuestStatus.success) {
      // model evaluated already in viewmodel. Just add credits
      pushActivatedQuest(activatedQuest!
          .copyWith(afkCreditsEarned: activatedQuest!.quest.afkCredits));
      return;
    }

    if (activatedQuest?.quest.type == QuestType.TreasureLocationSearch ||
        activatedQuest?.quest.type == QuestType.DistanceEstimate) {
      if (activatedQuest?.status == QuestStatus.success) {
        pushActivatedQuest(activatedQuest!.copyWith(
            status: QuestStatus.success,
            afkCreditsEarned: activatedQuest!.quest.afkCredits));
      } else {
        pushActivatedQuest(
          activatedQuest!.copyWith(
            status: QuestStatus.incomplete,
          ),
        );
      }

      // } else if (activatedQuest?.quest.type == QuestType.DistanceEstimate) {

    } else {
      bool? markerMissing =
          activatedQuest?.markersCollected.any((element) => element == false);
      bool allMarkersCollected = markerMissing == null ? false : !markerMissing;

      if (allMarkersCollected == true) {
        log.i("All markers were collected, quest finished successfully!");
        pushActivatedQuest(activatedQuest!.copyWith(
            status: QuestStatus.success,
            afkCreditsEarned: activatedQuest!.quest.afkCredits));
      } else {
        log.w("Quest found to be incomplete!");
        log.w(
            "Info: allMarkersCollected = $allMarkersCollected, markersCollected: ${activatedQuest?.markersCollected}");
        pushActivatedQuest(
          activatedQuest!.copyWith(
            status: QuestStatus.incomplete,
          ),
        );
      }
    }
  }

  void setAndPushActiveQuestStatus(QuestStatus status) {
    _questTestingService.maybeRecordData(
        trigger: QuestDataPointTrigger.userAction,
        userEventDescription: "New quest status: " + status.toString(),
        pushToNotion: true);
    pushActivatedQuest(activatedQuest!.copyWith(status: status));
  }

  void setSuccessAsQuestStatus() {
    setAndPushActiveQuestStatus(QuestStatus.success);
  }

  Future trackTime(int seconds) async {
    if (activatedQuest != null) {
      ActivatedQuest tmpActivatedQuest = activatedQuest!;
      if (seconds % 1 == 0) {
        updateTimeElapsed(seconds);
      }
    }
  }

  Future<void> updateQuestData({required Quest quest}) async {
    if (quest.id != null || quest.id.isNotEmpty) {
      await _firestoreApi.updateQuestData(quest: quest);
    } else {
      log.wtf('You cannot provide me, an Empty Quest ID: ${quest.id}');
    }
  }

  ///Get a List of Quests
  // Get Markers For the Quest.
  Future<List<AFKMarker?>?> getMarkers() async {
    //So Far I will only return the Markers with the FB.
    return await _firestoreApi.getMarkers();
  }

  Future trackData(int seconds, {bool forceNoPush = false}) async {
    if (activatedQuest != null) {
      ActivatedQuest tmpActivatedQuest = activatedQuest!;
      //void updateTime(int seconds) {
      bool push = false;
      if (seconds % 1 == 0) {
        push = true;
        // every five seconds
        tmpActivatedQuest = this.updateTimeOnQuest(tmpActivatedQuest, seconds);
      }
      if (seconds % 10 == 0) {
        push = true;
        // every ten seconds
        log.v("quest active since $seconds seconds!");
        // tmpActivatedQuest = trackSomeOtherData(tmpActivatedQuest, seconds);
      }
      if (seconds >= kMaxQuestTimeInSeconds) {
        push = false;
        log.wtf(
            "Cancel quest after $kMaxQuestTimeInSeconds seconds, it was probably forgotten!");
        await cancelIncompleteQuest();
        return;
      }
      //}
      if (push && !forceNoPush) {
        pushActivatedQuest(tmpActivatedQuest);
      }
    }
  }

  // DEPRECATED
  Future trackDataVibrationSearch(int seconds) async {
    if (activatedQuest != null) {
      ActivatedQuest tmpActivatedQuest = activatedQuest!;
      //void updateTime(int seconds) {

      // set initial data!
      if (seconds == 1) {
        final position = await _geolocationService.getAndSetCurrentLocation();
        tmpActivatedQuest = updateLatLonOnQuest(
            activatedQuest: tmpActivatedQuest,
            newLat: position.latitude,
            newLon: position.latitude);
        final newDistanceInMeters = _geolocationService.distanceBetween(
          lat1: position.latitude,
          lon1: position.longitude,
          lat2: tmpActivatedQuest.quest.finishMarker?.lat,
          lon2: tmpActivatedQuest.quest.finishMarker?.lon,
        );
        tmpActivatedQuest = updateDistanceOnQuest(
            activatedQuest: tmpActivatedQuest,
            newDistance: newDistanceInMeters,
            newLat: position.latitude,
            newLon: position.longitude);
        log.i(
            "Setting initial data for Vibration Search Quest $newDistanceInMeters meters");
        pushActivatedQuest(tmpActivatedQuest);
      }
      bool push = false;
      if (seconds % 3 == 0) {
        if (isTrackingDeadTime) {
          log.v("Skipping distance to goal check because dead time is on");
          return;
        }
        final position = await _geolocationService.getAndSetCurrentLocation();
        if (position.accuracy > kMinRequiredAccuracyLocationSearch) {
          log.v(
              "Accuracy is ${position.accuracy} and not enough to take next point!");
          return;
        } else {
          push = true;
        }

        // check how far user went when last check happened!
        final distanceFromLastCheck = _geolocationService.distanceBetween(
          lat1: tmpActivatedQuest.lastCheckLat,
          lon1: tmpActivatedQuest.lastCheckLon,
          lat2: position.latitude,
          lon2: position.longitude,
        );

        if (distanceFromLastCheck > kMinDistanceFromLastCheckInMeters) {
          // if (distanceFromLastCheck > 0) {
          push = true;
          // check distance to goal!
          final newDistanceInMeters = _geolocationService.distanceBetween(
            lat1: position.latitude,
            lon1: position.longitude,
            lat2: tmpActivatedQuest.quest.finishMarker?.lat,
            lon2: tmpActivatedQuest.quest.finishMarker?.lon,
          );
          tmpActivatedQuest = updateDistanceOnQuest(
              activatedQuest: tmpActivatedQuest,
              newDistance: newDistanceInMeters,
              newLat: position.latitude,
              newLon: position.longitude);
          log.i("Updating distance to goal to $newDistanceInMeters meters");
          tmpActivatedQuest =
              this.updateTimeOnQuest(tmpActivatedQuest, seconds);
        } else {
          log.v(
              "Not checking distance to goal, distance from last check: $distanceFromLastCheck");
        }
      }
      if (seconds % 10 == 0) {
        // push = true;
        // every ten seconds
        log.v("quest active since $seconds seconds!");
        // tmpActivatedQuest = trackSomeOtherData(tmpActivatedQuest, seconds);
      }
      if (seconds >= kMaxQuestTimeInSeconds) {
        push = false;
        log.wtf(
            "Cancel quest after $kMaxQuestTimeInSeconds seconds, it was probably forgotten!");
        await cancelIncompleteQuest();
        return;
      }
      //}
      if (push) {
        pushActivatedQuest(tmpActivatedQuest);
        setTrackingDeadTime(true);
        await Future.delayed(
            Duration(seconds: kDeadTimeAfterVibrationInSeconds));
        if (tmpActivatedQuest.status != QuestStatus.success)
          setTrackingDeadTime(false);
      }
    }
  }

  Future<void> removeQuest({required Quest quest}) async {
    try {
      if (quest.id != "" || quest != null) {
        await _firestoreApi.removeQuest(quest: quest);
      } else {
        log.wtf('You are Providing me Empty Ids ${quest.id}');
      }
    } catch (e) {
      log.i(e.toString());
    }
  }

  Future trackDataDistanceEstimate(int seconds,
      {bool forceNoPush = false}) async {
    if (activatedQuest != null) {
      ActivatedQuest tmpActivatedQuest = activatedQuest!;
      //void updateTime(int seconds) {
      bool push = false;
      if (seconds % 10 == 0) {
        // check location every once in a while to
        // make user aware of current accuracy?
        push = true;
        await _geolocationService.getAndSetCurrentLocation();
      }
      if (seconds >= kMaxQuestTimeInSeconds) {
        push = false;
        log.wtf(
            "Cancel quest after $kMaxQuestTimeInSeconds seconds, it was probably forgotten!");
        await cancelIncompleteQuest();
        return;
      }
      //}
      if (push && !forceNoPush) {
        pushActivatedQuest(tmpActivatedQuest);
      }
    }
  }

  void setTrackingDeadTime(bool deadTime) {
    log.v("Setting quest data tracking dead time to $deadTime");
    isTrackingDeadTime = deadTime;
  }

  void setUIDeadTime(bool deadTime) {
    log.v("Setting quest data UI update dead time to $deadTime");
    isUIDeadTime = deadTime;
  }

  void updateCollectedMarkers({required AFKMarker marker}) {
    if (activatedQuest != null) {
      final index = activatedQuest!.quest.markers
          .indexWhere((element) => element == marker);

      // some error catching
      if (index < 0) {
        log.wtf(
            "Marker is not available in currently active quest. Before this function is called, this should have been already checked, please check your code!");
        return;
      }
      List<bool> markersCollectedNew = activatedQuest!.markersCollected;
      if (markersCollectedNew[index]) {
        log.wtf(
            "Marker already collected. Before this function is called, this should have been already checked, please check your code!");
        return;
      }

      // actually updating the marker list storing the info whether a marker is found or not
      markersCollectedNew[index] = true;
      log.v("New Marker collected!");
      pushActivatedQuest(
          activatedQuest!.copyWith(markersCollected: markersCollectedNew));
    } else {
      log.e(
          "Can't update the collected markers because there is no quest present. This function should have probably never been called! Please check!");
    }
  }

  List<AFKMarker> markersToShowOnMap({Quest? questIn}) {
    // late Quest quest;
    List<AFKMarker> markers = [];
    if (hasActiveQuest) {
      if (activatedQuest!.quest.type == QuestType.QRCodeHike) {
        markers = activatedQuest!.quest.markers;
      }
      if (activatedQuest!.quest.type == QuestType.GPSAreaHike) {
        for (var i = 0; i < activatedQuest!.markersCollected.length; i++) {
          if (activatedQuest!.markersCollected[i]) {
            markers.add(activatedQuest!.quest.markers[i]);
          }
        }
        int index = activatedQuest!.markersCollected
            .lastIndexWhere((element) => element == true);
        if (index + 1 < activatedQuest!.quest.markers.length) {
          markers.add(activatedQuest!.quest.markers[index + 1]);
        }
      }
    } else {
      if (questIn == null) {
        log.e(
            "Cannot retrieve markers because no quest active and no quest provided");
        return [];
      }
      if (questIn.type == QuestType.GPSAreaHike) {
        markers.add(questIn.markers[0]);
        if (questIn.markers.length > 1) {
          markers.add(questIn.markers[1]);
        }
      }
      if (questIn.type == QuestType.QRCodeHike) {
        markers = questIn.markers;
      }
    }
    return markers;
  }

  bool isMarkerCollected({required AFKMarker marker}) {
    if (activatedQuest != null) {
      final index = activatedQuest!.quest.markers
          .indexWhere((element) => element == marker);
      return activatedQuest!.markersCollected[index];
    } else {
      return false;
    }
  }

  // Function that interprets QR Code scanning event
  // If no quest is active, a check is performed whether the marker is a start marker.
  // If a quest is active, the marker is validated .
  // In each case, an appropriate QuestQRCodeScanResult is returned.
  // This result is interpreted in the viewmodels
  Future<MarkerAnalysisResult> analyzeMarker(
      {AFKMarker? marker, bool locationVerification = true}) async {
    if (marker == null) return MarkerAnalysisResult.empty();

    if (!hasActiveQuest) {
      // get Quests with start marker id
      List<Quest> quests =
          await getQuestsWithStartMarkerId(markerId: marker.id);
      return MarkerAnalysisResult.quests(quests: quests);
    } else {
      // Checks to perform:
      // 1. isMarkerInQuest
      // 2. isUserCloseby?
      // 3. isMarkerAlreadyCollected?

      // 1.
      if (!isMarkerInQuest(marker: marker)) {
        log.w("Scanned marker does not belong to currently active quest");
        return MarkerAnalysisResult.error(
            errorMessage: WarningScannedMarkerNotInQuest);
      }

      // Marker is in quest so let's get full marker with lat and long by reading from already downloaded
      // active quest
      AFKMarker fullMarker = activatedQuest!.quest.markers
          .firstWhere((element) => element.id == marker.id);

      // 2.
      if (locationVerification) {
        final bool closeby =
            await _markerService.isUserCloseby(marker: fullMarker);
        if (!closeby) {
          log.w("User is not nearby marker!");
          return MarkerAnalysisResult.error(
              errorMessage: WarningNotNearbyMarker);
        }
      }
      // 3.
      if (isMarkerCollected(marker: fullMarker)) {
        log.w("Scanned marker has been collected already");
        return MarkerAnalysisResult.error(
            errorMessage: WarningScannedMarkerAlreadyCollected);
      }

      log.i(
          "Marker verified! Continue with updated collected markers in activated quest");
      updateCollectedMarkers(marker: fullMarker);
      // return marker that was succesfully scanned
      return MarkerAnalysisResult.marker(marker: fullMarker);
    }
  }

  Future<AFKMarker?> getMarkerFromQrCodeId({required String qrCodeId}) async {
    // TODO: Check wether marker is in active quest or whether it needs to be downloaded!
    return await _firestoreApi.getMarkerFromQrCodeId(qrCodeId: qrCodeId);
  }

  ////////////////////////////////////////////
  /// History of quests
  // adds listener to money pools the user is contributing to
  // allows to wait for the first emission of the stream via the completer
  Future<void>? setupPastQuestsListener(
      {required Completer<void> completer,
      required String uid,
      void Function()? callback}) async {
    if (_pastQuestsStreamSubscription == null) {
      bool listenedOnce = false;
      _pastQuestsStreamSubscription =
          _firestoreApi.getPastQuestsStream(uid: uid).listen((snapshot) {
        listenedOnce = true;
        activatedQuestsHistory = snapshot;
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
        log.v("Listened to ${activatedQuestsHistory.length} quests");
      });
      if (!listenedOnce) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      return completer.future;
    } else {
      log.w("Already listening to list of quests, not adding another listener");
      completer.complete();
    }
  }

  Future loadNearbyQuests({bool force = false}) async {
    if (_nearbyQuests.isEmpty || force) {
      // TODO: In the future retrieve only nearby quests
      _nearbyQuests = await _firestoreApi.getNearbyQuests(
          pushDummyQuests: _flavorConfigProvider.pushAndUseDummyQuests);
      log.i("Found ${_nearbyQuests.length} nearby quests.");
    } else {
      log.i("Quests already loaded.");
    }
  }

  Future getQuestsOfType({required QuestType questType}) async {
    if (_nearbyQuests.isEmpty) {
      // Not very efficient to load all quests and then extract only the ones of a specific type!
      await loadNearbyQuests();
    }
    return extractQuestsOfType(quests: _nearbyQuests, questType: questType);
  }

  List<Quest> extractQuestsOfType(
      {required List<Quest> quests, required QuestType questType}) {
    List<Quest> returnQuests = [];
    if (quests.isNotEmpty) {
      for (Quest _q in quests) {
        if (_q.type == questType) {
          returnQuests.add(_q);
        }
      }
    } else {
      log.w('No nearby quests found');
    }
    return returnQuests;
  }

  void extractAllQuestTypes() {
    if (_nearbyQuests.isNotEmpty) {
      for (Quest _q in _nearbyQuests) {
        if (!allQuestTypes.any((element) => element == _q.type)) {
          allQuestTypes.add(_q.type);
        }
      }
    } else {
      log.w('No nearby quests found');
    }
  }

  // Useful for UI, check if active quest screen is standalone ui or map view!
  QuestUIStyle getQuestUIStyle({Quest? quest}) {
    Quest? usedQuest;
    if (quest != null) {
      usedQuest = quest;
    } else if (activatedQuest != null) {
      usedQuest = activatedQuest!.quest;
    } else {
      log.e(
          "No quest given as input and no quest active! Returning default = QuestUIStyle.map");
      return QuestUIStyle.map;
    }
    final type = usedQuest.type;
    if (type == QuestType.TreasureLocationSearch ||
        type == QuestType.DistanceEstimate ||
        type == QuestType.QRCodeSearch ||
        type == QuestType.QRCodeSearchIndoor ||
        type == QuestType.QRCodeHuntIndoor) {
      return QuestUIStyle.standalone;
    } else {
      return QuestUIStyle.map;
    }
  }

  Future sortNearbyQuests() async {
    if (_nearbyQuests.isNotEmpty) {
      log.i("Check distances for current quest list");

      // need to use normal for loop to await results
      for (var i = 0; i < _nearbyQuests.length; i++) {
        if (_nearbyQuests[i].startMarker != null) {
          double distance =
              await _geolocationService.distanceBetweenUserAndCoordinates(
                  lat: _nearbyQuests[i].startMarker!.lat,
                  lon: _nearbyQuests[i].startMarker!.lon);
          _nearbyQuests[i] =
              _nearbyQuests[i].copyWith(distanceFromUser: distance);
        } else {
          _nearbyQuests[i] = _nearbyQuests[i]
              .copyWith(distanceFromUser: kUnrealisticallyHighDistance);
          sortedNearbyQuests = true;
        }
      }
      _nearbyQuests
          .sort((a, b) => a.distanceFromUser!.compareTo(b.distanceFromUser!));
    } else {
      log.w(
          "Curent quests empty, or distance check not required. Can't check distances");
    }
    log.i("Notify listeners");
  }

  ////////////////////////////////////////////////
  // Helper functions
  void pushActivatedQuest(ActivatedQuest quest) {
    log.v("Add updated quest to stream so that UI can react!");
    activatedQuestSubject.add(quest);
  }

  void removeActivatedQuest() {
    log.v("Removing active quest");
    activatedQuestSubject.add(null);
  }

  bool isMarkerInQuest({required AFKMarker marker}) {
    if (activatedQuest != null) {
      return activatedQuest!.quest.markers
          .any((element) => element.id == marker.id);
    } else {
      log.e(
          "Can't cancel the quest because there is no quest present. This function should have probably never been called! Please check!");
      return false;
    }
  }

  AFKMarker? getNextMarker({Quest? quest}) {
    late int index;
    if (hasActiveQuest) {
      index = activatedQuest!.markersCollected
          .lastIndexWhere((element) => element == true);
      if (index < 0) {
        // no marker collected yet
        index = 1;
      } else {
        index++;
      }
      if (index < activatedQuest!.quest.markers.length) {
        return activatedQuest!.quest.markers[index];
      }
    } else {
      if (quest != null && (1 < quest.markers.length)) {
        return quest.markers[1];
      }
    }
    return null;
  }

  Future getQuest({required String questId}) async {
    return _firestoreApi.getQuest(questId: questId);
  }

  Future<bool?> createQuest({required Quest quest}) async {
    //TODO: Refactor this code .
    if (quest.id.isNotEmpty) {
      return await _firestoreApi.createQuest(quest: quest);
    }

    //update the newly created document reference with the Firestore Id.
    //This is to make suret that the document has the same id as the quest.
  }

  // Changed the Scope of the Method. from _pvt to public
  Future<List<Quest>> downloadNearbyQuests() async {
    return await _firestoreApi.downloadNearbyQuests();
  }

  Future<List<Quest>> getQuestsWithStartMarkerId(
      {required String markerId}) async {
    // get Quests with start marker id
    late List<Quest> quests;
    if (_nearbyQuests.length == 0) {
      quests = await _firestoreApi.downloadQuestsWithStartMarkerId(
          startMarkerId: markerId);
    } else {
      quests = _nearbyQuests
          .where((element) => element.startMarker?.id == markerId)
          .toList();
    }
    return quests;
  }

  ReactiveValue<int> _timeElapsed = ReactiveValue<int>(0);
  int get timeElapsed => _timeElapsed.value;
  void updateTimeElapsed(int seconds) {
    _timeElapsed.value = seconds;
  }

  String getMinutesElapsedString() {
    return _stopWatchService.secondsToMinuteSecondTime(timeElapsed);
  }

  String getHoursElapsedString() {
    return _stopWatchService.secondsToHourMinuteSecondTime(timeElapsed);
  }

  void resetTimeElapsed() {
    _timeElapsed.value = 0;
  }

  void updateTime(int seconds) {
    if (activatedQuest != null) {
      pushActivatedQuest(activatedQuest!.copyWith(timeElapsed: seconds));
    }
  }

  ActivatedQuest updateTimeOnQuest(ActivatedQuest activatedQuest, int seconds) {
    return activatedQuest.copyWith(timeElapsed: seconds);
  }

  ActivatedQuest updateDistanceOnQuest(
      {required ActivatedQuest activatedQuest,
      required double newDistance,
      required double newLat,
      required double newLon}) {
    return activatedQuest.copyWith(
        currentDistanceInMeters: newDistance,
        lastDistanceInMeters: activatedQuest.currentDistanceInMeters,
        lastCheckLat: newLat,
        lastCheckLon: newLon);
  }

  ActivatedQuest updateLatLonOnQuest(
      {required ActivatedQuest activatedQuest,
      required double newLat,
      required double newLon}) {
    return activatedQuest.copyWith(lastCheckLat: newLat, lastCheckLon: newLon);
  }

  // to identify trial number in diagnosis data
  void setNewTrialNumber() {
    activatedQuestTrialId = nanoid(6);
  }

  void disposeActivatedQuest() {
    _stopWatchService.resetTimer();
    _stopWatchService.cancelListener();
    // cancelLocationListener();
    cancelPositionListener();
    _questTestingService.maybeReset();
    resetTimeElapsed();
    removeActivatedQuest();
  }

  ActivatedQuest _getActivatedQuest(
      {required Quest quest, required List<String> uids}) {
    return ActivatedQuest(
      quest: quest,
      markersCollected: List.filled(quest.markers.length, false),
      status: QuestStatus.active,
      timeElapsed: 0,
      uids: uids,
    );
  }

  void clearData() {
    log.i("Clear quest history");
    activatedQuestsHistory = [];
    _pastQuestsStreamSubscription?.cancel();
    _pastQuestsStreamSubscription = null;
    currentQuest = null;
  }
}
