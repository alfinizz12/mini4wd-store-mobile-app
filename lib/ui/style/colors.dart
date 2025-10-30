import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Tamiya Inspired)
  static const Color primaryBlue = Color(0xFF0057FF); // Biru Tamiya lebih modern
  static const Color primaryRed = Color(0xFFE50015);  // Red Tamiya refined (tidak terlalu flat)
  static const Color primaryWhite = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color accentYellow = Color(0xFFFFC400); // Racing yellow
  static const Color accentSilver = Color(0xFFC7CCD6); // Kesan bahan metal Mini4WD
  static const Color accentBlack = Color(0xFF000000);

  // Support Colors
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFFFB200);
  static const Color danger = Color(0xFFEB3B5A);
  static const Color info = Color(0xFF3DB2FF);

  // Neutral Colors (Light + Dark System)
  static const Color backgroundLight = Color(0xFFF7F8FA);
  static const Color backgroundDark = Color(0xFF0F1115);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1C20);

  static const Color textLight = Color(0xFF111111);
  static const Color textDark = Color(0xFFF5F5F5);

  // Components
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);

  // Chip / Filter colors
  static const Color chipSelected = primaryBlue;
  static const Color chipUnselected = Color(0xFFE4E6EB);

  // Borders / Divider
  static const Color dividerLight = Color(0xFFD8DCE3);
  static const Color dividerDark = Color(0xFF303236);
}
