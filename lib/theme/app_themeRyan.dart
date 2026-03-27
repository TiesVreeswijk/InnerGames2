import 'package:flutter/material.dart';

class AppTheme {
  // Named button style — use this directly on any button with: style: AppTheme.primaryButton
  static final ButtonStyle primaryButton = FilledButton.styleFrom(
    minimumSize: const Size(220, 56),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    backgroundColor: Color.fromARGB(255, 228, 0, 125),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed( // blank white background
      seedColor: const Color.fromARGB(255, 255, 255, 255),
    ),

    // // Fallback theme-wide button style (disabled for now so I don't accidentally override specific button styles from classmates)
    // filledButtonTheme: FilledButtonThemeData(
    //   style: primaryButton,
    // ),


  );
}