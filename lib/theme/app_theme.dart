// app/themes/app_colors.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color secondaryColor = Color(0xFFA29BFE);
  static const Color accentColor = Color(0xFF00CE9F);
  static const Color darkPrimary = Color(0xFF4834D4);
  static const Color lightPrimary = Color(0xFF7D6BFF);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);

  // Light theme colors
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightCard = Color(0xFFFFFFFF);
}

// app/themes/light_theme.dart
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primaryColor,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    surface: AppColors.lightCard,
    background: AppColors.lightBackground,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  cardTheme: CardTheme(
    color: AppColors.lightCard,
    elevation: 2,
    margin: EdgeInsets.all(8),
  ),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: Colors.black87,
    displayColor: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);

// app/themes/dark_theme.dart
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.darkPrimary,
  colorScheme: ColorScheme.dark(
    primary: AppColors.darkPrimary,
    secondary: AppColors.secondaryColor,
    surface: AppColors.darkCard,
    background: AppColors.darkBackground,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  cardTheme: CardTheme(
    color: AppColors.darkCard,
    elevation: 2,
    margin: EdgeInsets.all(8),
  ),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: Colors.white70,
    displayColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkPrimary,
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);