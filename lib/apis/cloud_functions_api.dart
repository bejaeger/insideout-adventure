import 'dart:convert';
import 'dart:io';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase_success_result/gift_card_purchase_success_result.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

// ! DEPRECATED
// ! THIS ENTIRE FILE IS DEPRECATED

class CloudFunctionsApi {
  final log = getLogger("CloudFunctionApi");
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  ///////////////////////////////////////////
  /// Calling backend function to bookkeep credits
  Future bookkeepFinishedQuest({required ActivatedQuest quest}) async {
    try {
      // TODO
      // Add check for network connection.
      // And return proper error message if no data connection available
      // And also keep quest status!

      log.i("Calling restful server function bookkeepFinishedQuest");
      Uri url = Uri.https(
          _flavorConfigProvider.authority,
          p.join(_flavorConfigProvider.uripathprepend,
              "transfers-api/bookkeepfinishedquest"));
      var modQuestJson = quest.toJson();
      // ! WORKAROUND
      // ! necessary otherwise json.encode will fail!
      // ! This means we cannot use geoflutterfire for past quests!
      // ! This should be okay for now
      modQuestJson['quest']['location'] = null;
      http.Response? response = await http.post(url,
          body: json.encode(modQuestJson),
          headers: {"Accept": "application/json"});
      log.i("posted http request");
      dynamic result = json.decode(response.body);
      log.i("decoded json response");
      // return result;
      if (result["error"] == null) {
        log.i("Quest successfully bookkept!");
      } else {
        log.e(
            "Error when trying to bookeep finished quest: ${result['error']['message']}");
        throw QuestServiceException(
            message:
                "An error occured in the cloud function 'bookkeepFinishedQuest'",
            devDetails:
                "Error message from cloud function: ${result["error"]["message"]}",
            prettyDetails: "${result["error"]["message"]}");
      }
    } catch (e) {
      log.e("Couldn't process finishedquest: ${e.toString()}");
      if (e is QuestServiceException) rethrow;
      if (e is SocketException) {
        throw CloudFunctionsApiException(
            message: "No network available",
            devDetails:
                "It seems like the call to the cloud function was not possible due to connection issues. Prompt a message to the user so that he tries again later.",
            prettyDetails: "No network connection, please try again later.");
      } else {
        throw QuestServiceException(
            message:
                "Something failed when calling the https function bookkeepFinishedQuest",
            devDetails:
                "This should not happen and is due to an error on the Firestore side or the datamodels that were being pushed! Error message: $e",
            prettyDetails:
                "An internal error occured on our side, sorry! Please try again later.");
      }
    }
  }

  Future processTransfer({required MoneyTransfer moneyTransfer}) async {
    try {
      log.i("Calling restful server function bookkeepMoneyTransfer");

      Uri url = Uri.https(
          _flavorConfigProvider.authority,
          p.join(_flavorConfigProvider.uripathprepend,
              "transfers-api/bookkeepmoneytransfer"));
      http.Response? response = await http.post(url,
          body: json.encode(moneyTransfer.toJson()),
          headers: {"Accept": "application/json"});
      log.i("posted http request");
      dynamic result = json.decode(response.body);
      log.i("decoded json response");

      if (result["error"] == null) {
        log.i(
            "Added the following transfer document to ${result["data"]["transferId"]}: ${moneyTransfer.toJson()}");
      } else {
        log.e(
            "Error when creating money transfer: ${result["error"]["message"]}");
        throw CloudFunctionsApiException(
            message:
                "An error occured in the cloud function 'bookkeepMoneyTransfer'",
            devDetails:
                "Error message from cloud function: ${result["error"]["message"]}",
            prettyDetails:
                "An internal error occured on our side, please apologize and try again later.");
      }
    } catch (e) {
      log.e("Couldn't process transfer: ${e.toString()}");
      if (e is CloudFunctionsApiException) rethrow;
      if (e is SocketException) {
        throw CloudFunctionsApiException(
            message: "No network available",
            devDetails:
                "It seems like the call to the cloud function was not possible due to connection issues. Prompt a message to the user so that he tries again later.",
            prettyDetails: "No network connection, please try again later.");
      } else {
        throw CloudFunctionsApiException(
            message:
                "Something failed when calling the https function bookkeepMoneyTransfer",
            devDetails:
                "This should not happen and is due to an error on the Firestore side or the datamodels that were being pushed! Error thrown: $e",
            prettyDetails:
                "An internal error occured on our side, please apologize and try again later.");
      }
    }
  }

  ///////////////////////////////////////////////
  /// Call Cloud Function
  Future purchaseScreenTime(
      {required ScreenTimeSession screenTimePurchase}) async {
    try {
      log.i("Calling restful server function bookkeepScreenTimePurchase");
      Uri url = Uri.https(
          _flavorConfigProvider.authority,
          p.join(_flavorConfigProvider.uripathprepend,
              "transfers-api/bookkeepscreentimepurchase"));
      http.Response? response = await http.post(url,
          body: json.encode(screenTimePurchase.toJson()),
          headers: {"Accept": "application/json"});
      dynamic result = json.decode(response.body);
      if (result["error"] == null) {
        return true;
      } else {
        log.e("Error when buying screen time: ${result["error"]["message"]}");
        throw CloudFunctionsApiException(
            message:
                "An error occured in the cloud function 'bookkeepScreenTimePurchase'",
            devDetails:
                "Error message from cloud function: ${result["error"]["message"]}",
            prettyDetails:
                "Sorry, something went wrong, please try again later.");
      }
    } catch (e) {
      log.e("Couldn't process screen time purchase: ${e.toString()}");
      throw CloudFunctionsApiException(
          message:
              "Something failed when calling the https function bookkeepScreenTimePurchase",
          devDetails:
              "This should not happen and is due to an error on the Firestore side or the datamodels that were being pushed!",
          prettyDetails:
              "An internal error occured on our side, please apologize and try again later.");
    }
  }

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
        throw CloudFunctionsApiException(
            message:
                "An error occured in the cloud function 'bookkeepGiftCardPurchase'",
            devDetails:
                "Error message from cloud function: ${result["error"]["message"]}",
            prettyDetails:
                "An internal error occured on our side, please apologize and try again later.");
      }
    } catch (e) {
      log.e("Couldn't process transfer: ${e.toString()}");
      throw CloudFunctionsApiException(
          message:
              "Something failed when calling the https function bookkeepGiftCardPurchase",
          devDetails:
              "This should not happen and is due to an error on the Firestore side or the datamodels that were being pushed!",
          prettyDetails:
              "An internal error occured on our side, please apologize and try again later.");
    }
  }
}
