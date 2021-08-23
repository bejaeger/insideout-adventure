// Model that has holds some functions for showing transfer information

import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/datamodels/payments/money_transfer_query_config.dart';
import 'package:flutter/foundation.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class TransferBaseViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();

  // Listeners for transfers
  MoneyTransferQueryConfig get queryConfig =>
      MoneyTransferQueryConfig(senderId: userService.currentUser.uid);
  List<MoneyTransfer> get latestTransfers =>
      transfersHistoryService.getTransfers(config: queryConfig);

  Future showMoneyTransferInfoDialog(MoneyTransfer transfer) async {
    final details = transfer.transferDetails;
    final String senderName = details.senderName;
    final String recipientName = details.recipientName;
    final String amount = formatAmount(details.amount);
    final String source = describeEnum(details.sourceType.toString());
    final String date =
        DateFormat.yMd().add_jm().format(transfer.createdAt.toDate());
    return await _dialogService.showDialog(
      title: "Details",
      description:
          "From: $senderName\nTo: $recipientName\nAmount: $amount\nDate: $date\nSource: $source",
    );
  }
}
