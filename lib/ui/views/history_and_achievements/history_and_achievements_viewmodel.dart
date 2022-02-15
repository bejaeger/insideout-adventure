import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/achievements/achievement.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class HistoryAndAchievementsViewModel extends BaseModel {
  final GiftCardService _giftCardService = locator<GiftCardService>();

  List<ActivatedQuest> get activatedQuestsHistory =>
      questService.activatedQuestsHistory;
  List<GiftCardPurchase> get purchasedGiftCards =>
      _giftCardService.purchasedGiftCards;
  List<Achievement> get achievements => gamificationService.achievements;
}
