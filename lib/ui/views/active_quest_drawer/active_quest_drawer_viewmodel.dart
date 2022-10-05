import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';

class ActiveQuestDrawerViewModel extends ActiveQuestBaseViewModel {
  @override
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
  }

  @override
  Future maybeStartQuest(
      {required Quest? quest, void Function()? notifyParentCallback}) {
    // TODO: implement maybeStartQuest
    throw UnimplementedError();
  }
}
