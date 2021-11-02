import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/services/giftcard/gift_card_services.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked_services/stacked_services.dart';

class GiftCardViewModel extends BaseModel {
  final _giftCardServices = locator<GiftCardService>();
  final _dialogService = locator<DialogService>();

  List<GiftCardCategory> getGiftCardCategories({required String categoryName}) {
    return _giftCardServices.getGiftCards(categoryName: categoryName);
  }

  Map<String, List<GiftCardCategory>> get getAllGiftCardCategories =>
      _giftCardServices.giftCardCategories;

  final log = getLogger('GiftCardViewModel');

  // Displays dialog with gift card info
  // If user selects 'purchase' a GiftCardPurchase object is created
  // and parsesd to the giftcardservice where the purchase is further processed
  Future displayGiftCardDialog(GiftCardCategory giftCard) async {
    DialogResponse? dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.PurchaseGiftCards,
        data: giftCard,
        mainButtonTitle: 'Purchase',
        secondaryButtonTitle: 'Cancel');

    if (dialogResponse?.confirmed == true) {
      // TODO: call gift card service function that calls CF to process gift card purchase
      showNotImplementedSnackbar();
      //Validate If the User Has enough Credit to Purchase Gift Cards.

    }
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
