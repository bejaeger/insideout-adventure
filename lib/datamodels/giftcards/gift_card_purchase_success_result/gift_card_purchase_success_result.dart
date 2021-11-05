import 'package:freezed_annotation/freezed_annotation.dart';

part 'gift_card_purchase_success_result.freezed.dart';
part 'gift_card_purchase_success_result.g.dart';

// ! Note
// ! Needs to be in line with function
// ! getDefaultReturnObject in giftCardManager.ts

@freezed
class GiftCardPurchaseSuccessResult with _$GiftCardPurchaseSuccessResult {
  factory GiftCardPurchaseSuccessResult({
    required String transferId,
    required bool
        needToProvideGiftCard, // true, in case no pre-purchased gift card was available
  }) = _GiftCardPurchaseSuccessResult;

  factory GiftCardPurchaseSuccessResult.fromJson(Map<String, dynamic> json) =>
      _$GiftCardPurchaseSuccessResultFromJson(json);
}
