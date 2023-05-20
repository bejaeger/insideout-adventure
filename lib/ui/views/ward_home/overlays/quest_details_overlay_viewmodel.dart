import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';

class QuestDetailsOverlayViewModel extends ActiveQuestBaseViewModel {
  bool isAnimatingCamera =
      false; // to show progress indicator when camera is moving

  // TODO: Check if this is needed! (for calibration listener?)
  @override
  Future initialize({required Quest? quest}) async {
    final Quest? quest = selectedQuest ??
        activeQuestNullable?.quest ??
        previouslyFinishedQuest?.quest ??
        null;
    if (quest != null) {
      await super.initialize(quest: quest);
    }
  }

  @override
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
  }

  @override
  Future maybeStartQuest(
      {required Quest? quest, void Function()? notifyGuardianCallback}) async {
    // TODO: implement maybeStartQuest
    throw UnimplementedError();
  }
}
