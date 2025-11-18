// lib/src/string_utils.dart
import 'dart:core';

class StringUtils {
  StringUtils._();

  static String capitalize(String s) {
    if (s.trim().isEmpty) return s;
    final trimmed = s.trim();
    return trimmed[0].toUpperCase() + trimmed.substring(1);
  }

  static String capitalizeEachWord(String s) {
    if (s.trim().isEmpty) return s;
    return s
        .trim()
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? w : (w[0].toUpperCase() + w.substring(1)))
        .join(' ');
  }

  static String toCamelCase(String s) {
    final parts =
        s.trim().split(RegExp(r'[_\-\s]+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    final first = parts.first.toLowerCase();
    final rest = parts.skip(1).map((p) => capitalize(p.toLowerCase())).join();
    return '$first$rest';
  }

  static String toSnakeCase(String s) {
    final words = s.trim().split(RegExp(r'[\s\-]+'));
    return words.map((w) => w.toLowerCase()).join('_');
  }

  static String truncate(String s, int length, {String suffix = '...'}) {
    if (s.length <= length) return s;
    if (length <= 0) return '';
    return s.substring(0, length) + suffix;
  }

  static String removeExtraSpaces(String s) {
    return s.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static bool isNullOrEmpty(String? s) {
    return s == null || s.trim().isEmpty;
  }

  static String maskEmail(String email, {int visibleBefore = 2, int visibleAfter = 2}) {
    if (email.isEmpty) return email;
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final user = parts[0];
    final domain = parts[1];
    final start = user.substring(0, visibleBefore.clamp(0, user.length));
    final end = user.length > visibleAfter
        ? user.substring(user.length - visibleAfter)
        : '';
    final middleLength = (user.length - start.length - end.length).clamp(0, user.length);
    final masked = start + ('*' * middleLength) + end;
    return '$masked@$domain';
  }

  static String maskPhone(String phone, {int visibleStart = 0, int visibleEnd = 2}) {
    final digits = onlyDigits(phone);
    if (digits.length <= visibleStart + visibleEnd) return '*' * digits.length;
    final start = digits.substring(0, visibleStart);
    final end = digits.substring(digits.length - visibleEnd);
    return start + ('*' * (digits.length - visibleStart - visibleEnd)) + end;
  }

  static String onlyDigits(String s) {
    return s.replaceAll(RegExp(r'\D'), '');
  }
}
