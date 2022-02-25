// ignore_for_file: non_constant_identifier_names

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/datamodels/giftcards/pre_purchased_gift_cards/pre_purchased_gift_card.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';

class ManageGiftCardViewModel extends BaseViewModel with NavigationMixin {
  final log = getLogger('ManageGiftCardViewModel');

  final _giftCardService = locator<GiftCardService>();

  List<PrePurchasedGiftCard?>? _prePurhcasedGiftCards = [];

  //final _dialogService = locator<DialogService>();
  //final BottomSheetService? _bottomSheetService = locator<BottomSheetService>();

  List<GiftCardCategory> getGiftCardCategories({required String categoryName}) {
    return _giftCardService.getGiftCards(categoryName: categoryName);
  }

  Map<String, List<GiftCardCategory>> get getAllGiftCardCategories =>
      _giftCardService.giftCardCategories;
  //TODO: Started Here: I see These methods going into  an Abstract Class.
  Future loadGiftCards({required String name}) async {
    setBusy(true);
    log.i("Loading gift cards");
    await _giftCardService.fetchGiftCards(categoryName: name);
    setBusy(false);
  }

/*
  Future loadAllGiftCards() async {
    setBusy(true);
    log.i("Loading gift cards");
    await _giftCardService.fetchAllGiftCards();
    setBusy(false);
  }
*/
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

  List<PrePurchasedGiftCard?>? get getPrePurchasedGiftCard =>
      _prePurhcasedGiftCards;

  Future<void> prePurchasedGiftCard() async {
    setBusy(true);
    _prePurhcasedGiftCards =
        await _giftCardService.getPreGiftCardsForCategory();
    setBusy(false);
    notifyListeners();
  }
  //TODO: Ended Here: I see These methods going into  an Abstract Class.

  void navToSpecificGiftCardsView({required int index}) {
    switch (index) {
      case 0:
        // DisplayLogs(display: navToAddGiftCard);
        navToAddGiftCard();
        break;
      case 1:
        // DisplayLogs(display: navToInsertGiftCard);
        navToInsertGiftCard();
        break;
      case 2:
        //log.i('User is Navigating to $navToQuestOverView');
        // navToQuestOverView();
        break;
      default:
      //log.i('User is Navigating to $navToCreateQuest');

      //navToCreateQuest();

    }
  }

  void DisplayLogs({required var display}) {
    log.i('User is Navigating to $display');
  }
}
