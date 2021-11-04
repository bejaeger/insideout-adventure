import 'dart:async';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/enums/purchased_gift_card_status.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/purchased_gift_cards_view.dart';
import 'package:flutter/foundation.dart';

class GiftCardService {
  final _firestoreApi = locator<FirestoreApi>();
  final log = getLogger('GiftCardService');
  Map<String, List<GiftCardCategory>> giftCardCategories = {};

  StreamSubscription? _purchasedGiftCardsStreamSubscription;
  List<GiftCardPurchase> purchasedGiftCards = [];

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

  ////////////////////////////////////////////
  /// History of quests

  // adds listener to money pools the user is contributing to
  // allows to wait for the first emission of the stream via the completer
  Future<void>? setupPurchasedGiftCardsListener(
      {required Completer<void> completer,
      required String uid,
      void Function()? callback}) async {
    if (_purchasedGiftCardsStreamSubscription == null) {
      bool listenedOnce = false;
      _purchasedGiftCardsStreamSubscription = _firestoreApi
          .getPurchasedGiftCardsStream(uid: uid)
          .listen((snapshot) {
        listenedOnce = true;
        purchasedGiftCards = snapshot;
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (callback != null) {
          callback();
        }
        log.v("Listened to ${purchasedGiftCards.length} quests");
      });
      if (!listenedOnce) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      return completer.future;
    } else {
      log.w(
          "Already listening to list of purchased gift cards, not adding another listener");
      completer.complete();
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

  Future switchRedeemStatus(
      {required GiftCardPurchase giftCardPurchase, required String uid}) async {
    PurchasedGiftCardStatus newStatus =
        giftCardPurchase.status == PurchasedGiftCardStatus.redeemed
            ? PurchasedGiftCardStatus.available
            : PurchasedGiftCardStatus.redeemed;
    GiftCardPurchase newGiftCardPurchase = purchasedGiftCards
        .where((element) => element.transferId == giftCardPurchase.transferId)
        .first
        .copyWith(status: newStatus);
    _firestoreApi.updateGiftCardPurchase(
        giftCardPurchase: newGiftCardPurchase, uid: uid);
  }
}
