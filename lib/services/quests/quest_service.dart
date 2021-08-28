import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart'; // Import stop_watch_timer
import 'package:afkcredits/app/app.logger.dart';

class QuestService {
  BehaviorSubject<ActivatedQuest?> activatedQuestSubject =
      BehaviorSubject<ActivatedQuest?>();
  ActivatedQuest? get activatedQuest => activatedQuestSubject.valueOrNull;
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final StopWatchService _stopWatchService =
      locator<StopWatchService>(); // Create instance.

  final log = getLogger("QuestService");

  Future startQuest({required Quest quest}) async {
    // Get active quest
    ActivatedQuest activatedQuest = getActivatedQuest(quest: quest);

    // Add quest to behavior subject
    pushActivatedQuest(activatedQuest);

    // Start timer
    _stopWatchService.startTimer();
    _stopWatchService.listenToSecondTime(callback: trackData);
  }

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

  ////////////////////////////////////////////////
  // Helper functions
  void pushActivatedQuest(ActivatedQuest quest) {
    log.v("Add updated quest to stream");
    activatedQuestSubject.add(quest);
  }

  void removeActivatedQuest() {
    log.v("Removing active quest");
    activatedQuestSubject.add(null);
  }

  Future getQuest({required String questId}) async {
    return await _firestoreApi.getQuest(questId: questId);
  }

  void updateTime(int seconds) {
    if (activatedQuest != null) {
      pushActivatedQuest(activatedQuest!.copyWith(timeElapsed: seconds));
    }
  }

  ActivatedQuest updateTimeOnQuest(ActivatedQuest activatedQuest, int seconds) {
    return activatedQuest.copyWith(timeElapsed: seconds);
  }

  Future trackData(int seconds) async {
    ActivatedQuest tmpActivatedQuest = activatedQuest!;
    //void updateTime(int seconds) {
    bool push = false;
    if (seconds % 1 == 0) {
      push = true;
      // every five seconds
      tmpActivatedQuest = updateTimeOnQuest(tmpActivatedQuest, seconds);
    }
    if (seconds % 10 == 0) {
      push = true;
      // every ten seconds
      log.v("10 seconds passed!");
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
