import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';

class QuestCommonDialogViewModel extends ActiveQuestBaseViewModel {
  final log = getLogger("QuestCommonDialogViewModel");
  CollectCreditsStatus status;
  QuestCommonDialogViewModel({required this.status});

  bool get isCollectedCredits => status == CollectCreditsStatus.done;
  bool get isNeedToCollectCredits =>
      status == CollectCreditsStatus.todo ||
      status == CollectCreditsStatus.noNetwork;
  bool get isNoNetwork => status == CollectCreditsStatus.noNetwork;

  bool hasCollectedCreditsInDialog = false;

  Future getCredits() async {
    setBusy(true);
    final result = await handleSuccessfullyFinishedQuest();
    if (result == CollectCreditsStatus.done) {
      log.i("Credits succesfully collected");
      if (isNeedToCollectCredits) {
        hasCollectedCreditsInDialog = true;
      }
      status = CollectCreditsStatus.done;
    } else if (result == CollectCreditsStatus.todo) {
      return;
    }
    setBusy(false);
  }

  @override
  bool isQuestCompleted() {
    // TODO: implement isQuestCompleted
    throw UnimplementedError();
  }
}
