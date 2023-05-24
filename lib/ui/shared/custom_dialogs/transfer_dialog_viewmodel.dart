import 'dart:async';

import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/helpers/transfer_status_model.dart';
import 'package:afkcredits/enums/transfer_dialog_status.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class TransferDialogViewModel extends BaseModel {
  final log = getLogger("TransferDialogViewModel");

  TransferStatusModel? transferStatus;
  TransferDialogStatus? status;
  String? title;
  String? description;
  String? mainButtonTitle;
  String? secondaryButtonTitle;

  Future waitForTransfer({required dynamic request}) async {
    if (request.data["transferStatus"] == null) {
      log.w(
          "Somehow the completer could not be parsed to the transfer dialog!");
      _setStatusText(TransferDialogStatus.warning, request);
    } else {
      setBusy(true);
      transferStatus = request.data["transferStatus"]!;
      await _waitForTransferAndSetStatusText(transferStatus!, request);
      setBusy(false);
    }
  }

  Future _waitForTransferAndSetStatusText(
      TransferStatusModel transferStatus, dynamic request) async {
    status = await transferStatus.futureStatus;
    _setStatusText(status!, request);
  }

  void _setStatusText(TransferDialogStatus status, dynamic request) {
    if (status == TransferDialogStatus.error) {
      title = "Failure";
      description = "Oops, something went wrong. Please try again later.";
      mainButtonTitle = "Got it";
    } else if (status == TransferDialogStatus.success) {
      title = "Success!";
      description = "Someone will be very happy!";
      mainButtonTitle = "Back";
    } else {
      title = "Warning";
      description =
          "Your transaction could not be processed because of an internal error. We apologize, please try again later.";
      mainButtonTitle = "Go Back";
    }
  }
}
