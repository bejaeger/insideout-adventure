

import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SingleQuestViewModel extends BaseModel {


  void startMinigameQuest() async {


    final quest = getDummyQuest1();
    await startQuest(quest: quest.copyWith(type: QuestType.Minigame));
    

  }

}