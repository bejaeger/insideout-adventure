import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_common_dialog_viewmodel.dart';

class CollectCreditsDialogViewModel extends QuestCommonDialogViewModel {
  CollectCreditsStatus status;
  CollectCreditsDialogViewModel({required this.status}) : super(status: status);
}
