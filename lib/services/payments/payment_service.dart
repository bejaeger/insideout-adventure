import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/app_config_provider.dart';

// This is a class used during development

// For now this is just an intermediary!
// Eventually we want to setup a StripePaymentService
// Or GPay or Apple Pay for the transactions into the system

class PaymentService {
  final log = getLogger("PaymentService");
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  final CloudFunctionsApi _cloudFunctionsApi = locator<CloudFunctionsApi>();

  Future processTransfer({required MoneyTransfer moneyTransfer}) async {
    await _cloudFunctionsApi.processTransfer(moneyTransfer: moneyTransfer);
  }
}
