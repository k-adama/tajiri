import 'package:intl/intl.dart';

extension FormatAmountExtension on String {
  String currencyShort() {
    return "${NumberFormat("#,##0", "fr_FR").format(double.tryParse(this))} F";
  }

  String currencyLong() {
    try {
      return "${NumberFormat("#,##0", "fr_FR").format(double.tryParse(this))} FCFA";
    } catch (e) {
      print("Error $e , StackTrace ${StackTrace.current}");
      return "";
    }
  }

  String notCurrency() {
    return NumberFormat("#,##0", "fr_FR").format(double.tryParse(this));
  }

  String splashCurrency() {
    return "${NumberFormat("#,##0", "fr_FR").format(double.tryParse(this))} / FCFA";
  }
  // ···
}
