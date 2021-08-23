// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_transfer_query_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MoneyTransferQueryConfig _$_$_MoneyTransferQueryConfigFromJson(
    Map<String, dynamic> json) {
  return _$_MoneyTransferQueryConfig(
    type: _$enumDecodeNullable(_$TransferTypeEnumMap, json['type']),
    recipientId: json['recipientId'] as String?,
    senderId: json['senderId'] as String?,
    maxNumberReturns: json['maxNumberReturns'] as int?,
    makeUniqueRecipient: json['makeUniqueRecipient'] as bool?,
  );
}

Map<String, dynamic> _$_$_MoneyTransferQueryConfigToJson(
        _$_MoneyTransferQueryConfig instance) =>
    <String, dynamic>{
      'type': _$TransferTypeEnumMap[instance.type],
      'recipientId': instance.recipientId,
      'senderId': instance.senderId,
      'maxNumberReturns': instance.maxNumberReturns,
      'makeUniqueRecipient': instance.makeUniqueRecipient,
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

const _$TransferTypeEnumMap = {
  TransferType.Sponsor2Explorer: 'Sponsor2Explorer',
  TransferType.Explorer2AFK: 'Explorer2AFK',
};
