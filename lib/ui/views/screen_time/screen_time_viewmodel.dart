import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/datamodels/helpers/money_transfer_status_model.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_purchase.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/money_transfer_dialog_status.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/money_transfer_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';

// !!! DEPRECATED !!!

class ScreenTimeViewModel extends BaseModel with NavigationMixin {
  // ------------------------------------------------
  // Services
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();
  final log = getLogger("ScreenTimeViewModel");

  // -------------------------------------------
  // Functions

  List<ScreenTimePurchase> getScreenTimeCategories() {
    return getDummyScreenTimes(uid: currentUser.uid);
  }

  Future handleScreenTimePurchase(ScreenTimePurchase screenTimePurchase) async {
    DialogResponse? dialogResponse = await dialogService.showCustomDialog(
        variant: DialogType.PurchaseScreenTime,
        data: screenTimePurchase,
        mainButtonTitle: 'Purchase',
        barrierDismissible: true,
        secondaryButtonTitle: 'Cancel');

    if (dialogResponse?.confirmed == true) {
      // Make quick check if available AFK Credits are enough
      if (!hasEnoughBalance(screenTimePurchase.amount)) {
        await dialogService.showDialog(
            title: "You don't have enough AFK Credits",
            description: "Continue earning ;)");
        return;
      }

      // Ask for another final confirmation
      SheetResponse? finalConfirmation =
          await _showFinalConfirmationBottomSheetScreenTime(
              afkCredits: centsToAfkCredits(screenTimePurchase.amount),
              screenTime: screenTimePurchase.hours);

      if (finalConfirmation?.confirmed == false) {
        await _showAndAwaitSnackbar("You can come back any time :)");
        return;
      } else if (finalConfirmation?.confirmed == true) {
        // -----------------------------------------------------
        // We create a completer and parse it to the pop-up window.
        // The pop-up window shows a progress indicator and
        // displays a success or error dialog when the completer is completed
        // in _processsPayment.
        var purchaseCompleter = Completer<TransferDialogStatus>();
        try {
          _processScreenTimePayment(purchaseCompleter, screenTimePurchase);
        } catch (e) {
          log.wtf(
              "Something very mysterious went wrong when purchasing gift card, error thrown: $e");
          purchaseCompleter.complete(TransferDialogStatus.error);
        }
        dynamic dialogResult = await _showMoneyTransferDialog(
            moneyTransferCompleter: purchaseCompleter,
            type: TransferType.ScreenTimePurchase);

        if (dialogResult?.confirmed == true &&
            (await purchaseCompleter.future != TransferDialogStatus.error ||
                await purchaseCompleter.future !=
                    TransferDialogStatus.warning)) {
          log.i("Navigating to purchased screen time view");
          await navigationService.navigateTo(Routes.purchasedScreenTimeView);
        }
        return;
      }
    }
  }

  Future _processScreenTimePayment(
      Completer<TransferDialogStatus> purchaseCompleter,
      ScreenTimePurchase screenTimePurchase) async {
    // FOR now, implemented dummy payment processing here
    try {
      await _screenTimeService.purchaseScreenTime(
          screenTimePurchase: screenTimePurchase);
      log.i("screen time purchased: $screenTimePurchase");
      // the completion event will be listened to in the pop-up dialog
      purchaseCompleter.complete(TransferDialogStatus.success);
    } catch (e) {
      log.e("Error when processing gift card purchase, error thrown $e");
      if (e is MoneyTransferException) {
        purchaseCompleter.complete(TransferDialogStatus.error);
      } else if (e is UserServiceException) {
        purchaseCompleter.complete(TransferDialogStatus.error);
      } else if (e is FirestoreApiException) {
        purchaseCompleter.complete(TransferDialogStatus.error);
      } else {
        rethrow;
      }
      return;
    }
  }

  Future _showMoneyTransferDialog(
      {required Completer<TransferDialogStatus> moneyTransferCompleter,
      required TransferType type}) async {
    log.i("We are starting the dialog");
    final dialogResult = await dialogService.showCustomDialog(
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

  Future _showAndAwaitSnackbar(String message) async {
    snackbarService.showSnackbar(
        duration: Duration(seconds: 2), title: message, message: "");
    await Future.delayed(Duration(seconds: 2));
  }

  // bottom sheets
  Future _showFinalConfirmationBottomSheetScreenTime(
      {required int afkCredits, required num screenTime}) async {
    return await bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: 'Confirmation',
      description:
          "Buy  $screenTime hours of screen time for $afkCredits AFK Credits?",
      confirmButtonTitle: 'Yes',
      cancelButtonTitle: 'No',
    );
  }

  bool hasEnoughBalance(double amount) {
    log.v(
        "Comparing balance of gift card: ${centsToAfkCredits(amount)} and available credits ${currentUserStats.afkCreditsBalance}");
    return centsToAfkCredits(amount) <= currentUserStats.afkCreditsBalance;
  }
}
