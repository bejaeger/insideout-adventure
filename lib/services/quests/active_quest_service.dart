import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/marker_collection_failure_type.dart';
import 'package:afkcredits/enums/quest_data_point_trigger.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/local_storage_service/local_storage_service.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:nanoid/nanoid.dart';
import 'package:rxdart/subjects.dart';
import 'package:stacked/stacked.dart';

class ActiveQuestService with ReactiveServiceMixin {
  ActiveQuestService() {
    listenToReactiveValues([_timeElapsed]);
  }

  final log = getLogger("ActiveQuestService");
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final MarkerService _markerService = locator<MarkerService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final StopWatchService _stopWatchService =
      locator<StopWatchService>(); // Create instance.
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();
  final QuestService questService = locator<QuestService>();
  final MapStateService mapStateService = locator<MapStateService>();
  final LocalStorageService localStorageService =
      locator<LocalStorageService>();

  bool get hasActiveQuest => activatedQuest != null;
  ActivatedQuest? get activatedQuest => activatedQuestSubject.valueOrNull;
  ActivatedQuest? _temporaryActivatedQuestFromLocalStorageToStart;
  ActivatedQuest? get questToBeStarted =>
      _temporaryActivatedQuestFromLocalStorageToStart;
  bool get hasActiveQuestToBeStarted =>
      _temporaryActivatedQuestFromLocalStorageToStart != null;
  bool get hasSelectedQuest => selectedQuest != null;
  Quest? get selectedQuest => selectedQuestSubject.valueOrNull;
  int get getNumberMarkers =>
      activatedQuest == null ? 0 : activatedQuest!.quest.markers.length;
  int get getNumberMarkersCollected => activatedQuest == null
      ? 0
      : activatedQuest!.markersCollected
          .where((element) => element == true)
          .toList()
          .length;
  bool get isAllMarkersCollected =>
      activatedQuest!.quest.markers.length == getNumberMarkersCollected;

  BehaviorSubject<ActivatedQuest?> activatedQuestSubject =
      BehaviorSubject<ActivatedQuest?>();
  ActivatedQuest? previouslyFinishedQuest;
  BehaviorSubject<Quest?> selectedQuestSubject = BehaviorSubject<Quest?>();
  bool questCenteredOnMap = false;
  DateTime? _questStartTime;
  // TODO: seems to solve the same purpose as selectedQuest(?)
  Quest? currentQuest;
  String? activatedQuestTrialId;

  void setSelectedQuest(Quest quest) {
    selectedQuestSubject.add(quest);
  }

  void resetSelectedAndMaybePreviouslyFinishedQuest() {
    resetSelectedQuest();
    resetPreviouslyFinishedQuest();
  }

  void resetPreviouslyFinishedQuest() {
    previouslyFinishedQuest = null;
  }

  void resetSelectedQuest() {
    // if selectedQuest is null and currentQuest is not null -> quest active
    selectedQuestSubject.add(null);
  }

  void setTemporaryQuestToBeStarted({required ActivatedQuest? quest}) {
    _temporaryActivatedQuestFromLocalStorageToStart = quest;
  }

  void resetTemporaryQuestToBeStarted({required ActivatedQuest? quest}) {
    setTemporaryQuestToBeStarted(quest: null);
  }

  Future startQuest(
      {required Quest quest,
      required List<String> uids,
      Future Function(int)? periodicFuncFromViewModel,
      bool countStartMarkerAsCollected = false}) async {
    late ActivatedQuest tmpActivatedQuest;
    if (!hasActiveQuestToBeStarted) {
      _timeElapsedOffset = 0;
      tmpActivatedQuest = _createActivatedQuest(quest: quest, uids: uids);
    } else {
      // this means a quest was found in local storage at startup and this quest is resumed
      _timeElapsedOffset = questToBeStarted!.timeElapsed;
      tmpActivatedQuest = questToBeStarted!;
    }

    if (quest.type != QuestType.DistanceEstimate) {
      try {
        AFKMarker fullMarker = tmpActivatedQuest.quest.markers
            .firstWhere((element) => element.id == quest.startMarker?.id);
        final bool closeby =
            await _markerService.isUserCloseby(marker: fullMarker);
        if (!closeby) {
          log.w("You are not nearby the marker, cannot start quest!");
          return "Get closer to the start first.";
        }
      } catch (e) {
        log.e("Error thrown when searching for start marker: $e");
        if (e is StateError) {
          log.e(
              "The quest that is to be started does not have a start marker!");
        }
      }
    }

    if (countStartMarkerAsCollected && !hasActiveQuestToBeStarted) {
      List<bool> tmpMarkersCollectedList =
          List.from(tmpActivatedQuest.markersCollected);
      tmpMarkersCollectedList[0] = true;
      tmpActivatedQuest =
          tmpActivatedQuest.copyWith(markersCollected: tmpMarkersCollectedList);
    }

    // quest activated!

    pushActivatedQuest(tmpActivatedQuest);
    // careful: don't move before pushActivatedQuest
    if (!hasActiveQuestToBeStarted) {
      saveActiveQuestToLocalStorage();
    } else {
      resetTemporaryQuestToBeStarted(quest: null);
    }
    setNewTrialNumber();
    _questTestingService.maybeInitialize(
      activatedQuest: activatedQuest,
      activatedQuestTrialId: activatedQuestTrialId,
      marker: getNextMarker(),
    );

    _stopWatchService.startTimer();

    if (quest.type == QuestType.QRCodeHunt ||
        quest.type == QuestType.GPSAreaHunt) {
      _stopWatchService.listenToSecondTime(callback: trackTime);
    }

    if (quest.type == QuestType.TreasureLocationSearch) {
      if (periodicFuncFromViewModel != null) {
        _stopWatchService.listenToSecondTime(
            callback: periodicFuncFromViewModel);
      }
    } else if (quest.type == QuestType.QRCodeHike ||
        quest.type == QuestType.GPSAreaHike) {
      _stopWatchService.listenToSecondTime(callback: trackTime);
    }

    _questTestingService.maybeRecordData(
        trigger: QuestDataPointTrigger.userAction,
        userEventDescription: "quest started",
        pushToNotion: true);

    _questStartTime = DateTime.now();
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

  void pausePositionListener() {
    _geolocationService.pausePositionListener();
  }

  void resumePositionListener() {
    _geolocationService.resumePositionListener();
  }

  void addMainLocationListener() async {
    await _geolocationService.listenToPositionMain(
      distanceFilter: kDefaultGeolocationDistanceFilter,
      onData: (Position position) {
        mapStateService.setNewLatLon(
            lat: position.latitude, lon: position.longitude);
        mapStateService.animateOnNewLocation();
        log.v("New position event fired from location listener!");
      },
    );
  }

  bool isFinishMarker(AFKMarker marker) {
    return activatedQuest?.quest.finishMarker == marker;
  }

  bool isStartMarker(AFKMarker marker) {
    return activatedQuest?.quest.startMarker == marker;
  }

  Future saveActiveQuestToLocalStorage() async {
    if (activatedQuest == null) {
      log.e("No active quest to save to local storage");
      return;
    }
    try {
      Map<String, dynamic> jsonData = activatedQuest!.toJson();
      // careful/hack: have to set GeoPoint to null here because
      // it is not serializable!
      jsonData['quest']['location'] = null;
      await localStorageService.saveJsonData(
          data: jsonData, fileName: kActivatedQuestLocalFileName);
      log.i("Saved active quest to local storage");
    } catch (e) {
      log.e("Error saving active quest to local storage: $e");
      rethrow;
    }
  }

  Future updateActiveQuestInLocalStorage() async {
    await saveActiveQuestToLocalStorage();
  }

  Future<ActivatedQuest?> loadActiveQuestFromLocalStorage() async {
    try {
      final data = await localStorageService.loadJsonData(
          fileName: kActivatedQuestLocalFileName);
      log.i("Found activated quest in local storage");
      return ActivatedQuest.fromJson(data);
    } catch (e) {
      log.i("No activated quest present");
      return null;
    }
  }

  Future<void> deleteActiveQuestFromLocalStorage() async {
    await localStorageService.deleteJsonData(
        fileName: kActivatedQuestLocalFileName);
  }

  Future handleSuccessfullyFinishedQuest({bool disposeQuest = false}) async {
    log.v("Handling successfully finished quest");

    _questTestingService.maybeRecordData(
        trigger: QuestDataPointTrigger.userAction,
        userEventDescription: "Quest succesfully finished",
        pushToNotion: true);

    evaluateFinishedQuest();

    final res = await Connectivity().checkConnectivity();
    if (res != ConnectivityResult.none) {
      await uploadAndBookkeepFinishedQuest();
    } else {
      return WarningFirestoreCallTimeout;
    }

    if (disposeQuest) {
      cleanUpFinishedQuest();
    }
  }

  void evaluateFinishedQuest() {
    if (_questStartTime != null) {
      pushActivatedQuest(activatedQuest!.copyWith(
          status: QuestStatus.success,
          afkCreditsEarned: activatedQuest!.quest.afkCredits,
          timeElapsed: DateTime.now().difference(_questStartTime!).inSeconds));
    } else {
      pushActivatedQuest(activatedQuest!.copyWith(
          status: QuestStatus.success,
          afkCreditsEarned: activatedQuest!.quest.afkCredits));
    }
  }

  Future uploadAndBookkeepFinishedQuest() async {
    log.v("bookeep credits in database");
    if (activatedQuest == null) {
      log.e("no active quest to collect credits from");
      return;
    }

    try {
      final res =
          await _firestoreApi.bookkeepFinishedQuest(quest: activatedQuest!);
      if (res is String) {
        return res;
      }
    } catch (e) {
      if (e is FirestoreApiException) {
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

  void cleanUpFinishedQuest() {
    // keep copy of finished quest to show in success dialog view
    previouslyFinishedQuest = activatedQuest;
    disposeActivatedQuest();
  }

  dynamic checkQuestStatus() {
    if (activatedQuest!.status == QuestStatus.incomplete) {
      log.w("Quest is incomplete. Show message to user");
      return WarningQuestNotFinished;
    }
  }

  Future continueIncompleteQuest() async {
    if (activatedQuest != null) {
      _stopWatchService.resume();
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
    if (hasActiveQuest) {
      _questTestingService.maybeRecordData(
          trigger: QuestDataPointTrigger.userAction,
          userEventDescription: "New quest status: " + status.toString(),
          pushToNotion: true);
      pushActivatedQuest(activatedQuest!.copyWith(status: status));
    }
  }

  void setSuccessAsQuestStatus() {
    setAndPushActiveQuestStatus(QuestStatus.success);
  }

  Future trackTime(int seconds) async {
    if (activatedQuest != null) {
      if (seconds % 1 == 0) {
        updateTimeElapsed(seconds);
      }
    }
  }

  void updateCollectedMarkers({required AFKMarker marker}) {
    if (activatedQuest != null) {
      final index = activatedQuest!.quest.markers
          .indexWhere((element) => element == marker);

      if (index < 0) {
        log.wtf(
            "Marker is not available in currently active quest. Before this function is called, this should have been already checked, please check your code!");
        return;
      }
      List<bool> markersCollectedNew =
          List.from(activatedQuest!.markersCollected);
      if (markersCollectedNew[index]) {
        log.wtf(
            "Marker already collected. Before this function is called, this should have been already checked, please check your code!");
        return;
      }

      markersCollectedNew[index] = true;
      log.v("New Marker collected!");
      pushActivatedQuest(activatedQuest!.copyWith(
          markersCollected: markersCollectedNew, timeElapsed: timeElapsed));
    } else {
      log.e(
          "Can't update the collected markers because there is no quest present. This function should have probably never been called! Please check!");
    }
  }

  List<AFKMarker> getCollectedMarkers() {
    List<AFKMarker> markers = [];
    if (hasActiveQuest) {
      for (int i = 0; i < currentQuest!.markers.length; i++) {
        if (activatedQuest!.markersCollected[i] == true) {
          markers.add(currentQuest!.markers[i]);
        }
      }
    }
    return markers;
  }

  List<AFKMarker> markersToShowOnMap({Quest? questIn}) {
    List<AFKMarker> markers = [];
    if (hasActiveQuest || hasActiveQuestToBeStarted) {
      ActivatedQuest actQuest =
          (activatedQuest ?? _temporaryActivatedQuestFromLocalStorageToStart)!;
      if (actQuest.quest.type == QuestType.QRCodeHike) {
        markers = actQuest.quest.markers;
      }
      if (actQuest.quest.type == QuestType.GPSAreaHike) {
        for (var i = 0; i < actQuest.markersCollected.length; i++) {
          if (actQuest.markersCollected[i]) {
            markers.add(actQuest.quest.markers[i]);
          }
        }
        // add next checkpoint to the list
        int index = actQuest.markersCollected
            .lastIndexWhere((element) => element == true);
        if (index + 1 < actQuest.quest.markers.length) {
          markers.add(actQuest.quest.markers[index + 1]);
        }
      }
      if (actQuest.quest.type == QuestType.QRCodeHunt ||
          actQuest.quest.type == QuestType.GPSAreaHunt) {
        for (var i = 0; i < actQuest.markersCollected.length; i++) {
          if (actQuest.markersCollected[i]) {
            markers.add(actQuest.quest.markers[i]);
          }
        }
      }
    } else {
      if (questIn == null) {
        log.e(
            "Cannot retrieve markers because no quest active and no quest provided");
        return [];
      }
      if (questIn.type == QuestType.QRCodeHike) {
        markers = questIn.markers;
      }
      if (questIn.type == QuestType.GPSAreaHike) {
        markers.add(questIn.markers[0]);
        if (questIn.markers.length > 1) {
          markers.add(questIn.markers[1]);
        }
      }
      if (questIn.type == QuestType.QRCodeHunt ||
          questIn.type == QuestType.GPSAreaHunt) {
        markers.add(questIn.markers[0]);
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

  // Function that interprets checkpoint checking event
  // If no quest is active, a check is performed whether the marker is a start marker.
  // If a quest is active, the marker is validated .
  // In each case, an appropriate MarkerAnalysisResult is returned.
  // This result is interpreted in the viewmodels
  Future<MarkerAnalysisResult> analyzeMarkerAndUpdateQuest(
      {AFKMarker? marker, bool verifyLocation = true}) async {
    if (marker == null) return MarkerAnalysisResult.empty();

    if (!hasActiveQuest) {
      // get Quests with start marker id
      List<Quest> quests =
          await questService.getQuestsWithStartMarkerId(markerId: marker.id);
      return MarkerAnalysisResult.quests(quests: quests);
    } else {
      if (!isMarkerInQuest(marker: marker)) {
        log.w("Scanned marker does not belong to currently active quest");
        return MarkerAnalysisResult.error(
            errorMessage: WarningScannedMarkerNotInQuest,
            errorType: MarkerCollectionFailureType.alreadyCollected);
      }

      // Marker is in quest so let's get full marker with lat and long by reading from already downloaded
      // active quest
      AFKMarker fullMarker = activatedQuest!.quest.markers
          .firstWhere((element) => element.id == marker.id);

      if (verifyLocation) {
        final bool closeby = await _markerService.isUserCloseby(
            marker: fullMarker, geofenceRadius: getGeoFenceForCurrentQuest());
        if (!closeby) {
          log.w("User is not nearby marker!");
          return MarkerAnalysisResult.error(
              errorMessage: WarningNotNearbyMarker);
        }
      }

      if (isMarkerCollected(marker: fullMarker)) {
        log.w("Scanned marker has been collected already");
        return MarkerAnalysisResult.error(
            errorMessage: WarningScannedMarkerAlreadyCollected);
      }

      log.i(
          "Marker verified! Continue with updated collected markers in activated quest");
      updateCollectedMarkers(marker: fullMarker);
      await updateActiveQuestInLocalStorage();
      _questTestingService.setNewNextMarker(getNextMarker());

      return MarkerAnalysisResult.marker(marker: fullMarker);
    }
  }

  int getGeoFenceForCurrentQuest() {
    if (currentQuest?.type == QuestType.QRCodeHunt) {
      return kMaxDistanceFromMarkerInMeterQrCodeHunt;
    } else {
      return kMaxDistanceFromMarkerInMeter;
    }
  }

  AFKMarker? getNextMarker({Quest? quest}) {
    late int index;
    if (hasActiveQuest) {
      log.v("currently collected markers: ${activatedQuest!.markersCollected}");
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

  AFKMarker? getPreviousMarker({Quest? quest}) {
    late int index;
    if (hasActiveQuest) {
      index = activatedQuest!.markersCollected
          .lastIndexWhere((element) => element == true);
      if (index < 0) {
        // no marker collected yet
        index = 0;
      }
      if (index < activatedQuest!.quest.markers.length) {
        return activatedQuest!.quest.markers[index];
      }
    } else {
      if (quest != null && (0 < quest.markers.length)) {
        return quest.markers[0];
      }
    }
    return null;
  }

  int _timeElapsedOffset = 0;
  ReactiveValue<int> _timeElapsed = ReactiveValue<int>(0);
  int get timeElapsed => _timeElapsed.value;
  void updateTimeElapsed(int seconds) {
    _timeElapsed.value = seconds + _timeElapsedOffset;
  }

  String getMinutesElapsedString() {
    return _stopWatchService.durationString(timeElapsed);
  }

  String getHoursElapsedString() {
    return _stopWatchService.secondsToHourMinuteSecondTime(timeElapsed);
  }

  void resetTimeElapsed() {
    _timeElapsed.value = 0;
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

  // to identify trial number in quest analytics data
  void setNewTrialNumber() {
    activatedQuestTrialId = nanoid(6);
  }

  void disposeActivatedQuest() {
    _timeElapsedOffset = 0;
    _stopWatchService.stopTimer();
    _stopWatchService.resetTimer();
    cancelPositionListener();
    addMainLocationListener();
    _questTestingService.maybeReset();
    resetTimeElapsed();
    removeActivatedQuest();
    _questStartTime = null;
    deleteActiveQuestFromLocalStorage();
  }

  ActivatedQuest _createActivatedQuest(
      {required Quest quest, required List<String> uids}) {
    return ActivatedQuest(
      quest: quest,
      markersCollected: List.filled(quest.markers.length, false),
      status: QuestStatus.active,
      timeElapsed: 0,
      uids: uids,
    );
  }

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

  void clearData() {
    log.i("Clear current Quest");
    currentQuest = null;
  }
}
