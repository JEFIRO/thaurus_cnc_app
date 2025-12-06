import 'package:flutter/material.dart';

class AppTheme {
  static const grafiteProfundo = Color(0xFF2B2B2B);
  static const cinzaEscuro = Color(0xFF3A3A3A);
  static const cinzaMedio = Color(0xFF8D8D8D);
  static const cinzaClaro = Color(0xFFF1F1F1);
  static const branco = Color(0xFFFFFFFF);

  static const corDestaque = Color(0xFF0C3F57);

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: grafiteProfundo,
    useMaterial3: true,

    colorScheme: const ColorScheme.dark(
      primary: corDestaque,
      secondary: corDestaque,
      surface: grafiteProfundo,
      onPrimary: grafiteProfundo,
      onSecondary: cinzaClaro,
      error: Color(0xFFCF6679),
      background: grafiteProfundo,
    ),


    appBarTheme: const AppBarTheme(
      backgroundColor: grafiteProfundo,
      foregroundColor: branco,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: branco,
      ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: branco,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      bodyLarge: TextStyle(color: cinzaClaro, fontSize: 16),
      bodyMedium: TextStyle(color: cinzaMedio, fontSize: 14),
      labelLarge: TextStyle(
        color: branco,
        fontWeight: FontWeight.bold,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cinzaEscuro,
      hintStyle: const TextStyle(color: cinzaMedio),
      labelStyle: const TextStyle(color: cinzaClaro),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: cinzaMedio),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: corDestaque, width: 2.0),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: corDestaque,
        foregroundColor: grafiteProfundo,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: corDestaque),
        foregroundColor: corDestaque,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 15),
      ),
    ),

    iconTheme: const IconThemeData(color: cinzaClaro, size: 24),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: cinzaEscuro,
      contentTextStyle: TextStyle(color: branco),
      behavior: SnackBarBehavior.floating,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppTheme.corDestaque,
      foregroundColor: AppTheme.grafiteProfundo,
    ),
  );
}