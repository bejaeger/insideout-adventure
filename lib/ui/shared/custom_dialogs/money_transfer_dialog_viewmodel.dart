import 'dart:async';

import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/helpers/money_transfer_status_model.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/enums/money_transfer_dialog_status.dart';
import 'package:afkcredits/enums/transfer_type.dart';

class MoneyTransferDialogViewModel extends BaseModel {
  final log = getLogger("MoneyTransferDialogViewModel");

  MoneyTransferStatusModel? moneyTransferStatus;
  TransferDialogStatus? status;

  String? title;
  String? description;
  String? mainButtonTitle;
  String? secondaryButtonTitle;

  waitForTransfer({required dynamic request}) async {
    if (request.data["moneyTransferStatus"] == null) {
      log.w(
          "Somehow the completer could not be parsed to the money transfer dialog!");
      _setStatusText(TransferDialogStatus.warning, request);
    } else {
      setBusy(true);
      moneyTransferStatus = request.data["moneyTransferStatus"]!;
      await _waitForTransferAndSetStatusText(moneyTransferStatus!, request);
      setBusy(false);
    }
  }

  Future _waitForTransferAndSetStatusText(
      MoneyTransferStatusModel moneyTransferStatus, dynamic request) async {
    status = await moneyTransferStatus.futureStatus;
    _setStatusText(status!, request, moneyTransferStatus.type);
  }

// Set text for status
// TODO: Ultimately put in app strings file!
  void _setStatusText(TransferDialogStatus status, dynamic request,
      [TransferType? type]) {
    if (status == TransferDialogStatus.error) {
      title = "Transfer Failed";
      description =
          "An internal error occured on our side. Please apologize and try again later";
      mainButtonTitle = "Got it";
    } else if (status == TransferDialogStatus.success) {
      if (type == TransferType.Sponsor2Explorer) {
        title = "Successfully Added Funds";
        mainButtonTitle = "Go Back";
      } else if (type == TransferType.Explorer2AFK) {
        title = "Transfer Successful!";
        mainButtonTitle = "Go Back";
      } else {
        title = "Success!!";
        description = "You are the best!";
        mainButtonTitle = "Go Back";
      }
    } else {
      title = "Warning";
      description =
          "Your transaction could not be processed because of an internal error. We apologize, please try again later.";
      mainButtonTitle = "Go Back";
    }
  }
}
