import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
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
    updateActivatedQuest(activatedQuest);

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
      updateActivatedQuest(
          activatedQuest!.copyWith(status: QuestStatus.active));
    } else {
      log.e(
          "Can't continue the quest because there is no quest present. This function should have probably never been called! Please check!");
    }
  }

  Future cancelIncompleteQuest() async {
    log.i("Cancelling incomplete quest");
    await _firestoreApi.pushFinishedQuest(quest: activatedQuest);
    disposeActivatedQuest();
  }

  //////////////////////////////////////////
  //////////////////////////////////////////////////////////
  // Internal & Important functions

  // Callback function called every second in the stop watch listener
  // used to track quests data!
  void trackData(int seconds) {
    if (activatedQuest != null) {
      // Q: Does this only trigger a rebuild in the sponsor home view?
      // Or in other places, too? Something to test!
      updateActivatedQuest(activatedQuest!.copyWith(timeElapsed: seconds));
    }
  }

  // evaluate the quest
  // Set status of quest according to what is found
  // success: user succesfully finished the quest
  // incomplete: e.g. not all markers were collected
  void evaluateQuest() {
    log.i("Evaluating quest");
    bool? allMarkersCollected =
        activatedQuest?.markersCollected.any((element) => element == false);
    if (allMarkersCollected != null && allMarkersCollected == false) {
      updateActivatedQuest(
          activatedQuest!.copyWith(status: QuestStatus.success));
    } else {
      updateActivatedQuest(
          activatedQuest!.copyWith(status: QuestStatus.incomplete));
    }
  }

  ////////////////////////////////////////////////
  // Helper functions
  void updateActivatedQuest(ActivatedQuest quest) {
    log.v("Add updated quest to stream");
    activatedQuestSubject.add(quest);
  }

  void removeActivatedQuest() {
    activatedQuestSubject.add(null);
  }

  Future getQuest({required String questId}) async {
    return await _firestoreApi.getQuest(questId: questId);
  }

  void updateTime(int seconds) {
    if (activatedQuest != null) {
      updateActivatedQuest(activatedQuest!.copyWith(timeElapsed: seconds));
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
