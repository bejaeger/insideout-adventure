import 'dart:convert';
import 'dart:io';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class CloudFunctionsApi {
  final log = getLogger("CloudFunctionApi");

  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();
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
      http.Response? response = await http.post(url,
          body: json.encode(quest.toJson()),
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
}
