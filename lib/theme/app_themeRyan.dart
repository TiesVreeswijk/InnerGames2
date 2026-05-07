import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryMagenta = Color(0xFFE4007D);
  static const Color lightGreyBg = Color(0xFFE0E0E0);
  static const Color settingsMagenta = Color(0xFFE4007D);
  static const Color settingsUnselected = Color(0xFFE4007D);
  static const Color settingsLightPurple = Color(0xFFE9DDFB);
  static const Color settingsDivider = Color(0xFFD9D2E3);
  static const Color settingsMuted = Color(0xFF6A6670);
  static const Color _darkBlue = Color.fromARGB(255, 44, 62, 126);
  

  // Button Style
  static final ButtonStyle primaryButton = FilledButton.styleFrom(
    minimumSize: const Size(220, 56),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    backgroundColor: primaryMagenta,
  );

  // Custom Decoration for the Bottom Container
  static const BoxDecoration bottomSheetDecoration = BoxDecoration(
    color: lightGreyBg,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(32),
      topRight: Radius.circular(32),
    ),
  );

  // Text Styles
  static const TextStyle entryScreenTitle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: _darkBlue, 
      letterSpacing: -0.5,
    );

  static const TextStyle welcomeTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle welcomeBody = TextStyle(
    fontSize: 18,
    color: Colors.black87,
    height: 1.4, // Improves readability
  );

  static const TextStyle settingsSectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  static const TextStyle settingsOption = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle settingsSubtle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'SF Pro Text',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryMagenta,
      surface: lightGreyBg,
    ),
    // You can also define global text themes here
    textTheme: const TextTheme(
      displayMedium: welcomeTitle,
      bodyLarge: welcomeBody,
    ),
  );
}
