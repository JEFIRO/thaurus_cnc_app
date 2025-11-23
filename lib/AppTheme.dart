import 'package:flutter/material.dart';

class AppTheme {
  // Cores de Fundo e Texto (Mantidas)
  static const grafiteProfundo = Color(0xFF2B2B2B);
  static const cinzaEscuro = Color(0xFF3A3A3A);
  static const cinzaMedio = Color(0xFF8D8D8D);
  static const cinzaClaro = Color(0xFFF1F1F1);
  static const branco = Color(0xFFFFFFFF);

  // NOVA COR DE DESTAQUE: Azul Ciano suave
  static const corDestaque = Color(0xFF0C3F57); // Um azul-ciano discreto

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: grafiteProfundo,
    useMaterial3: true,

    // --- Cores principais ---
    colorScheme: const ColorScheme.dark(
      primary: corDestaque, // Usando a nova cor
      secondary: corDestaque, // Usando a nova cor
      surface: grafiteProfundo,
      onPrimary: grafiteProfundo,
      onSecondary: cinzaClaro,
      error: Color(0xFFCF6679),
      background: grafiteProfundo,
    ),

    // --- AppBar ---
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

    // --- Textos ---
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

    // --- Campos de texto ---
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
            color: corDestaque, width: 2.0), // Destaque ao focar
      ),
    ),

    // --- Botões principais ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: corDestaque, // Cor de destaque no botão principal
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

    // --- Botões secundários ---
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: corDestaque), // Borda com destaque
        foregroundColor: corDestaque,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 15),
      ),
    ),

    // --- Ícones ---
    iconTheme: const IconThemeData(color: cinzaClaro, size: 24),

    // --- Snackbar ---
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: cinzaEscuro,
      contentTextStyle: TextStyle(color: branco),
      behavior: SnackBarBehavior.floating,
    ),

    // --- Floating Action Button (FAB) ---
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppTheme.corDestaque, // Cor de destaque no FAB
      foregroundColor: AppTheme.grafiteProfundo,
    ),
  );
}