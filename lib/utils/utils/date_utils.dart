// lib/src/date_utils.dart
import 'package:intl/intl.dart';

class DateUtilsX {
  DateUtilsX._();

  static String formatDate(DateTime dt, String pattern) =>
      DateFormat(pattern).format(dt.toLocal());

  static String formatTime(DateTime dt, {String pattern = 'h:mm a'}) =>
      DateFormat(pattern).format(dt.toLocal());

  static String timeAgo(DateTime dt, {DateTime? clock}) {
    final now = (clock ?? DateTime.now()).toUtc();
    final date = dt.toUtc();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  static bool isToday(DateTime dt, {DateTime? clock}) {
    final now = (clock ?? DateTime.now()).toLocal();
    final d = dt.toLocal();
    return now.year == d.year && now.month == d.month && now.day == d.day;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    final da = a.toLocal();
    final db = b.toLocal();
    return da.year == db.year && da.month == db.month && da.day == db.day;
  }

  static DateTime? parseDate(String s, String pattern) {
    try {
      return DateFormat(pattern).parseStrict(s);
    } catch (_) {
      return null;
    }
  }

  static DateTime toUTC(DateTime dt) => dt.toUtc();
  static DateTime toLocal(DateTime dt) => dt.toLocal();
}
