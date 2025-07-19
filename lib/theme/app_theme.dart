import 'package:flutter/material.dart';
import '../domain/models/settings.dart';

class AppTheme {
  static ThemeData getLightTheme(int tintColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(tintColor),
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(tintColor),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(tintColor),
        foregroundColor: Colors.white,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Color(tintColor);
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Color(tintColor).withOpacity(0.5);
          }
          return Colors.grey[300];
        }),
      ),
    );
  }

  static ThemeData getDarkTheme(int tintColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(tintColor),
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      cardTheme: CardThemeData(
        color: Colors.grey[800],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(tintColor),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(tintColor),
        foregroundColor: Colors.white,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Color(tintColor);
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Color(tintColor).withOpacity(0.5);
          }
          return Colors.grey[600];
        }),
      ),
    );
  }

  static ThemeData getTheme(Settings settings, Brightness systemBrightness) {
    // If using system theme, follow system brightness
    // If not using system theme, use the manual dark mode preference
    final isDarkMode = settings.useSystemTheme 
        ? systemBrightness == Brightness.dark
        : settings.isDarkMode;
    
    return isDarkMode 
        ? getDarkTheme(settings.appTintColor)
        : getLightTheme(settings.appTintColor);
  }
} 