import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app_config_provider.dart';

class EmailService {
  final log = getLogger("EmailService");
  final CloudFunctionsApi _cloudFunctionsApi = locator<CloudFunctionsApi>();
  final AppConfigProvider _appConfigProvider = locator<AppConfigProvider>();

  Future sendFeedbackEmail(
      {required String message, String? uid, String? email}) async {
    // poor-man composing of email
    message = "FEEDBACK FROM USER:\n==>> \n" + message;
    message = message + "\n<<==";
    message = message + "\n\n ------------------\n";
    message = message + "Sender information:\n";
    message = message + "UID: ${uid ?? "N/A"} \n";
    message = message + "Email: ${email ?? "N/A"}\n";
    message = message + "App information:\n";
    message = message + "Version: ${_appConfigProvider.versionName}\n";
    message = message + "------------------";

    await _cloudFunctionsApi.sendEmail(message: message);
  }

  Future sendConsentEmail(
      {required String code,
      required String userName,
      required String email}) async {
    // poor-man composing of email
    String message = """
      Hi $userName!\n
      Thank you for your interest in our app. We are happy to have you on board!
      This is your code to verify you as a parent:

      $code

      Thank you!
      The InsideOut Adventure Team
    """;
    await _cloudFunctionsApi.sendEmail(message: message, receiverEmail: email);
  }
}
