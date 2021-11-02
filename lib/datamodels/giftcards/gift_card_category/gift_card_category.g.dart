// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_card_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GiftCardCategory _$_$_GiftCardCategoryFromJson(Map<String, dynamic> json) {
  return _$_GiftCardCategory(
    categoryId: json['categoryId'] as String,
    amount: (json['amount'] as num).toDouble(),
    imageUrl: json['imageUrl'] as String?,
    categoryName: _$enumDecode(_$GiftCardTypeEnumMap, json['categoryName']),
  );
}

Map<String, dynamic> _$_$_GiftCardCategoryToJson(
        _$_GiftCardCategory instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'imageUrl': instance.imageUrl,
      'categoryName': _$GiftCardTypeEnumMap[instance.categoryName],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$GiftCardTypeEnumMap = {
  GiftCardType.Playstation: 'Playstation',
  GiftCardType.Xbox: 'Xbox',
  GiftCardType.Steam: 'Steam',
};
