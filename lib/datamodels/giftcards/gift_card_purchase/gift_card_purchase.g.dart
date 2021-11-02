// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_card_purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GiftCardPurchase _$_$_GiftCardPurchaseFromJson(Map<String, dynamic> json) {
  return _$_GiftCardPurchase(
    giftCardCategory: GiftCardCategory.fromJson(
        json['giftCardCategory'] as Map<String, dynamic>),
    uid: json['uid'] as String,
    code: json['code'] as String?,
    purchasedAt: json['purchasedAt'] ?? '',
    transferId: json['transferId'] as String? ?? 'placeholder',
    status: _$enumDecodeNullable(
            _$PurchasedGiftCardStatusEnumMap, json['status']) ??
        PurchasedGiftCardStatus.initialized,
  );
}

Map<String, dynamic> _$_$_GiftCardPurchaseToJson(
        _$_GiftCardPurchase instance) =>
    <String, dynamic>{
      'giftCardCategory': instance.giftCardCategory,
      'uid': instance.uid,
      'code': instance.code,
      'purchasedAt': instance.purchasedAt,
      'transferId': instance.transferId,
      'status': _$PurchasedGiftCardStatusEnumMap[instance.status],
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$PurchasedGiftCardStatusEnumMap = {
  PurchasedGiftCardStatus.redeemed: 'redeemed',
  PurchasedGiftCardStatus.available: 'available',
  PurchasedGiftCardStatus.pending: 'pending',
  PurchasedGiftCardStatus.initialized: 'initialized',
};
