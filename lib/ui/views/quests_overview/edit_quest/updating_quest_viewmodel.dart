import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:stacked/stacked.dart';

class UpdatingQuestViewModel extends FormViewModel with NavigationMixin {
  final _questService = locator<QuestService>();

  Quest? get getUpdatedQuest => _questService.getQuestToUpdate;
  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
}
