import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class HistoryAndAchievementsViewModel extends BaseModel {
  List<ActivatedQuest> get activatedQuestsHistory =>
      questService.activatedQuestsHistory;
  List<Achievement> get achievements => gamificationService.achievements;
}
