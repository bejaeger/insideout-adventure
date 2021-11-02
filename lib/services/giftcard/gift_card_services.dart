import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category.dart';
import 'package:flutter/foundation.dart';

class GiftCardService {
  final _firestoreApi = locator<FirestoreApi>();
  final log = getLogger('GiftCardService');
  Map<String, List<GiftCardCategory>> giftCardCategories = {};

  List<GiftCardCategory> getGiftCards({required String categoryName}) {
    if (giftCardCategories.keys.contains(categoryName)) {
      return giftCardCategories[categoryName]!;
    } else {
      return [];
    }
  }

  Future fetchGiftCards({required String categoryName}) async {
    try {
      giftCardCategories[categoryName] = await _firestoreApi
          .getGiftCardsForCategory(categoryName: categoryName);
      log.i(
          "Found ${giftCardCategories[categoryName]!.length} gift cards of type $categoryName");
    } catch (e) {
      log.e("Failed fetching gift cards, error: $e");
      rethrow;
    }
  }

  Future fetchAllGiftCards() async {
    try {
      final allGiftCardCategories = await _firestoreApi.getAllGiftCards();
      // Need to do some gynmastics to convert the list of category names
      // to a easier to handle map
      final uniqueCategories = getUniqueCategoryNames(
          listOfGiftCardCategories: allGiftCardCategories);
      uniqueCategories.forEach((element) {
        giftCardCategories[element] = allGiftCardCategories
            .where((category) =>
                describeEnum(category.categoryName).toString() == element)
            .toList();
      });
      log.i(
          "Found ${giftCardCategories.length} gift card categories with names $uniqueCategories");
    } catch (e) {
      log.e("Failed fetching gift cards, error: $e");
      rethrow;
    }
  }

  ///////////////////////////////////////
  /// Helper functions
  List<String> getUniqueCategoryNames(
      {required List<GiftCardCategory> listOfGiftCardCategories}) {
    List<String> categoryNames = [];
    listOfGiftCardCategories.forEach((element) {
      final categoryName = describeEnum(element.categoryName).toString();
      if (!categoryNames.contains(categoryName)) {
        categoryNames.add(categoryName);
      }
    });
    return categoryNames;
  }
}
