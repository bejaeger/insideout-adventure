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

  Future waitForTransfer({required dynamic request}) async {
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
      title = "Failure";
      description = "Oops, something went wrong. Please try again later.";
      mainButtonTitle = "Got it";
    } else if (status == TransferDialogStatus.success) {
      if (type == TransferType.Sponsor2Explorer) {
        title = "Successfully Added Funds";
        mainButtonTitle = "Go Back";
      } else if (type == TransferType.Explorer2AFK) {
        title = "Transfer Successful!";
        mainButtonTitle = "Go Back";
      } else if (type == TransferType.GiftCardPurchase) {
        title = "Succesfully Purchased Gift Card!";
        mainButtonTitle = "See Gift Cards";
        secondaryButtonTitle = "Go Back";
      } else if (type == TransferType.ScreenTimePurchase) {
        title = "Succesfully Purchased Screen Time!";
        mainButtonTitle = "See Vouchers";
        secondaryButtonTitle = "Go Back";
      } else {
        title = "Success!";
        description = "Someone will be very happy!";
        mainButtonTitle = "Back";
      }
    } else if (status == TransferDialogStatus.giftCardPending) {
      log.i(
          "The order was succesfull but there was no pre-purchased gift card available!");
      title = "You order was successful!";
      description = "Your gift card code will be available soon!";
      mainButtonTitle = "See Gift Cards";
      secondaryButtonTitle = "Go Back";
    } else {
      title = "Warning";
      description =
          "Your transaction could not be processed because of an internal error. We apologize, please try again later.";
      mainButtonTitle = "Go Back";
    }
  }
}
