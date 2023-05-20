// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MoneyTransfer _$$_MoneyTransferFromJson(Map<String, dynamic> json) =>
    _$_MoneyTransfer(
      transferDetails: TransferDetails.fromJson(
          json['transferDetails'] as Map<String, dynamic>),
      createdAt: json['createdAt'] ?? "",
      status: $enumDecodeNullable(_$TransferStatusEnumMap, json['status']) ??
          TransferStatus.Initialized,
      type: $enumDecodeNullable(_$TransferTypeEnumMap, json['type']) ??
          TransferType.Guardian2WardCredits,
      transferId: json['transferId'] as String? ?? "placeholder",
    );

Map<String, dynamic> _$$_MoneyTransferToJson(_$_MoneyTransfer instance) =>
    <String, dynamic>{
      'transferDetails': instance.transferDetails.toJson(),
      'createdAt': instance.createdAt,
      'status': _$TransferStatusEnumMap[instance.status]!,
      'type': _$TransferTypeEnumMap[instance.type]!,
      'transferId': instance.transferId,
    };

const _$TransferStatusEnumMap = {
  TransferStatus.Initialized: 'Initialized',
  TransferStatus.Success: 'Success',
  TransferStatus.Pending: 'Pending',
};

const _$TransferTypeEnumMap = {
  TransferType.Guardian2WardCredits: 'Guardian2WardCredits',
};
