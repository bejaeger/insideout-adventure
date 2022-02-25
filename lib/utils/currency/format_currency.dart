import 'package:intl/intl.dart';

class FormatCurrency {
  formatToUsd({required double amount}) {
    final currency =
        NumberFormat.currency(locale: "en_US", symbol: 'usd ').format(amount);
    return currency;
  }
}
