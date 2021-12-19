import 'dart:async';

import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/flavor_config.dart';

import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:afkcredits/app/app.logger.dart';

class QuestService {
  BehaviorSubject<ActivatedQuest?> activatedQuestSubject =
      BehaviorSubject<ActivatedQuest?>();
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();
  final MarkerService _markerService = locator<MarkerService>();
  final CloudFunctionsApi _cloudFunctionsApi = locator<CloudFunctionsApi>();
  final StopWatchService _stopWatchService =
      locator<StopWatchService>(); // Create instance.
  // map of list of money pools with money Pool id as key
  List<ActivatedQuest> activatedQuestsHistory = [];
  StreamSubscription? _pastQuestsStreamSubscription;
  List<Quest> nearbyQuests = [];
  final log = getLogger("QuestService");

  ActivatedQuest? previouslyFinishedQuest;

  bool get hasActiveQuest => activatedQuest != null;
  ActivatedQuest? get activatedQuest => activatedQuestSubject.valueOrNull;
  Quest? _startedQuest;
  Quest? get getStartedQuest => _startedQuest;
  void setStartedQuest(Quest? quest) {
    _startedQuest = quest;
  }
  // num get numberCollectedMarkers =>

  Future startQuest({required Quest quest, required List<String> uids}) async {
    // Get active quest
    ActivatedQuest tmpActivatedQuest =
        _getActivatedQuest(quest: quest, uids: uids);

    // Location check
    AFKMarker fullMarker = tmpActivatedQuest.quest.markers
        .firstWhere((element) => element.id == quest.startMarker.id);
    final bool closeby = await _markerService.isUserCloseby(marker: fullMarker);
    if (!closeby) {
      log.w("You are not nearby the marker, cannot start quest!");
      return "You are not nearby the marker.";
    }

    // Add quest to behavior subject
    pushActivatedQuest(tmpActivatedQuest);
    // ! this here is important !
    setStartedQuest(quest);

    // Start timer
    //Harguilar Commented This Out Timer
    _stopWatchService.startTimer();

    _stopWatchService.listenToSecondTime(callback: trackData);
    return true;
  }

  int get getNumberMarkersCollected => activatedQuest!.markersCollected
      .where((element) => element == true)
      .toList()
      .length;
  // TODO: unit test this?
  bool get isAllMarkersCollected =>
      activatedQuest!.quest.markers.length == getNumberMarkersCollected;

  // Handle the scenario when a user finishes a hike
  // First evaluate the activated quest data and return values according to that
  Future evaluateAndFinishQuest() async {
    // Fetch quest information
    if (activatedQuest == null) {
      log.e(
          "No activated quest present, can't finish anything! This function should have probably never been called!");
      return;
    } else {
      _stopWatchService.stopTimer();
      _stopWatchService.pauseListener();
      trackData(_stopWatchService.getSecondTime());
      // updateData();

      evaluateQuestAndSetStatus();

      if (activatedQuest!.status == QuestStatus.incomplete) {
        log.w("Quest is incomplete. Show message to user");
        return WarningQuestNotFinished;
      } else {
        log.i("Quest successfully finished, pushing to firebase!");
        //try {
        // if we end up here it means the quest has finished succesfully!
        try {
          await _cloudFunctionsApi.bookkeepFinishedQuest(
              quest: activatedQuest!);
        } catch (e) {
          if (e is CloudFunctionsApiException) {
            continueIncompleteQuest();
            rethrow;
          } else {
            await _firestoreApi.pushFinishedQuest(
                quest: activatedQuest!
                    .copyWith(status: QuestStatus.internalFailure));
            disposeActivatedQuest();
            log.wtf(e);
            rethrow;
          }
        }
        // At this point the quest has successfully finished!
        await _firestoreApi.pushFinishedQuest(quest: activatedQuest);
        // keep copy of finished quest to show in success dialog view
        previouslyFinishedQuest = activatedQuest;
        disposeActivatedQuest();
      }
    }
  }

  Future continueIncompleteQuest() async {
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
      // don't await for this call otherwise we will wait forever
      // in case of no data connection. Since we are just cancelling
      // a quest it's not crucial info for the app to immediately react to it.
      // So we can just take the easy route here and don't await the push call.
      _firestoreApi.pushFinishedQuest(
          quest: activatedQuest!.copyWith(status: QuestStatus.cancelled));
      disposeActivatedQuest();
      log.i("Cancelled incomplete ques");
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
    bool? allMarkersCollected =
        activatedQuest?.markersCollected.any((element) => element == false);
    if (allMarkersCollected != null && allMarkersCollected == false) {
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
  }

  Future trackData(int seconds) async {
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
      if (push) {
        pushActivatedQuest(tmpActivatedQuest);
      }
    }
  }

  void updateCollectedMarkers({required AFKMarker marker}) {
    if (activatedQuest != null) {
      final index = activatedQuest!.quest.markers
          .indexWhere((element) => element == marker);
      if (index < 0) {
        log.wtf(
            "Marker is not available in currently active quest. Before this funciton is called, this should have been already checked, please check your code!");
        return;
      }
      List<bool> markersCollectedNew = activatedQuest!.markersCollected;
      if (markersCollectedNew[index]) {
        log.wtf(
            "Marker already collected. Before this function is called, this should have been already checked, please check your code!");
        return;
      }
      markersCollectedNew[index] = true;
      log.v("New Marker collected!");
      pushActivatedQuest(
          activatedQuest!.copyWith(markersCollected: markersCollectedNew));
    } else {
      log.e(
          "Can't update the collected markers because there is no quest present. This function should have probably never been called! Please check!");
    }
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
  Future<QuestQRCodeScanResult> handleQrCodeScanEvent(
      {AFKMarker? marker}) async {
    if (marker == null) return QuestQRCodeScanResult.empty();
    if (!hasActiveQuest) {
      // get Quests with start marker id
      List<Quest> quests =
          await getQuestsWithStartMarkerId(markerId: marker.id);
      return QuestQRCodeScanResult.quests(quests: quests);
    } else {
      // Checks to perform:
      // 1. isMarkerInQuest
      // 2. isUserCloseby?
      // 3. isMarkerAlreadyCollected?

      // 1.
      if (!isMarkerInQuest(marker: marker)) {
        log.w("Scanned marker does not belong to currently active quest");
        return QuestQRCodeScanResult.error(
            errorMessage: WarningScannedMarkerNotInQuest);
      }

      // Marker is in quest so let's get full marker with lat and long by reading from already downloaded
      // active quest
      AFKMarker fullMarker = activatedQuest!.quest.markers
          .firstWhere((element) => element.id == marker.id);

      // 2.
      final bool closeby =
          await _markerService.isUserCloseby(marker: fullMarker);
      if (!closeby) {
        log.w("User is not nearby marker!");
        return QuestQRCodeScanResult.error(
            errorMessage: WarningNotNearbyMarker);
      }

      // 3.
      if (isMarkerCollected(marker: fullMarker)) {
        log.w("Scanned marker has been collected already");
        return QuestQRCodeScanResult.error(
            errorMessage: WarningScannedMarkerAlreadyCollected);
      }

      log.i(
          "Marker verified! Continue with updated collected markers in activated quesst");
      updateCollectedMarkers(marker: fullMarker);
      // return marker that was succesfully scanned
      return QuestQRCodeScanResult.marker(marker: fullMarker);
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

  Future loadNearbyQuests() async {
    // TODO: In the future retrieve only nearby quests
    nearbyQuests = await _firestoreApi.getNearbyQuests(
        pushDummyQuests: _flavorConfigProvider.pushAndUseDummyQuests);
    log.i("Found ${nearbyQuests.length} nearby quests.");
  }

  ////////////////////////////////////////////////
  // Helper functions
  void pushActivatedQuest(ActivatedQuest quest) {
    // log.v("Add updated quest to stream");
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

  Future getQuest({required String questId}) async {
    return _firestoreApi.getQuest(questId: questId);
  }

  // Changed the Scope of the Method. from _pvt to public
  Future<List<Quest>> downloadNearbyQuests() async {
    return await _firestoreApi.downloadNearbyQuests();
  }

  Future<List<Quest>> getQuestsWithStartMarkerId(
      {required String markerId}) async {
    // get Quests with start marker id
    late List<Quest> quests;
    if (nearbyQuests.length == 0) {
      quests = await _firestoreApi.downloadQuestsWithStartMarkerId(
          startMarkerId: markerId);
    } else {
      quests = nearbyQuests
          .where((element) => element.startMarker.id == markerId)
          .toList();
    }
    return quests;
  }

  void updateTime(int seconds) {
    if (activatedQuest != null) {
      pushActivatedQuest(activatedQuest!.copyWith(timeElapsed: seconds));
    }
  }

  ActivatedQuest updateTimeOnQuest(ActivatedQuest activatedQuest, int seconds) {
    return activatedQuest.copyWith(timeElapsed: seconds);
  }

  void disposeActivatedQuest() {
    _stopWatchService.resetTimer();
    _stopWatchService.cancelListener();
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
  }
}
