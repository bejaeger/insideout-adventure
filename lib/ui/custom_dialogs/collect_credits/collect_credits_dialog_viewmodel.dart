import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_common_dialog_viewmodel.dart';

class CollectCreditsDialogViewModel extends QuestCommonDialogViewModel {
  CollectCreditsStatus status = CollectCreditsStatus.todo;
  CollectCreditsDialogViewModel({required this.status});

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
}
