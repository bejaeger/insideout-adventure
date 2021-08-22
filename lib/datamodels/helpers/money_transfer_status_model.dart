import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:afkcredits/enums/money_transfer_dialog_status.dart';
import 'package:afkcredits/enums/transfer_type.dart';

part 'money_transfer_status_model.freezed.dart';

@freezed
class MoneyTransferStatusModel with _$MoneyTransferStatusModel {
  factory MoneyTransferStatusModel({
    required Future<TransferDialogStatus> futureStatus,
    required TransferType type,
  }) = _MoneyTransferStatusModel;
}
