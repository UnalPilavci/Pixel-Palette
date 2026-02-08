import 'dart:math';
import 'package:flutter/material.dart';

class ColorUtils {
  static String toRGB(Color color) {
    return "${(color.r * 255).round()}, ${(color.g * 255).round()}, ${(color.b * 255).round()}";
  }
  static String toHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }
  static String toCMYK(Color color) {
    double r = color.r;
    double g = color.g;
    double b = color.b;

    double k = 1.0 - [r, g, b].reduce(max);
    double c = (1.0 - r - k) / (1.0 - k);
    double m = (1.0 - g - k) / (1.0 - k);
    double y = (1.0 - b - k) / (1.0 - k);
    if (k == 1.0) {
      c = 0;
      m = 0;
      y = 0;
    }
    return "${(c * 100).round()}, ${(m * 100).round()}, ${(y * 100).round()}, ${(k * 100).round()}";
  }
  static String toHSL(Color color) {
    final hsl = HSLColor.fromColor(color);
    return "${hsl.hue.round()}°, ${(hsl.saturation * 100).round()}%, ${(hsl.lightness * 100).round()}%";
  }
}