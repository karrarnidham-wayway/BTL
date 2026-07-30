import 'package:flutter/material.dart';

/// Uygulamanın marka renkleri: logodaki siyah + altın/amber temayı yansıtır.
class AppColors {
  static const background = Color(0xFF0E0E10);
  static const surface = Color(0xFF19191C);
  static const gold = Color(0xFFD4AF37);
  static const goldLight = Color(0xFFF0CE6A);
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFFA0A0A5);
  static const danger = Color(0xFFE5484D);
  static const success = Color(0xFF3DD68C);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.gold,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.goldLight,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        titleMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
