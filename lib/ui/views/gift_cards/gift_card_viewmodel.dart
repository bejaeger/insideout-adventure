import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/helpers/money_transfer_status_model.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/money_transfer_dialog_status.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/money_transfer_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/services/giftcard/gift_card_services.dart';
import 'package:afkcredits/services/payments/payment_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked_services/stacked_services.dart';

class GiftCardViewModel extends BaseModel {
  final SnackbarService? _snackbarService = locator<SnackbarService>();

  final _giftCardServices = locator<GiftCardService>();
  final _dialogService = locator<DialogService>();
  final _paymentService = locator<PaymentService>();
  final BottomSheetService? _bottomSheetService = locator<BottomSheetService>();

  List<GiftCardCategory> getGiftCardCategories({required String categoryName}) {
    return _giftCardServices.getGiftCards(categoryName: categoryName);
  }

  Map<String, List<GiftCardCategory>> get getAllGiftCardCategories =>
      _giftCardServices.giftCardCategories;

  final log = getLogger('GiftCardViewModel');

  // Displays dialog with gift card info
  // If user selects 'purchase' a GiftCardPurchase object is created
  // and parsesd to the giftcardservice where the purchase is further processed
  Future displayGiftCardDialogAndProcessPurchase(
      GiftCardCategory giftCard) async {
    DialogResponse? dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.PurchaseGiftCards,
        data: giftCard,
        mainButtonTitle: 'Purchase',
        secondaryButtonTitle: 'Cancel');

    if (dialogResponse?.confirmed == true) {
      // Make quick check if available AFK Credits are enough
      if (!hasEnoughBalance(giftCard.amount)) {
        await _dialogService.showDialog(
            title: "You don't have enough AFK Credits",
            description: "Continue earning ;)");
        return;
      }

      // Ask for another final confirmation
      SheetResponse? finalConfirmation =
          await _showFinalConfirmationBottomSheet(
              afkCredits: centsToAfkCredits(giftCard.amount));

      if (finalConfirmation?.confirmed == false) {
        await _showAndAwaitSnackbar("You can come back any time :)");
        setBusy(false);
        return;
      } else if (finalConfirmation?.confirmed == true) {
        // -----------------------------------------------------
        // We create a completer and parse it to the pop-up window.
        // The pop-up window shows a progress indicator and
        // displays a success or error dialog when the completer is completed
        // in _processsPayment.
        var purchaseCompleter = Completer<TransferDialogStatus>();
        try {
          _processPayment(purchaseCompleter, giftCard);
        } catch (e) {
          log.wtf(
              "Something very mysterious went wrong when purchasing gift card, error thrown: $e");
          purchaseCompleter.complete(TransferDialogStatus.error);
        }
        dynamic dialogResult = await _showMoneyTransferDialog(
            moneyTransferCompleter: purchaseCompleter,
            type: TransferType.GiftCardPurchase);
      }
    }
  }

  Future _processPayment(Completer<TransferDialogStatus> purchaseCompleter,
      GiftCardCategory giftCard) async {
    // FOR now, implemented dummy payment processing here
    try {
      final giftCardPurchase =
          GiftCardPurchase(giftCardCategory: giftCard, uid: currentUser.uid);
      await _paymentService.purchaseGiftCard(
          giftCardPurchase: giftCardPurchase);
      log.i("GiftCard purchase: $giftCardPurchase");
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

  bool hasEnoughBalance(double amount) {
    log.v(
        "Comparing balance of gift card: ${centsToAfkCredits(amount)} and available credits ${currentUserStats.afkCreditsBalance}");
    return centsToAfkCredits(amount) <= currentUserStats.afkCreditsBalance;
  }

  Future loadGiftCards({required String name}) async {
    setBusy(true);
    log.i("Loading gift cards");
    await _giftCardServices.fetchGiftCards(categoryName: name);
    setBusy(false);
  }

  Future loadAllGiftCards() async {
    setBusy(true);
    log.i("Loading gift cards");
    await _giftCardServices.fetchAllGiftCards();
    setBusy(false);
  }

  // bottom sheets
  Future _showFinalConfirmationBottomSheet({required int afkCredits}) async {
    return await _bottomSheetService!.showBottomSheet(
      barrierDismissible: true,
      title: 'Confirmation',
      description:
          "Are you sure you would like buy this gift card for $afkCredits AFK Credits?",
      confirmButtonTitle: 'Yes',
      cancelButtonTitle: 'No',
    );
  }

  Future _showAndAwaitSnackbar(String message) async {
    _snackbarService!.showSnackbar(
        duration: Duration(seconds: 2), title: message, message: "");
    await Future.delayed(Duration(seconds: 2));
  }

  ///////////////////////////////////////
  /// Helper functions
  List<String> getUniqueCategoryNames() {
    List<String> categoryNames = [];

    getAllGiftCardCategories.forEach((key, value) {
      if (!categoryNames.contains(key)) {
        categoryNames.add(key);
      }
    });
    return categoryNames;
  }

  List<List<GiftCardCategory>> getListOfGiftCardsToDisplay() {
    List<List<GiftCardCategory>> returnList = [];
    getUniqueCategoryNames().forEach((categoryName) {
      if (!returnList.any((listOfGiftCards) => listOfGiftCards.any((giftCard) =>
          describeEnum(giftCard.categoryName).toString() == categoryName))) {
        returnList.add(getGiftCardCategories(categoryName: categoryName));
      }
    });
    return returnList;
  }
}
