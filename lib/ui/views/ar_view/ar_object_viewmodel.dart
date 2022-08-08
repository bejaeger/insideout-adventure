import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';

class ARObjectViewModel extends ActiveQuestBaseViewModel
    with MapStateControlMixin {
  @override
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
  }

  Future handleCollectedArObjectEvent() async {
    await showCollectedMarkerDialog();
    popArView(result: true);
  }

  void popArView({dynamic result}) async {
    layoutService.setIsFadingOutOverlay(false);
    popViewReturnValue(result: result);
    restorePreviousCameraPosition(moveInsteadOfAnimate: true);
  }

  @override
  Future maybeStartQuest(
      {required Quest? quest, void Function()? onStartQuestCallback}) {
    // TODO: implement maybeStartQuest
    throw UnimplementedError();
  }
}
