import 'dart:async';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/credits_system.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/helpers/transfer_status_model.dart';
import 'package:afkcredits/datamodels/transfers/transfer.dart';
import 'package:afkcredits/datamodels/transfers/transfer_details.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/transfer_dialog_status.dart';
import 'package:afkcredits/enums/transfer_source.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/transfer_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TransferFundsViewModel extends FormViewModel with NavigationMixin {
  final BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  final SnackbarService? _snackbarService = locator<SnackbarService>();
  final UserService _userService = locator<UserService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final log = getLogger("AddFundsViewModel");

  User get currentUser => _userService.currentUser;

  num? amount;
  num? screenTimeEquivalent;

  final PublicUserInfo recipientInfo;
  final PublicUserInfo senderInfo;
  TransferFundsViewModel(
      {required this.recipientInfo, required this.senderInfo});

  // The functionality from stacked's form view is
  // not working properly (not sure exactly why).
  // This has to do with how we wrap the entire
  // App with the Unfocuser, see main.dart.
  // For the time being we just use our own validation
  // message string
  String? customValidationMessage;
  void setCustomValidationMessage(String msg) {
    customValidationMessage = msg;
    notifyListeners();
  }

  Future showBottomSheetAndProcessTransfer() async {
    if (!isValidData()) {
      log.e("Entered amount not valid");
      notifyListeners();
    } else {
      amount = num.parse(amountValue!);
      return await handleTransfer();
    }
  }

  // TODO: should be unit tested!
  bool isValidData([bool setNoMessage = false]) {
    bool returnValue = true;
    if (amountValue == null || amountValue == "" || amountValue == "-") {
      log.w("No valid amount");
      returnValue = false;
      if (!setNoMessage)
        setCustomValidationMessage("Please enter valid amount.");
    } else if (int.tryParse(amountValue!) == null) {
      log.w("amount not int");
      returnValue = false;
      if (!setNoMessage)
        setCustomValidationMessage("Please enter a whole number.");
    } else if (double.parse(amountValue!) > 1000) {
      log.w("Amount = ${double.parse(amountValue!)}  > 1000");
      returnValue = false;
      if (!setNoMessage)
        setCustomValidationMessage(
            "You cannot top up more than 1000 credits at once");
    }
    return returnValue;
  }

  Future handleTransfer() async {
    SheetResponse? finalConfirmation =
        await _showFinalConfirmationBottomSheet();
    if (finalConfirmation?.confirmed == false) {
      setBusy(false);
      return false;
    } else if (finalConfirmation?.confirmed == true) {
      // We create a completer and parse it to the pop-up window.
      // The pop-up window shows a progress indicator and
      // displays a success or error dialog when the completer is completed
      // in _processsTransfer.
      var transferCompleter = Completer<TransferDialogStatus>();
      try {
        _processTransfer(transferCompleter);
      } catch (e) {
        log.wtf("Something very mysterious went wrong, error thrown: $e");
        transferCompleter.complete(TransferDialogStatus.error);
      }
      dynamic dialogResult =
          await _showTransferDialog(transferCompleter: transferCompleter);

      if (dialogResult?.confirmed == true) {
        popView();
      }
      return true;
    }
    return;
  }

  Future _processTransfer(
      Completer<TransferDialogStatus> transferCompleter) async {
    try {
      final Transfer data = prepareTransferData();
      await Future.delayed(Duration(milliseconds: 300)); // artificial delay
      // Possible Improvements
      //  - make entry in transfer history!
      //  - notification in ward account
      //  - history visible for guardian and ward
      //  - option to add description to transfer for guardian
      final res = await _firestoreApi.changeCreditsBalanceCheat(
          uid: data.transferDetails.recipientId,
          deltaCredits: data.transferDetails.amount);
      if (res is String) {
        if (res == WarningFirestoreCallTimeout) {
          await _dialogService.showDialog(
              title: "Unstable network connection",
              description:
                  "The credits were nevertheless added and will be synchronized across devices later.");
        }
      }

      log.i("Processed transfer: $data");

      // the completion event will be listened to in the pop-up dialog
      transferCompleter.complete(TransferDialogStatus.success);
    } catch (e) {
      log.e("Error when processing transfer, error thrown $e");
      if (e is TransferException) {
        transferCompleter.complete(TransferDialogStatus.error);
      } else if (e is UserServiceException) {
        transferCompleter.complete(TransferDialogStatus.error);
      } else if (e is FirestoreApiException) {
        transferCompleter.complete(TransferDialogStatus.error);
      } else {
        rethrow;
      }
      return;
    }
  }

  // returning the transfer object that will be pushed to firestore
  Transfer prepareTransferData() {
    try {
      final transferDetails = TransferDetails(
        recipientId: recipientInfo.uid,
        recipientName: recipientInfo.name,
        senderId: senderInfo.uid,
        senderName: senderInfo.name,
        sourceType: TransferSource.Bank,
        amount: amount!,
        currency: 'cad',
      );
      Transfer data = Transfer(
          type: TransferType.Guardian2WardCredits /* legacy */,
          transferDetails: transferDetails);
      return data;
    } catch (e) {
      log.e(
          "Could not fill transaction model, Failed with error ${e.toString()}");
      throw TransferException(
          message:
              "Something went wrong when preparing the transfer. We apologize, please contact support or try again later.",
          prettyDetails:
              "Something went wrong when preparing the transfer. We apologize, please contact support or try again later.",
          devDetails: '$e');
    }
  }

  void navigateBack() {
    _navigationService.back();
  }

  Future _showFinalConfirmationBottomSheet() async {
    return await _bottomSheetService!.showBottomSheet(
      barrierDismissible: true,
      title: 'Confirmation',
      description:
          "Are you sure you would like to send $amount credits to ${recipientInfo.name}?",
      confirmButtonTitle: 'YES',
      cancelButtonTitle: 'NO',
    );
  }

  Future _showTransferDialog({
    required Completer<TransferDialogStatus> transferCompleter,
  }) async {
    log.i("We are starting the dialog");
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.Transfer,
      data: {
        "transferStatus": TransferStatusModel(
          futureStatus: transferCompleter.future,
          type: TransferType.Guardian2WardCredits, // legacy code
        )
      },
    );
    return dialogResult;
  }

  Future showNotYetImplementedSnackbar() async {
    _snackbarService!.showSnackbar(
        title: "Not yet implemented.", message: "I know... it's sad");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setFormStatus() async {
    log.i("Set custom Form status");
    if (amountValue != null && amountValue != "") {
      if (isValidData(true)) {
        num tmpamount = int.parse(amountValue!);
        screenTimeEquivalent = CreditsSystem.creditsToScreenTime(tmpamount);
      }
    }
    await Future.delayed(Duration(milliseconds: 2000));
    customValidationMessage = null;
  }
}
