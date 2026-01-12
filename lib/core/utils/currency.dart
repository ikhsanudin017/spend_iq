import 'package:intl/intl.dart';

class CurrencyUtils {
  CurrencyUtils._();

  static String format(
    num value, {
    String locale = 'id_ID',
    String symbol = 'Rp',
    int decimalDigits = 0,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol.isEmpty ? 'Rp' : symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(value);
  }

  static String compact(num value, {String locale = 'id_ID'}) {
    final formatter = NumberFormat.compactCurrency(
      locale: locale,
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
}
