// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TransferDetails _$_$_TransferDetailsFromJson(Map<String, dynamic> json) {
  return _$_TransferDetails(
    recipientId: json['recipientId'] as String,
    recipientName: json['recipientName'] as String,
    senderId: json['senderId'] as String,
    senderName: json['senderName'] as String,
    amount: json['amount'] as num,
    currency: json['currency'] as String,
    sourceType: _$enumDecode(_$MoneySourceEnumMap, json['sourceType']),
  );
}

Map<String, dynamic> _$_$_TransferDetailsToJson(_$_TransferDetails instance) =>
    <String, dynamic>{
      'recipientId': instance.recipientId,
      'recipientName': instance.recipientName,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'amount': instance.amount,
      'currency': instance.currency,
      'sourceType': _$MoneySourceEnumMap[instance.sourceType],
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

const _$MoneySourceEnumMap = {
  MoneySource.Bank: 'Bank',
  MoneySource.AFKCredits: 'AFKCredits',
};
