import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:afkcredits/enums/transfer_type.dart';

part 'money_transfer_query_config.freezed.dart';
part 'money_transfer_query_config.g.dart';

@freezed
class MoneyTransferQueryConfig with _$MoneyTransferQueryConfig {
  const factory MoneyTransferQueryConfig({
    TransferType? type,
    String? recipientId,
    String? senderId,
    // Map<String, String>?
    //     isEqualToFilter, // e.g. {"moneyPoolInfo.moneyPoolId": moneyPool.moneyPoolId},
    int? maxNumberReturns,
    bool? makeUniqueRecipient,
  }) = _MoneyTransferQueryConfig;

  factory MoneyTransferQueryConfig.fromJson(Map<String, dynamic> json) =>
      _$MoneyTransferQueryConfigFromJson(json);
}
