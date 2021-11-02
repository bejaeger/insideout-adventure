// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_purchased_gift_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PrePurchasedGiftCard _$_$_PrePurchasedGiftCardFromJson(
    Map<String, dynamic> json) {
  return _$_PrePurchasedGiftCard(
    code: json['code'] as String,
    categoryId: json['categoryId'] as String,
    amount: (json['amount'] as num).toDouble(),
  );
}

Map<String, dynamic> _$_$_PrePurchasedGiftCardToJson(
        _$_PrePurchasedGiftCard instance) =>
    <String, dynamic>{
      'code': instance.code,
      'categoryId': instance.categoryId,
      'amount': instance.amount,
    };
