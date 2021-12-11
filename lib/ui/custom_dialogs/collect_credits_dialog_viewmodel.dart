import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class CollectCreditsDialogViewModel extends BaseModel {
  CreditsCollectionStatus status = CreditsCollectionStatus.toCollect;

  void collectCredits() {
    status = CreditsCollectionStatus.collected;
    notifyListeners();
  }
}
