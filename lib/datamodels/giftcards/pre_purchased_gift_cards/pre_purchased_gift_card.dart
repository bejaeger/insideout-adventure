import 'package:freezed_annotation/freezed_annotation.dart';

part 'pre_purchased_gift_card.freezed.dart';
part 'pre_purchased_gift_card.g.dart';

@freezed
class PrePurchasedGiftCard with _$PrePurchasedGiftCard {
  factory PrePurchasedGiftCard({
    required String code,
    required String categoryId,
  }) = _PrePurchasedGiftCard;

  factory PrePurchasedGiftCard.fromJson(Map<String, dynamic> json) =>
      _$PrePurchasedGiftCardFromJson(json);
}
