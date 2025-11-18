// lib/src/response_utils.dart
import 'dart:convert';

class ResponseUtils {
  ResponseUtils._();

  static String getErrorMessage(dynamic error) {
    try {
      if (error == null) return 'Unknown error';
      if (error is String) return error;
      if (error is Exception) return error.toString();
      return jsonEncode(error);
    } catch (_) {
      return 'Unknown error';
    }
  }

  static bool isTimeoutError(dynamic error) {
    final m = error?.toString().toLowerCase() ?? '';
    return m.contains('timeout');
  }

  static bool isNetworkError(dynamic error) {
    final m = error?.toString().toLowerCase() ?? '';
    return m.contains('socket') || m.contains('network') || m.contains('connection');
  }

  static dynamic safeParseJSON(String s) {
    try {
      return jsonDecode(s);
    } catch (_) {
      return null;
    }
  }
}
