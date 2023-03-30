import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/active_quest_base_viewmodel.dart';

class QuestCommonDialogViewModel extends ActiveQuestBaseViewModel {
  CollectCreditsStatus status;
  QuestCommonDialogViewModel({required this.status});

  final log = getLogger("QuestCommonDialogViewModel");

  bool get isCollectedCredits => status == CollectCreditsStatus.done;
  bool get isNeedToCollectCredits =>
      status == CollectCreditsStatus.todo ||
      status == CollectCreditsStatus.noNetwork;
  bool get isNoNetwork => status == CollectCreditsStatus.noNetwork;

  bool hasCollectedCreditsInDialog = false;

  Future getCredits() async {
    setBusy(true);
    final result = await handleQuestCompletedEventBase();
    if (result == CollectCreditsStatus.done) {
      log.i("Credits succesfully collected");
      if (isNeedToCollectCredits) {
        hasCollectedCreditsInDialog = true;
      }
      status = CollectCreditsStatus.done;
    } else if (result == CollectCreditsStatus.todo) {
      setBusy(false);
      return;
    }
    setBusy(false);
  }

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
