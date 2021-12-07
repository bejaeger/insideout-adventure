import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class SingleQuestViewModel extends QuestViewModel {
  void startMinigameQuest(QuestType questType) async {
    if (questType == QuestType.VibrationSearch) {
      final quest = getDummyVibrationSearchQuest();
      await startQuest(quest: quest.copyWith(type: questType));
    } else {
      final quest = getDummyQuest1();
      await startQuest(quest: quest.copyWith(type: questType));
    }
  }

  @override
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }
}
