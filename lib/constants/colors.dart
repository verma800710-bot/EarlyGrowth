import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const profileBg = Color(0xFFF4E8FF); // light lavender
  static const cardBg = Colors.white;

  // Primary brand color
  static const primaryPink = Color(0xFFE78AF4);

  // Gradients
  static const buttonGradient = LinearGradient(
    colors: [
      Color(0xFFFF5DA2),
      Color(0xFF6A7CFF),
    ],
  );

  static const welcomeBgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF1A8),
      Color(0xFFFFD6E7),
    ],
  );

  static const startButtonGradient = LinearGradient(
    colors: [
      Color(0xFF00E676),
      Color(0xFF00B0FF),
    ],
  );
  static const bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEAF2FF),
      Color(0xFFFDE7F3),
    ],
  );

  static const cardShadow = BoxShadow(
    color: Colors.black12,
    blurRadius: 14,
    offset: Offset(0, 6),
  );

  // Text
  static const titleDark = Color(0xFF1F2937);
  static const subtitleDark = Color(0xFF4B5563);
}
