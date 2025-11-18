// lib/src/math_utils.dart
import 'dart:math';

class MathUtils {
  MathUtils._();

  static double percentage(num part, num total) =>
      total == 0 ? 0 : (part / total) * 100;

  static num clamp(num value, num min, num max) =>
      value < min ? min : (value > max ? max : value);

  static double roundToDecimals(double value, int decimals) {
    final p = pow(10, decimals);
    return (value * p).round() / p;
  }

  static num lerp(num a, num b, double t) => a + (b - a) * t;
}
