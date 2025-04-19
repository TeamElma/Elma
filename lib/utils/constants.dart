// lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppColors {
  /// A fresh Elma green
  static const Color primary    = Color(0xFF53CF01);
  static const Color accent     = Colors.black;
  static const Color background = Colors.white;
}

class AppTextStyle {
  static const TextStyle bodyLarge  = TextStyle(fontSize: 16.0);
  static const TextStyle titleLarge = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);
  static const TextStyle labelLarge = TextStyle(fontSize: 21.0, color: Colors.white);
}

class AppPaddings {
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
}
