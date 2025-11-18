// lib/src/format_utils.dart
import 'dart:math';
import 'package:intl/intl.dart';

class FormatUtils {
  FormatUtils._();

  static String formatCurrency(num value, {String? locale, String? symbol}) {
    try {
      final fmt = NumberFormat.simpleCurrency(locale: locale, name: symbol);
      return fmt.format(value);
    } catch (_) {
      return '${symbol ?? '₹'}${value.toStringAsFixed(2)}';
    }
  }

  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytes) / log(1024)).floor();
    final val = bytes / pow(1024, i);
    return '${val.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static String formatNumber(int value) {
    if (value < 1000) return '$value';
    if (value < 1000000) return '${(value / 1000).toStringAsFixed(1)}K';
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }

  static String formatDuration(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d ${d.inHours % 24}h';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds % 60}s';
    return '${d.inSeconds}s';
  }
}
