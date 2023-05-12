import 'dart:convert';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

import '../exceptions/cloud_functions_exception.dart';

class CloudFunctionsApi {
  final log = getLogger("CloudFunctionApi");
  final AppConfigProvider _appConfigProvider = locator<AppConfigProvider>();

  Future sendEmail({required String message, String? receiverEmail}) async {
    try {
      log.i("Calling restful server function sendemail");
      Uri url = Uri.https(_appConfigProvider.authority,
          p.join(_appConfigProvider.uripathprepend, "customers-api/sendemail"));

      dynamic body;
      if (receiverEmail == null) {
        body = json.encode({
          "message": message,
        });
      } else {
        body = json.encode({
          "message": message,
          "receiverEmail": receiverEmail,
        });
      }

      http.Response? response = await http
          .post(url, body: body, headers: {"Accept": "application/json"});
      log.i("posted http request");
      dynamic result = json.decode(response.body);
      log.i("decoded json response");

      if (result["error"] == null) {
        log.i("Successfully sent email");
        return true;
      } else {
        log.e("Error when sending email: ${result["error"]["message"]}");
        throw CloudFunctionsApiException(
            message: "An error occured in the cloud function 'sendemail'",
            devDetails:
                "Error message from cloud function: ${result["error"]["message"]}",
            prettyDetails:
                "An internal error occured on our side, please apologize and try again later.");
      }
    } catch (e) {
      log.e("Couldn't process transfer: ${e.toString()}");
      throw CloudFunctionsApiException(
          message: "Something failed when calling the https function sendemail",
          devDetails:
              "This should not happen and is due to an error on the Firestore side or the datamodels that were being pushed!",
          prettyDetails:
              "An internal error occured on our side, please try again later.");
    }
  }
}
