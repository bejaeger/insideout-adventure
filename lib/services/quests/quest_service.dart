import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/completed_quest/completed_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:afkcredits/app/app.logger.dart';

class QuestService {
  BehaviorSubject<ActivatedQuest?> activatedQuestSubject =
      BehaviorSubject<ActivatedQuest?>();
  ActivatedQuest? get activatedQuest => activatedQuestSubject.valueOrNull;
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final MarkerService _markerService = locator<MarkerService>();
  final StopWatchService _stopWatchService =
      locator<StopWatchService>(); // Create instance.

  final log = getLogger("QuestService");

  Quest? _startedQuest;

  Future startQuest({required Quest quest}) async {
    // Get active quest
    ActivatedQuest activatedQuest = getActivatedQuest(quest: quest);

    // Add quest to behavior subject
    pushActivatedQuest(activatedQuest);

    // Start timer
    //Harguilar Commented This Out Timer
    _stopWatchService.startTimer();

    _stopWatchService.listenToSecondTime(callback: trackData);
  }

  //Set Started Quest.
  void setStartedQuest({required Quest startedQuest}) {
    _startedQuest = startedQuest;
  }

  //Get Started Quest
  Quest get getStartedQuest => _startedQuest!;

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

      evaluateQuest();

      if (activatedQuest!.status == QuestStatus.incomplete) {
        log.w("Quest is incomplete. Show message to user");
        return WarningQuestNotFinished;
      } else {
        log.i("Quest successfully finished, pushing to firebase!");
        // if we end up here it means the quest has finished succesfully!
        await _firestoreApi.pushFinishedQuest(quest: activatedQuest);
        disposeActivatedQuest();
      }
    }
  }

  /// Store all The Information
  Future finishQuest(
      {Quest? finishedQuest,
      required int? numMarkersCollected,
      required String? userId,
      required String? timeElapse}) async {
    //Stop the clock
    _stopWatchService.stopTimer();
    _stopWatchService.pauseListener();
    trackData(_stopWatchService.getSecondTime());

    log.i("Quest successfully finished, pushing to firebase!");
    // if we end up here it means the quest has finished succesfully!
    await _firestoreApi.createUserCompletedQuest(
        userId: userId,
        completedQuest: CompletedQuest(
            questId: finishedQuest!.id,
            numberMarkersCollected: numMarkersCollected,
            status: QuestStatus.success,
            afkCreditsEarned: finishedQuest.afkCredits,
            timeElapsed: timeElapse));
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
      await _firestoreApi.pushFinishedQuest(
          quest: activatedQuest!.copyWith(status: QuestStatus.cancelled));
      disposeActivatedQuest();
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
  void evaluateQuest() {
    log.i("Evaluating quest");
    bool? allMarkersCollected =
        activatedQuest?.markersCollected.any((element) => element == false);
    if (allMarkersCollected != null && allMarkersCollected == false) {
      pushActivatedQuest(activatedQuest!.copyWith(status: QuestStatus.success));
    } else {
      pushActivatedQuest(
          activatedQuest!.copyWith(status: QuestStatus.incomplete));
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
        // TODO: Add mechanism for the user to get a Notification about this
        await cancelIncompleteQuest();
        return;
      }
      //}
      if (push) {
        pushActivatedQuest(tmpActivatedQuest);
      }
    }
  }

  Future verifyAndUpdateCollectedMarkers({required AFKMarker marker}) async {
    if (!isMarkerInQuest(marker: marker)) {
      log.e("Marker is not part of current quest!");
      return Future.value("Marker is not part of the currently active quest!");
    }
    final closeby = await _markerService.isUserCloseby(marker: marker);
    if (!closeby) {
      log.e("User is not nearby marker!");
      // ! Still DUMMY VERSION -> Unit test of this function will fail!
      log.e(
          "We will still update the collected markers because we are using dummy data at the moment!");
      //return Future.value("User is not nearby the marker!");
    }
    updateCollectedMarkers(marker: marker);
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
        // TODO: Forward this info also to the user!
        log.i("Marker already collected");
        return;
      }
      markersCollectedNew[index] = true;
      log.v("New Marker collected!");
      pushActivatedQuest(
          activatedQuest!.copyWith(markersCollected: markersCollectedNew));
    } else {
      log.e(
          "Can't cancel the quest because there is no quest present. This function should have probably never been called! Please check!");
    }
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
      return activatedQuest!.quest.markers.any((element) => element == marker);
    } else {
      log.e(
          "Can't cancel the quest because there is no quest present. This function should have probably never been called! Please check!");
      return false;
    }
  }

  Future getQuest({required String questId}) async {
    return _firestoreApi.getQuest(questId: questId);
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

  ActivatedQuest getActivatedQuest({required Quest quest}) {
    return ActivatedQuest(
      quest: quest,
      markersCollected: List.filled(quest.markers.length, false),
      status: QuestStatus.active,
      timeElapsed: 0,
    );
  }
}
