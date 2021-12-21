import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class QuestCommonDialogViewModel extends BaseModel {
  final log = getLogger("QuestStatusDialogViewModel");

  bool collectedCredits = false;
  Future getCredits() async {
    setBusy(true);
    final result = await handleSuccessfullyFinishedQuest();
    if (result == true) {
      log.i("Credits succesfully collected");
      collectedCredits = true;
    } else {
      replaceWithMainView(index: BottomNavBarIndex.quest);
    }
    setBusy(false);
  }
}
