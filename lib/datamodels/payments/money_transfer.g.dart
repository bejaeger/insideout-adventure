// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MoneyTransfer _$_$_MoneyTransferFromJson(Map<String, dynamic> json) {
  return _$_MoneyTransfer(
    transferDetails: TransferDetails.fromJson(
        json['transferDetails'] as Map<String, dynamic>),
    createdAt: json['createdAt'] ?? '',
    status: _$enumDecodeNullable(_$TransferStatusEnumMap, json['status']) ??
        TransferStatus.Initialized,
    type: _$enumDecodeNullable(_$TransferTypeEnumMap, json['type']) ??
        TransferType.Sponsor2Explorer,
    transferId: json['transferId'] as String,
  );
}

Map<String, dynamic> _$_$_MoneyTransferToJson(_$_MoneyTransfer instance) =>
    <String, dynamic>{
      'transferDetails': instance.transferDetails.toJson(),
      'createdAt': instance.createdAt,
      'status': _$TransferStatusEnumMap[instance.status],
      'type': _$TransferTypeEnumMap[instance.type],
      'transferId': instance.transferId,
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

const _$TransferStatusEnumMap = {
  TransferStatus.Initialized: 'Initialized',
  TransferStatus.Success: 'Success',
  TransferStatus.Pending: 'Pending',
};

const _$TransferTypeEnumMap = {
  TransferType.Sponsor2Explorer: 'Sponsor2Explorer',
  TransferType.Explorer2AFK: 'Explorer2AFK',
  TransferType.GiftCardPurchase: 'GiftCardPurchase',
};
