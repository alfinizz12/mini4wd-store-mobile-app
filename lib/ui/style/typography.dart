import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Display / App Title
  static TextStyle display = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
  );

  // Headings
  static TextStyle h1 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
  );

  static TextStyle h2 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.3,
    ),
  );

  static TextStyle h3 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
  );

  // Subtitle
  static TextStyle subtitle1 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.3,
    ),
  );

  static TextStyle subtitle2 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.3,
    ),
  );

  // Body Text
  static TextStyle body1 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
  );

  static TextStyle body2 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
  );

  // Caption / Note
  static TextStyle caption = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.3,
      color: Colors.grey,
    ),
  );

  // Label / Small Text
  static TextStyle label = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.3,
    ),
  );

  // Button Text
  static TextStyle button = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0.3,
    ),
  );
}
