// lib/src/color_utils.dart
import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();

  static Color hexToColor(String hex) {
    var c = hex.replaceAll('#', '');
    if (c.length == 3) c = c.split('').map((x) => '$x$x').join();
    if (c.length == 6) c = 'FF$c';
    return Color(int.parse(c, radix: 16));
  }

  static String colorToHex(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  static Color darken(Color c, [double amt = .1]) =>
      HSLColor.fromColor(c).withLightness(
          (HSLColor.fromColor(c).lightness - amt).clamp(0.0, 1.0)).toColor();

  static Color lighten(Color c, [double amt = .1]) =>
      HSLColor.fromColor(c).withLightness(
          (HSLColor.fromColor(c).lightness + amt).clamp(0.0, 1.0)).toColor();
}
