// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_card_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GiftCardCategory _$$_GiftCardCategoryFromJson(Map<String, dynamic> json) =>
    _$_GiftCardCategory(
      categoryId: json['categoryId'] as String,
      amount: (json['amount'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      categoryName: $enumDecode(_$GiftCardTypeEnumMap, json['categoryName']),
    );

Map<String, dynamic> _$$_GiftCardCategoryToJson(_$_GiftCardCategory instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'imageUrl': instance.imageUrl,
      'categoryName': _$GiftCardTypeEnumMap[instance.categoryName],
    };

const _$GiftCardTypeEnumMap = {
  GiftCardType.Playstation: 'Playstation',
  GiftCardType.Xbox: 'Xbox',
  GiftCardType.Steam: 'Steam',
  GiftCardType.Nintendo: 'Nintendo',
};
