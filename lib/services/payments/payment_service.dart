// PMs job
import 'dart:convert';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/giftcards/gift_card_purchase/gift_card_purchase.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

// This is a class used during development

// For now this is just an intermediary!
// Eventually we want to setup a StripePaymentService
// Or GPay or Apple Pay for the transactions into the system

class PaymentService {
  final log = getLogger("PaymentService");
  final FlavorConfigProvider _flavorConfigProvider =
      locator<FlavorConfigProvider>();

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
        throw FirestoreApiException(
            message:
                "An error occured in the cloud function 'bookkeepMoneyTransfer'",
            devDetails:
                "Error message from cloud function: ${result["error"]["message"]}",
            prettyDetails:
                "An internal error occured on our side, please apologize and try again later.");
      }
    } catch (e) {
      log.e("Couldn't process transfer: ${e.toString()}");
      throw FirestoreApiException(
          message:
              "Something failed when calling the https function bookkeepMoneyTransfer",
          devDetails:
              "This should not happen and is due to an error on the Firestore side or the datamodels that were being pushed!",
          prettyDetails:
              "An internal error occured on our side, please apologize and try again later.");
    }
  }
}
