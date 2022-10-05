import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class QuestDetailsOverlayViewModel extends ActiveQuestBaseViewModel {
  // to show progress indicator when camera is moving
  bool isAnimatingCamera = false;

  @override
  Future initialize({required Quest? quest}) async {
    final Quest? quest = selectedQuest ??
        activeQuestNullable?.quest ??
        previouslyFinishedQuest?.quest ??
        null;
    // this will start the calibration listener!
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
      {required Quest? quest, void Function()? notifyParentCallback}) async {
    // TODO: implement maybeStartQuest
    // throw UnimplementedError();
  }
}
