import 'package:currency_formatter/currency_formatter.dart';

extension MyCustomCurrencyFormatters on num {
  String toUSD() {
    return CurrencyFormatter.format(this, CurrencyFormat.usd);
  }
}
