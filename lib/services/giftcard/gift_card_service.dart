import 'dart:async';
import 'dart:convert';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_category/gift_card_category.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase_success_result/gift_card_purchase_success_result.dart';
import 'package:afkcredits/datamodels/giftcards/pre_purchased_gift_cards/pre_purchased_gift_card.dart';
import 'package:afkcredits/enums/purchased_gift_card_status.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class GiftCardService {
  final _firestoreApi = locator<FirestoreApi>();
  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();
  final log = getLogger('GiftCardService');
  Map<String, List<GiftCardCategory>> giftCardCategories = {};

  StreamSubscription? _purchasedGiftCardsStreamSubscription;
  List<GiftCardPurchase> purchasedGiftCards = [];
  List<GiftCardCategory>? _giftCartCategory;

  List<GiftCardCategory> getGiftCards({required String categoryName}) {
    if (giftCardCategories.keys.contains(categoryName)) {
      return giftCardCategories[categoryName]!;
    } else {
      return [];
    }
  }

/*   List<GiftCardCategory> getListGiftCards(
      {required GiftCardCategory giftCardCategory}) {
    if (giftCardCategory.categoryId.isNotEmpty) {
      giftCartCategory.add(giftCardCategory);

      return giftCartCategory;
    } else {
      return [];
    }
  } */

  List<GiftCardCategory>? get getListOfGiftCard => _giftCartCategory;

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

  Future<bool> addGiftCardCategory(
      {required GiftCardCategory giftCardCategory}) async {
    //TODO: Refactor this code .
    if (giftCardCategory.categoryId.isNotEmpty) {
      return await _firestoreApi.addGiftCardCategory(
          giftCardCategory: giftCardCategory);
    }
    return false;

    //update the newly created document reference with the Firestore Id.
    //This is to make suret that the document has the same id as the quest.
  }

  Future<bool> insertPrePurchasedGiftCardCategory(
      {required PrePurchasedGiftCard prePurchasedGiftCard}) async {
    //TODO: Refactor this code .
    if (prePurchasedGiftCard.categoryId.isNotEmpty) {
      return await _firestoreApi.insertPrePurchasedGiftCardCategory(
          prePurchasedGiftCard: prePurchasedGiftCard);
    }
    return false;

    //update the newly created document reference with the Firestore Id.
    //This is to make suret that the document has the same id as the quest.
  }

  void setListGiftCards({required List<GiftCardCategory> giftCardCategory}) {
    if (giftCardCategory.isNotEmpty) {
      _giftCartCategory = giftCardCategory;
    } else {
      print('WTF Empty List');
    }
  }

  List<QuerySnapshot> get giftCardQuerySnapShot =>
      _firestoreApi.getListQuerySnapShot();

  Future fetchAllGiftCards() async {
    try {
      final allGiftCardCategories = await _firestoreApi.getAllGiftCards();
      setListGiftCards(giftCardCategory: allGiftCardCategories);
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
        log.v("Listened to ${purchasedGiftCards.length} gift cards");
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
    log.i("Switching status of gift card to $newStatus");
    GiftCardPurchase newGiftCardPurchase = purchasedGiftCards
        .where((element) => element.transferId == giftCardPurchase.transferId)
        .first
        .copyWith(status: newStatus);
    _firestoreApi.updateGiftCardPurchase(
        giftCardPurchase: newGiftCardPurchase, uid: uid);
  }

  ///////////////////////////////////////////////
  /// Call Cloud Function
  Future purchaseGiftCard({required GiftCardPurchase giftCardPurchase}) async {
    try {
      log.i("Calling restful server function bookkeepGiftCardPurchase");

      Uri url = Uri.https(
          _flavorConfigProvider.authority,
          p.join(_flavorConfigProvider.uripathprepend,
              "transfers-api/bookkeepgiftcardpurchase"));
      http.Response? response = await http.post(url,
          body: json.encode(giftCardPurchase.toJson()),
          headers: {"Accept": "application/json"});
      log.i("posted http request");
      dynamic result = json.decode(response.body);
      log.i("decoded json response");

      if (result["error"] == null) {
        log.i(
            "Added the following gift card purchase document to ${result["data"]["transferId"]}: ${giftCardPurchase.toJson()}");
        return GiftCardPurchaseSuccessResult.fromJson(result["data"]);
      } else {
        log.e(
            "Error when creating money transfer: ${result["error"]["message"]}");
        throw FirestoreApiException(
            message:
                "An error occured in the cloud function 'bookkeepGiftCardPurchase'",
            devDetails:
                "Error message from cloud function: ${result["error"]["message"]}",
            prettyDetails:
                "An internal error occured on our side, please apologize and try again later.");
      }
    } catch (e) {
      log.e("Couldn't process transfer: ${e.toString()}");
      throw FirestoreApiException(
          message:
              "Something failed when calling the https function bookkeepGiftCardPurchase",
          devDetails:
              "This should not happen and is due to an error on the Firestore side or the datamodels that were being pushed!",
          prettyDetails:
              "An internal error occured on our side, please apologize and try again later.");
    }
  }

  ////////////////////////////////////////////////////////////
  // Clean-up

  void clearData() {
    log.i("Clear purchased gift cards");
    purchasedGiftCards = [];
    _purchasedGiftCardsStreamSubscription?.cancel();
    _purchasedGiftCardsStreamSubscription = null;
  }

  void cancelPurchasedGiftCardSubscription() {
    _purchasedGiftCardsStreamSubscription?.cancel();
    _purchasedGiftCardsStreamSubscription = null;
  }
}
