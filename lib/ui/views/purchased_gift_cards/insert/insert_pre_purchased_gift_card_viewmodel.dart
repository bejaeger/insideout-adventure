import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/pre_purchased_gift_cards/pre_purchased_gift_card.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/manage_gift_cards/add_gift_cards/add_gift_cards_viewmodel.dart';

class InsertPrePurchasedGiftCardViewModel extends GiftCardsImageViewModel {
  final logger = getLogger('ManageQuestViewModel');
  final _giftCardService = locator<GiftCardService>();

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
  //Upload Image to Firebase.
  Future<bool>? insertPrePurchasedGiftCard(
      {required PrePurchasedGiftCard prePurchasedGiftCard}) async {
    if (prePurchasedGiftCard.categoryId.isNotEmpty) {
      await _giftCardService.insertPrePurchasedGiftCardCategory(
          prePurchasedGiftCard: prePurchasedGiftCard);
      return true;
    }
    return false;
  }
}
