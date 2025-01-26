import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryRed = Color(0xFFE53935); // Main red
  static const Color primaryWhite = Color(0xFFFAFAFA); // Main white

  // Secondary Colors
  static const Color secondaryRed =
      Color(0xFFEF5350); // Lighter red for hover/highlights
  static const Color darkRed = Color(0xFFC62828); // Darker red for depth

  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA); // Lightest grey
  static const Color grey100 = Color(0xFFF5F5F5); // Background grey
  static const Color grey200 = Color(0xFFEEEEEE); // Divider grey
  static const Color grey300 = Color(0xFFE0E0E0); // Disabled grey
  static const Color grey600 = Color(0xFF757575); // Subtitle grey
  static const Color grey900 = Color(0xFF212121); // Text grey

  // Accent Colors
  static const Color accentBlue = Color(0xFF2196F3); // Information/Links
  static const Color accentGreen = Color(0xFF4CAF50); // Success states
  static const Color accentOrange = Color(0xFFFF9800); // Warning states

  // Transparent Colors
  static const Color redTransparent = Color(0x14E53935); // Red with 8% opacity
  static const Color greyTransparent =
      Color(0x14757575); // Grey with 8% opacity

  static ThemeData lightTheme = ThemeData(
      // Basic Theme Colors
      primaryColor: primaryRed,
      scaffoldBackgroundColor: primaryWhite,
      colorScheme: const ColorScheme.light(
        primary: primaryRed,
        secondary: secondaryRed,
        surface: primaryWhite,
        // background: grey100,
        error: darkRed,
        onPrimary: primaryWhite,
        onSecondary: primaryWhite,
        onSurface: grey900,
        // onBackground: grey900,
        onError: primaryWhite,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.red,
        foregroundColor: primaryWhite,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: grey900,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: primaryWhite,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: primaryWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryRed,
          side: const BorderSide(color: primaryRed, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            // letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryRed,
          textStyle: const TextStyle(
              // fontSize: 16,
              // fontWeight: FontWeight.w600,
              // letterSpacing: 0.5,
              ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: grey100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkRed, width: 2),
        ),
        labelStyle: const TextStyle(color: grey600),
        hintStyle: const TextStyle(color: grey600),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: redTransparent,
        selectedColor: primaryRed,
        disabledColor: grey300,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        labelStyle: const TextStyle(color: grey900),
        secondaryLabelStyle: const TextStyle(color: primaryWhite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: grey900,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: grey600,
          fontSize: 16,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: primaryWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: grey900,
        contentTextStyle: TextStyle(color: primaryWhite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: grey600,
        thickness: 1,
        space: 24,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: grey900,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: grey900,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: grey900,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: grey900,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: grey900,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: grey900,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: grey900,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: grey900,
        ),
      ),
      listTileTheme: ListTileThemeData(textColor: grey600),
      iconTheme: IconThemeData(color: primaryWhite));
}
