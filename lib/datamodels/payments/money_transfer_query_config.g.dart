// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_transfer_query_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MoneyTransferQueryConfig _$$_MoneyTransferQueryConfigFromJson(
        Map<String, dynamic> json) =>
    _$_MoneyTransferQueryConfig(
      type: $enumDecodeNullable(_$TransferTypeEnumMap, json['type']),
      recipientId: json['recipientId'] as String?,
      senderId: json['senderId'] as String?,
      maxNumberReturns: json['maxNumberReturns'] as int?,
      makeUniqueRecipient: json['makeUniqueRecipient'] as bool?,
    );

Map<String, dynamic> _$$_MoneyTransferQueryConfigToJson(
        _$_MoneyTransferQueryConfig instance) =>
    <String, dynamic>{
      'type': _$TransferTypeEnumMap[instance.type],
      'recipientId': instance.recipientId,
      'senderId': instance.senderId,
      'maxNumberReturns': instance.maxNumberReturns,
      'makeUniqueRecipient': instance.makeUniqueRecipient,
    };

const _$TransferTypeEnumMap = {
  TransferType.Sponsor2Explorer: 'Sponsor2Explorer',
  TransferType.Explorer2AFK: 'Explorer2AFK',
  TransferType.GiftCardPurchase: 'GiftCardPurchase',
};
