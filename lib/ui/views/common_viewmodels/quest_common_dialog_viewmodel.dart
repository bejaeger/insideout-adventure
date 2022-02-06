import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';

class QuestCommonDialogViewModel extends ActiveQuestBaseViewModel {
  final log = getLogger("QuestStatusDialogViewModel");

  QuestCommonDialogViewModel();

  @override
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
  }
}
