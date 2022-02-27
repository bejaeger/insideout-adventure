import 'package:afkcredits/enums/screen_time_voucher_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_time_purchase.freezed.dart';
part 'screen_time_purchase.g.dart';

@freezed
class ScreenTimePurchase with _$ScreenTimePurchase {
  factory ScreenTimePurchase({
    required String purchaseId,
    required String uid,
    @Default("") dynamic purchasedAt,
    @Default("") dynamic redeemedAt,
    required num hours,
    required ScreenTimeVoucherStatus status,
    required int amount,
  }) = _ScreenTimePurchase;

  factory ScreenTimePurchase.fromJson(Map<String, dynamic> json) =>
      _$ScreenTimePurchaseFromJson(json);
}
