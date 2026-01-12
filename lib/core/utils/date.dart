import 'package:intl/intl.dart';

class DateUtilsX {
  DateUtilsX._();

  static String formatShort(DateTime date, {String locale = 'id_ID'}) => DateFormat('d MMM', locale).format(date);

  static String formatFull(DateTime date, {String locale = 'id_ID'}) => DateFormat('EEEE, d MMMM y', locale).format(date);

  static bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) => DateTime(date.year, date.month, date.day, 23, 59, 59);

  static DateTime addBusinessDays(DateTime date, int days) {
    var result = date;
    var added = 0;
    while (added < days) {
      result = result.add(const Duration(days: 1));
      if (_isBusinessDay(result)) {
        added++;
      }
    }
    return result;
  }

  static bool _isBusinessDay(DateTime date) => date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
}
