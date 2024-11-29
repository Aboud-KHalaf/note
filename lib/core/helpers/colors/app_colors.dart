import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color darkCardColor = Color(0xff272636);
  static const Color darkBottomSheet = Color(0xff1f1d2b);
  static const Color darkPrimary = Color(0xffffd740);
  static const Color darkBackground = Color(0xff1f1d2b);
  static const Color darkSecondary = Color(0xff29b6f6);

  // Light Mode Colors
  static const Color lightCardColor = Color(0xfff5f5f5); // Light gray for cards
  static const Color lightBottomSheet =
      Color(0xffffffff); // White for bottom sheets
  static const Color lightPrimary =
      Color(0xffffc107); // Lighter shade of yellow
  static const Color lightBackground =
      Color(0xfffafafa); // Near-white for the background
  static const Color lightSecondary =
      Color(0xff0288d1); // Lighter shade of blue

  static const List<Color> cardColors = [
    lightCardColor,
    darkCardColor,
    Color(0xFF0A0A0A), // Nearly black
    Color(0xFF4A0000), // Very dark red
    Color(0xFF4A2000), // Very dark orange
    Color(0xFF4A4000), // Very dark yellow
    Color(0xFF0A3300), // Very dark green
    Color(0xFF002A2A), // Very dark teal
    Color(0xFF002A4A), // Very dark light blue
    Color(0xFF00204A), // Very dark blue
    Color(0xFF2A004A), // Very dark purple
    Color(0xFF4A0033), // Very dark pink
    Color(0xFF2A1A0A), // Very dark brown
    Color(0xFF1A1A1A), // Very dark gray
  ];
}
