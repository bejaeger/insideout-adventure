import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/enums/purchased_gift_card_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gift_card_purchase.freezed.dart';
part 'gift_card_purchase.g.dart';

@freezed
class GiftCardPurchase with _$GiftCardPurchase {
  @JsonSerializable(explicitToJson: true)
  const factory GiftCardPurchase({
    required GiftCardCategory giftCardCategory,
    required String uid,
    String? code,
    @Default("") dynamic purchasedAt,
    @Default("placeholder") String transferId,
    @Default(PurchasedGiftCardStatus.initialized)
        PurchasedGiftCardStatus status,
  }) = _GiftCardPurchase;

  factory GiftCardPurchase.fromJson(Map<String, dynamic> json) =>
      _$GiftCardPurchaseFromJson(json);
}
