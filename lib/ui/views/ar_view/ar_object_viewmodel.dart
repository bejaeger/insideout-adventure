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
    layoutService.setIsShowingARView(false);
    popViewReturnValue(result: result);
    restorePreviousCameraPosition(moveInsteadOfAnimate: true);
  }
}
