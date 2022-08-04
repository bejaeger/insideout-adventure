import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/afk_credit_and_currency_system.dart';
import 'package:afkcredits/utils/other_helpers.dart';
import 'package:intl/intl.dart';

final log = getLogger("Currency Formatting Helper Functions");

// deal with locale at some other point
final String defaultLocale = "en-US";

// Use this to display amount in UI
//
// In firestore we store currencies multiplied by 100
// so we need to divide them by 100 again
// (if they are non-zero-decimal currencies)
String formatAmount(amount,
    {bool userInput = false,
    bool showDollarSign = true,
    bool showDecimals = true}) {
  num returnAmount = (isNonZeroDecimalCurrency() && userInput == false)
      ? (amount / 100)
      : amount;
  var returnValue =
      NumberFormat.simpleCurrency(locale: defaultLocale).format(returnAmount);
  if (!showDollarSign) returnValue = returnValue.replaceAll("\$", "");
  if (!showDecimals && isNonZeroDecimalCurrency())
    returnValue = removeLastCharacters(returnValue, removeNumber: 3);
  return returnValue;
}

// Format amount for stripe that takes it in cents
num scaleAmountForStripe(num amount) {
  num returnAmount =
      isNonZeroDecimalCurrency() ? (amount * 100).round() : amount.round();
  return returnAmount;
}

// There are currencies without decimals, check for this
bool isNonZeroDecimalCurrency() {
  try {
    var numberFormat = NumberFormat.simpleCurrency(locale: defaultLocale);
    return numberFormat.decimalDigits != 0;
  } catch (e) {
    log.e("Potentially an invalid locale was parsed to isNonDecimalCurrency()");
    rethrow;
  }
}

////////////////////////////////////
// credit and currency conversion (maybe put this in a sevice?)
int centsToAfkCredits(num cents) {
  return (cents * kCentsToAfkCreditsConversionFactor).round();
}

// credit and currency conversion (maybe put this in a sevice?)
int creditsToScreenTime(num credits) {
  return (credits * kCreditsToScreenTimeConversionFactor).round();
}

// credit and currency conversion (maybe put this in a sevice?)
int screenTimeToCredits(int minutes) {
  return (minutes / kCreditsToScreenTimeConversionFactor).round();
}

String formatAfkCreditsFromCents(num cents) {
  return ((cents * kCentsToAfkCreditsConversionFactor).round()).toString();
}

String formatDollarFromCents(num cents) {
  return ((cents * 0.01).round()).toString();
}

String formatAFKCreditsToActivityHours(num credits) {
  // assume 100 credits are worth 1 hour activities
  return ((credits * 0.01).round()).toString();
}
