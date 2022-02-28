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
      activatedOn: json['activatedOn'] ?? '',
      hours: json['hours'] as num,
      status: $enumDecode(_$ScreenTimeVoucherStatusEnumMap, json['status']),
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$$_ScreenTimePurchaseToJson(
        _$_ScreenTimePurchase instance) =>
    <String, dynamic>{
      'purchaseId': instance.purchaseId,
      'uid': instance.uid,
      'purchasedAt': instance.purchasedAt,
      'activatedOn': instance.activatedOn,
      'hours': instance.hours,
      'status': _$ScreenTimeVoucherStatusEnumMap[instance.status],
      'amount': instance.amount,
    };

const _$ScreenTimeVoucherStatusEnumMap = {
  ScreenTimeVoucherStatus.used: 'used',
  ScreenTimeVoucherStatus.unused: 'unused',
  ScreenTimeVoucherStatus.active: 'active',
};
