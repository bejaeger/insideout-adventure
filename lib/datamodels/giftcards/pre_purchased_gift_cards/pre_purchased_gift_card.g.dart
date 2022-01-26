// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_purchased_gift_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PrePurchasedGiftCard _$$_PrePurchasedGiftCardFromJson(
        Map<String, dynamic> json) =>
    _$_PrePurchasedGiftCard(
      categoryId: json['categoryId'] as String,
      giftCardCode: json['giftCardCode'] as int,
      categoryName: $enumDecode(_$GiftCardTypeEnumMap, json['categoryName']),
    );

Map<String, dynamic> _$$_PrePurchasedGiftCardToJson(
        _$_PrePurchasedGiftCard instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'giftCardCode': instance.giftCardCode,
      'categoryName': _$GiftCardTypeEnumMap[instance.categoryName],
    };

const _$GiftCardTypeEnumMap = {
  GiftCardType.Playstation: 'Playstation',
  GiftCardType.Xbox: 'Xbox',
  GiftCardType.Steam: 'Steam',
  GiftCardType.Nintendo: 'Nintendo',
};
