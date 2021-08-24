import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/active_quests/active_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_status.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart'; // Import stop_watch_timer
import 'package:afkcredits/app/app.logger.dart';

class QuestService {
  BehaviorSubject<ActiveQuest?> activeQuestSubject =
      BehaviorSubject<ActiveQuest?>();
  ActiveQuest? get activeQuest => activeQuestSubject.valueOrNull;
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.

  final log = getLogger("QuestService");

  void updateActiveQuest(ActiveQuest quest) {
    activeQuestSubject.add(quest);
  }

  void removeActiveQuest() {
    activeQuestSubject.add(null);
  }

  Future startQuest({required String questId}) async {
    // Fetch quest information
    Quest quest = await _firestoreApi.getQuest(questId: questId);

    // Get active quest
    ActiveQuest activeQuest = getActiveQuest(quest: quest);

    // Add quest to behavior subject
    updateActiveQuest(activeQuest);

    // Start timer
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    _stopWatchTimer.secondTime.listen((value) {
      updateTime(value);
      log.v('secondTime $value');
    });
  }

  Future finishQuest() async {
    // Fetch quest information
    if (activeQuest == null) {
      log.e("No active quest present, can't finish anything!");
    } else {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      updateTime(_stopWatchTimer.secondTime.value);
      await _firestoreApi.pushFinishedQuest(quest: activeQuest);
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      removeActiveQuest();
    }
  }

  ////////////////////////////////////////
  /// helper functions
  void updateTime(int value) {
    if (activeQuest != null) {
      updateActiveQuest(activeQuest!.copyWith(timeElapsed: value));
    }
  }

  ActiveQuest getActiveQuest({required Quest quest}) {
    return ActiveQuest(
      quest: quest,
      markersCollected: List.filled(quest.markers.length, false),
      status: QuestStatus.active,
      timeElapsed: 0,
    );
  }
}
