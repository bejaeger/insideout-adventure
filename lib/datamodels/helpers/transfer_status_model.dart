import 'dart:async';

import 'package:afkcredits/enums/transfer_dialog_status.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_status_model.freezed.dart';

@freezed
class TransferStatusModel with _$TransferStatusModel {
  factory TransferStatusModel({
    required Future<TransferDialogStatus> futureStatus,
    required TransferType type,
  }) = _TransferStatusModel;
}
