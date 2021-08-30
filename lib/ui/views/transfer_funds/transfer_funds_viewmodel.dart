import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
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
import 'package:afkcredits/services/payments/payment_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.form.dart';

class TransferFundsViewModel extends FormViewModel {
  final BottomSheetService? _bottomSheetService = locator<BottomSheetService>();
  final SnackbarService? _snackbarService = locator<SnackbarService>();
  final UserService? _userService = locator<UserService>();
  final DialogService? _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PaymentService _paymentService = locator<PaymentService>();
  User get currentUser => _userService!.currentUser;

  final log = getLogger("AddFundsViewModel");

  final PublicUserInfo recipientInfo;
  final PublicUserInfo senderInfo;
  final TransferType type;

  num? amount;

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
  }

  Future showBottomSheetAndProcessPayment() async {
    if (!isValidData()) {
      log.e("Entered amount not valid");
      notifyListeners();
    } else {
      amount = num.parse(amountValue!);
      if (type == TransferType.Sponsor2Explorer)
        await handleTransfer(type: type);
      //await createStripePayment();
      else if (type == TransferType.Explorer2AFK) {
        await handleTransfer(type: type);
      } else {
        //await createStripePayment();
        _snackbarService!.showSnackbar(
            title: "Not yet implemented.", message: "I know... it's sad");
      }
    }
  }

  // Validate user input, very important function, TODO: should be unit tested!
  bool isValidData() {
    // check if amount is valid!
    if (amountValue == null) {
      log.i("No valid amount");
      setCustomValidationMessage("Please enter valid amount.");
    } else if (amountValue == "") {
      log.i("No valid amount");
      setCustomValidationMessage("Please enter valid amount.");
    } else if (double.parse(amountValue!) < 0) {
      log.i("Amount < 0");
      setCustomValidationMessage("Please enter valid amount.");
    } else if (double.parse(amountValue!) > 1000) {
      log.i("Amount = ${double.parse(amountValue!)}  > 1000");
      setCustomValidationMessage(
          "Are you sure you want to top up as much as ${formatAmount(double.parse(amountValue!), userInput: true)}");
    }
    return customValidationMessage == null;
  }

  Future handleTransfer({required TransferType type}) async {
    // -----------------------------------------------------
    // First we need to ask for the payment method and
    // will also ask for a final confirmation
    // For now, it's only test payments allowed
    SheetResponse? sheetResponse =
        await _showPaymentMethodBottomSheet(type: type);
    if (sheetResponse?.confirmed == false) {
      await _showAndAwaitSnackbar("Not supported at the moment, sorry!");
    } else if (sheetResponse?.confirmed == true) {
      // Ask for another final confirmation
      SheetResponse? finalConfirmation =
          await _showFinalConfirmationBottomSheet();
      if (finalConfirmation?.confirmed == false) {
        await _showAndAwaitSnackbar("You can come back any time :)");
        setBusy(false);
        navigateBack();
        return;
      } else if (finalConfirmation?.confirmed == true) {
        // -----------------------------------------------------
        // We create a completer and parse it to the pop-up window.
        // The pop-up window shows a progress indicator and
        // displays a success or error dialog when the completer is completed
        // in _processsPayment.
        var moneyTransferCompleter = Completer<TransferDialogStatus>();

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
        if (dialogResult!.confirmed) {
          if (type == TransferType.Sponsor2Explorer) {
            // navigate back to money pool
            navigateBack();
          } else {
            // clear view
            clearTillFirstAndShowExplorerHomeScreen();
          }
          return;
        }
      }
      return;
    }
    // barrier has been dismissed, nothing todo
  }

  Future _processPayment(
      Completer<TransferDialogStatus> moneyTransferCompleter) async {
    // FOR now, implemented dummy payment processing here
    try {
      final data = prepareTransferData();

      await _paymentService.processTransfer(moneyTransfer: data);

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
  MoneyTransfer prepareTransferData() {
    try {
      final transferDetails = TransferDetails(
        recipientId: recipientInfo.uid,
        recipientName: recipientInfo.name,
        senderId: senderInfo.uid,
        senderName: senderInfo.name,
        sourceType: MoneySource.Bank,
        amount: scaleAmountForStripe(amount!),
        currency: 'cad',
      );
      MoneyTransfer data = MoneyTransfer(transferDetails: transferDetails);
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
    return await _dialogService!.showDialog(
      title: title,
      description: description,
      dialogPlatform: DialogPlatform.Material,
    );
  }

  Future _showFinalConfirmationBottomSheet() async {
    return await _bottomSheetService!.showBottomSheet(
      barrierDismissible: true,
      title: 'Confirmation',
      description:
          "Are you sure you would like to send ${formatAmount(amount, userInput: true)} to ${recipientInfo.name}?",
      confirmButtonTitle: 'Yes',
      cancelButtonTitle: 'No',
    );
  }

  Future _showMoneyTransferDialog(
      {required Completer<TransferDialogStatus> moneyTransferCompleter,
      required TransferType type}) async {
    log.i("We are starting the dialog");
    final dialogResult = await _dialogService!.showCustomDialog(
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
  // Navigations
  //
  void clearTillFirstAndShowExplorerHomeScreen() {
    _navigationService.clearTillFirstAndShow(Routes.explorerHomeView);
  }

  void clearTillFirstAndShowSponsorHomeScreen() {
    _navigationService.clearTillFirstAndShow(Routes.sponsorHomeView);
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
    // THIS IS A HACK!
    // Otherwise the customvalidation message is overwritten before showing!
    // Need to fix this properly at some point!
    await Future.delayed(Duration(seconds: 4));
    log.i("Set custom Form status");
    customValidationMessage = null;
  }
}
