// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_card_purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GiftCardPurchase _$$_GiftCardPurchaseFromJson(Map<String, dynamic> json) =>
    _$_GiftCardPurchase(
      giftCardCategory: GiftCardCategory.fromJson(
          json['giftCardCategory'] as Map<String, dynamic>),
      uid: json['uid'] as String,
      code: json['code'] as String?,
      purchasedAt: json['purchasedAt'] ?? "",
      transferId: json['transferId'] as String? ?? "placeholder",
      status: $enumDecodeNullable(
              _$PurchasedGiftCardStatusEnumMap, json['status']) ??
          PurchasedGiftCardStatus.initialized,
    );

Map<String, dynamic> _$$_GiftCardPurchaseToJson(_$_GiftCardPurchase instance) =>
    <String, dynamic>{
      'giftCardCategory': instance.giftCardCategory.toJson(),
      'uid': instance.uid,
      'code': instance.code,
      'purchasedAt': instance.purchasedAt,
      'transferId': instance.transferId,
      'status': _$PurchasedGiftCardStatusEnumMap[instance.status]!,
    };

const _$PurchasedGiftCardStatusEnumMap = {
  PurchasedGiftCardStatus.redeemed: 'redeemed',
  PurchasedGiftCardStatus.available: 'available',
  PurchasedGiftCardStatus.pending: 'pending',
  PurchasedGiftCardStatus.initialized: 'initialized',
};
