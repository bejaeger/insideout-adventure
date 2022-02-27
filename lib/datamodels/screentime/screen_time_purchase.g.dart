// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_time_purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ScreenTimePurchase _$$_ScreenTimePurchaseFromJson(
        Map<String, dynamic> json) =>
    _$_ScreenTimePurchase(
      purchaseId: json['purchaseId'] as String,
      uid: json['uid'] as String,
      purchasedAt: json['purchasedAt'] ?? '',
      redeemedAt: json['redeemedAt'] ?? '',
      hours: json['hours'] as num,
      status: $enumDecode(_$ScreenTimeVoucherStatusEnumMap, json['status']),
      amount: json['amount'] as int,
    );

Map<String, dynamic> _$$_ScreenTimePurchaseToJson(
        _$_ScreenTimePurchase instance) =>
    <String, dynamic>{
      'purchaseId': instance.purchaseId,
      'uid': instance.uid,
      'purchasedAt': instance.purchasedAt,
      'redeemedAt': instance.redeemedAt,
      'hours': instance.hours,
      'status': _$ScreenTimeVoucherStatusEnumMap[instance.status],
      'amount': instance.amount,
    };

const _$ScreenTimeVoucherStatusEnumMap = {
  ScreenTimeVoucherStatus.used: 'used',
  ScreenTimeVoucherStatus.unused: 'unused',
};
