import 'dart:async';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/helpers/money_transfer_status_model.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/datamodels/payments/transfer_details.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/money_source.dart';
import 'package:afkcredits/enums/money_transfer_dialog_status.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/money_transfer_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.form.dart';

class TransferFundsViewModel extends FormViewModel with NavigationMixin {
  final BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  final SnackbarService? _snackbarService = locator<SnackbarService>();
  final UserService _userService = locator<UserService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();

  User get currentUser => _userService.currentUser;

  final log = getLogger("AddFundsViewModel");

  final PublicUserInfo recipientInfo;
  final PublicUserInfo senderInfo;
  final TransferType type;

  num? amount;
  num? screenTimeEquivalent;

  TransferFundsViewModel(
      {required this.type,
      required this.recipientInfo,
      required this.senderInfo});

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

  Future showBottomSheetAndProcessPayment() async {
    if (!isValidData()) {
      log.e("Entered amount not valid");
      notifyListeners();
    } else {
      amount = num.parse(amountValue!);
      if (type == TransferType.Sponsor2Explorer ||
          type == TransferType.Explorer2AFK) {
        return await handleTransfer(type: type);
      }
      else if (type == TransferType.Sponsor2ExplorerCredits) {
        return await handleTransfer(type: type);
      } else {
        _snackbarService!.showSnackbar(
            title: "Not yet implemented.", message: "I know... it's sad");
      }
    }
  }

  // Validate user input, very important function, TODO: should be unit tested!
  bool isValidData([bool setNoMessage = false]) {
    // check if amount is valid!
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
      //}
      // else if (double.parse(amountValue!) < 0) {
      //   log.w("Amount < 0");
      //   returnValue = false;
      //   if (!setNoMessage)
      //     setCustomValidationMessage("Please enter valid amount.");
    } else if (double.parse(amountValue!) > 1000) {
      log.w("Amount = ${double.parse(amountValue!)}  > 1000");
      returnValue = false;
      if (!setNoMessage)
        setCustomValidationMessage(
            "You cannot top up more than 1000 credits at once");
      // ${formatAmount(double.parse(amountValue!), userInput: true)}
    }
    return returnValue;
  }

  Future handleTransfer({required TransferType type}) async {
    // -----------------------------------------------------
    // First we need to ask for the payment method and
    // will also ask for a final confirmation
    // For now, it's only test payments allowed
    SheetResponse? sheetResponse;
    if (type != TransferType.Sponsor2ExplorerCredits) {
      sheetResponse = await _showPaymentMethodBottomSheet(type: type);
    } else {
      sheetResponse = SheetResponse(confirmed: true);
    }
    if (sheetResponse?.confirmed == false) {
      await _showAndAwaitSnackbar("Not supported at the moment, sorry!");
    } else if (sheetResponse?.confirmed == true) {
      // Ask for another final confirmation
      SheetResponse? finalConfirmation =
          await _showFinalConfirmationBottomSheet(type: type);
      if (finalConfirmation?.confirmed == false) {
        // await _showAndAwaitSnackbar("You can come back any time :)");
        setBusy(false);
        //navigateBack();
        return false;
      } else if (finalConfirmation?.confirmed == true) {
        // -----------------------------------------------------
        // We create a completer and parse it to the pop-up window.
        // The pop-up window shows a progress indicator and
        // displays a success or error dialog when the completer is completed
        // in _processsPayment.
        var moneyTransferCompleter = Completer<TransferDialogStatus>();

        // TODO: Check that transfer actually works!!!!!!!!!!!!

        try {
          _processPayment(moneyTransferCompleter);
        } catch (e) {
          log.wtf("Something very mysterious went wrong, error thrown: $e");
          moneyTransferCompleter.complete(TransferDialogStatus.error);
        }
        dynamic dialogResult = await _showMoneyTransferDialog(
            moneyTransferCompleter: moneyTransferCompleter, type: type);

        // -----------------------------------------------------
        // Handle user input after success or error of transfer!
        // Navigation depends on user input and transfer type;
        if (dialogResult?.confirmed == true) {
          if (type == TransferType.Sponsor2Explorer ||
              type == TransferType.Sponsor2ExplorerCredits) {
            // navigate back to home
            popView();
          }
          return true;
        }
        return true;
      }
      return;
    }
    // barrier has been dismissed, nothing todo
  }

  Future _processPayment(
      Completer<TransferDialogStatus> moneyTransferCompleter) async {
    // FOR now, implemented dummy payment processing here
    try {
      final MoneyTransfer data = prepareTransferData(type: type);
      if (data.type != TransferType.Sponsor2ExplorerCredits) {
        throw MoneyTransferException(
            message: "Type of transfer not supported at the moment!",
            devDetails:
                "This is from a previous version of the app. Just kept it for lookup");
        //await _paymentService.processTransfer(moneyTransfer: data);
      } else {
        await Future.delayed(Duration(milliseconds: 300)); // artificial delay
        // TODO: Improve backend here!
        // TODO: - make entry in transfer history!
        // TODO: - notification in explorer account
        // TODO: - history visible for parent and explorer
        // TODO: - option to add description to transfer for parents
        final res = await _firestoreApi.changeAfkCreditsBalanceCheat(
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
      }

      log.i("Processed transfer: $data");

      // the completion event will be listened to in the pop-up dialog
      moneyTransferCompleter.complete(TransferDialogStatus.success);
    } catch (e) {
      log.e("Error when processing payment, error thrown $e");
      if (e is MoneyTransferException) {
        moneyTransferCompleter.complete(TransferDialogStatus.error);
      } else if (e is UserServiceException) {
        moneyTransferCompleter.complete(TransferDialogStatus.error);
      } else if (e is FirestoreApiException) {
        moneyTransferCompleter.complete(TransferDialogStatus.error);
      } else {
        rethrow;
      }
      return;
    }
  }

  // returning the money transfer object that will be pushed to firestore
  MoneyTransfer prepareTransferData({required TransferType type}) {
    try {
      final transferDetails = TransferDetails(
        recipientId: recipientInfo.uid,
        recipientName: recipientInfo.name,
        senderId: senderInfo.uid,
        senderName: senderInfo.name,
        sourceType: MoneySource.Bank,
        amount: type != TransferType.Sponsor2ExplorerCredits
            ? scaleAmountForStripe(amount!)
            : amount!,
        currency: 'cad',
      );
      MoneyTransfer data =
          MoneyTransfer(type: type, transferDetails: transferDetails);
      return data;
    } catch (e) {
      log.e(
          "Could not fill transaction model, Failed with error ${e.toString()}");
      throw MoneyTransferException(
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

  /////////////////////////////////////////////////////////////////////
  // Pop-ups!

  Future _showAndAwaitSnackbar(String message) async {
    _snackbarService!.showSnackbar(
        duration: Duration(seconds: 2), title: message, message: "");
    await Future.delayed(Duration(seconds: 2));
  }

  Future _showPaymentMethodBottomSheet({TransferType? type}) async {
    String description =
        "This version does not have any actual payment processors integrated, just continue with test payment ;). ";
    return await _bottomSheetService!.showBottomSheet(
        barrierDismissible: true,
        title: "Select Payment Method",
        description: description,
        confirmButtonTitle: "Test Payment");
    //cancelButtonTitle: "Test Payment");
  }

  Future showHelpDialog(TransferType type) async {
    late String title;
    late String description;
    if (type == TransferType.Sponsor2Explorer) {
      title = "Sponsor an Explorer!";
      description =
          "The funds you transfer can be earned by the explorer by doing quests!";
    } else if (type == TransferType.Explorer2AFK) {
      title = "Buy gift cards";
      description = "Buy gift cards and use them in your favorite games";
    } else {
      title = "Ooopss";
      description =
          "You should not end up here, please let the developers know ;)";
    }
    return await _dialogService.showDialog(
      title: title,
      description: description,
      dialogPlatform: DialogPlatform.Material,
    );
  }

  Future _showFinalConfirmationBottomSheet({required TransferType type}) async {
    if (type != TransferType.Sponsor2ExplorerCredits) {
      return await _bottomSheetService!.showBottomSheet(
        barrierDismissible: true,
        title: 'Confirmation',
        description:
            "Are you sure you would like to send ${formatAmount(amount, userInput: true)} to ${recipientInfo.name}?",
        confirmButtonTitle: 'YES',
        cancelButtonTitle: 'NO',
      );
    } else {
      return await _bottomSheetService!.showBottomSheet(
        barrierDismissible: true,
        title: 'Confirmation',
        description:
            "Are you sure you would like to send $amount credits to ${recipientInfo.name}?",
        confirmButtonTitle: 'YES',
        cancelButtonTitle: 'NO',
      );
    }
  }

  Future _showMoneyTransferDialog(
      {required Completer<TransferDialogStatus> moneyTransferCompleter,
      required TransferType type}) async {
    log.i("We are starting the dialog");
    final dialogResult = await _dialogService.showCustomDialog(
      variant: DialogType.MoneyTransfer,
      data: {
        "moneyTransferStatus": MoneyTransferStatusModel(
          futureStatus: moneyTransferCompleter.future,
          type: type,
        )
      },
    );
    return dialogResult;
  }

  Future showNotYetImplementedSnackbar() async {
    _snackbarService!.showSnackbar(
        title: "Not yet implemented.", message: "I know... it's sad");
  }


  ////////////////////////////////////////////////////////////////
  /// Clean-up
  //
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
        screenTimeEquivalent = creditsToScreenTime(tmpamount);
      }
    }
    await Future.delayed(Duration(milliseconds: 2000));
    customValidationMessage = null;
  }

  // @override
  // void setFormStatus() async {
  //   // THIS IS A HACK!
  //   // Otherwise the customvalidation message is overwritten before showing!
  //   // Need to fix this properly at some point!
  //   await Future.delayed(Duration(seconds: 4));
  //   log.i("Set custom Form status");
  //   customValidationMessage = null;
  // }
}
