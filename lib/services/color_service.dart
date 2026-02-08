import 'package:flutter/material.dart';

class ColorService {
  static final List<Color> favoriteColors = [];
  static bool toggleFavorite(Color color) {
    if (favoriteColors.contains(color)) {
      favoriteColors.remove(color);
      return false;
    } else {
      favoriteColors.add(color);
      return true;
    }
  }

  static bool isFavorite(Color color) {
    return favoriteColors.contains(color);
  }
}