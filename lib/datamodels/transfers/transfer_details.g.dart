// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TransferDetails _$$_TransferDetailsFromJson(Map<String, dynamic> json) =>
    _$_TransferDetails(
      recipientId: json['recipientId'] as String,
      recipientName: json['recipientName'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      amount: json['amount'] as num,
      currency: json['currency'] as String,
      sourceType: $enumDecode(_$TransferSourceEnumMap, json['sourceType']),
      createdAt: json['createdAt'] ?? "",
      id: json['id'] as String?,
    );

Map<String, dynamic> _$$_TransferDetailsToJson(_$_TransferDetails instance) =>
    <String, dynamic>{
      'recipientId': instance.recipientId,
      'recipientName': instance.recipientName,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'amount': instance.amount,
      'currency': instance.currency,
      'sourceType': _$TransferSourceEnumMap[instance.sourceType]!,
      'createdAt': instance.createdAt,
      'id': instance.id,
    };

const _$TransferSourceEnumMap = {
  TransferSource.Bank: 'Bank',
  TransferSource.Credits: 'Credits',
};
