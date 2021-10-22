// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'giftcards.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Giftcards _$_$_GiftcardsFromJson(Map<String, dynamic> json) {
  return _$_Giftcards(
    categoryId: json['categoryId'] as String?,
    amount: (json['amount'] as num?)?.toDouble(),
    imageUrl: json['imageUrl'] as String?,
    categoryName: json['categoryName'] as String?,
  );
}

Map<String, dynamic> _$_$_GiftcardsToJson(_$_Giftcards instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'imageUrl': instance.imageUrl,
      'categoryName': instance.categoryName,
    };
