import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Mama Care brand color palette — Pastel Calm
class NurtureColors {
  NurtureColors._();

  // Core brand pastels
  static const Color primaryPink = Color(0xFFF8BBD0);
  static const Color secondaryBlue = Color(0xFFB3E5FC);
  static const Color successGreen = Color(0xFFC8E6C9);
  static const Color alertRed = Color(0xFFEF9A9A);

  // Deep accent versions (for interactive elements)
  static const Color pinkAccent = Color(0xFFEC407A);
  static const Color blueAccent = Color(0xFF29B6F6);
  static const Color greenAccent = Color(0xFF4CAF50);
  static const Color redAccent = Color(0xFFEF5350);

  // Neutrals
  static const Color background = Color(0xFFFFF9FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F8F8);
  static const Color border = Color(0xFFEEE0EC);
  static const Color textPrimary = Color(0xFF1C1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFB0B7C3);

  // Navigation
  static const Color navSurface = Color(0xFFFFFFFF);
  static const Color navBorder = Color(0xFFEAD8E5);

  // Card shadow
  static const Color shadow = Color(0x0D000000);

  // Traffic light status
  static const Color statusGreen = Color(0xFF4CAF50);
  static const Color statusYellow = Color(0xFFFFA726);
  static const Color statusRed = Color(0xFFEF5350);
}

class AppTheme {
  AppTheme._();

  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.nunito(
        fontSize: 57, fontWeight: FontWeight.w800, color: NurtureColors.textPrimary),
    displayMedium: GoogleFonts.nunito(
        fontSize: 45, fontWeight: FontWeight.w700, color: NurtureColors.textPrimary),
    displaySmall: GoogleFonts.nunito(
        fontSize: 36, fontWeight: FontWeight.w700, color: NurtureColors.textPrimary),
    headlineLarge: GoogleFonts.nunito(
        fontSize: 32, fontWeight: FontWeight.w700, color: NurtureColors.textPrimary),
    headlineMedium: GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w700, color: NurtureColors.textPrimary),
    headlineSmall: GoogleFonts.nunito(
        fontSize: 24, fontWeight: FontWeight.w600, color: NurtureColors.textPrimary),
    titleLarge: GoogleFonts.nunito(
        fontSize: 22, fontWeight: FontWeight.w600, color: NurtureColors.textPrimary),
    titleMedium: GoogleFonts.nunito(
        fontSize: 16, fontWeight: FontWeight.w600, color: NurtureColors.textPrimary),
    titleSmall: GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.w600, color: NurtureColors.textPrimary),
    bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, color: NurtureColors.textPrimary),
    bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, color: NurtureColors.textPrimary),
    bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400, color: NurtureColors.textSecondary),
    labelLarge: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600, color: NurtureColors.textPrimary),
    labelMedium: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w500, color: NurtureColors.textSecondary),
    labelSmall: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w500, color: NurtureColors.textSecondary),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: NurtureColors.pinkAccent,
        primaryContainer: NurtureColors.primaryPink,
        secondary: NurtureColors.blueAccent,
        secondaryContainer: NurtureColors.secondaryBlue,
        tertiary: NurtureColors.greenAccent,
        tertiaryContainer: NurtureColors.successGreen,
        error: NurtureColors.redAccent,
        errorContainer: NurtureColors.alertRed,
        surface: NurtureColors.surface,
        onPrimary: Colors.white,
        onPrimaryContainer: Color(0xFF880E4F),
        onSecondary: Colors.white,
        onSurface: NurtureColors.textPrimary,
        onSurfaceVariant: NurtureColors.textSecondary,
        outline: NurtureColors.border,
        outlineVariant: Color(0xFFF4ECF2),
      ),
      scaffoldBackgroundColor: NurtureColors.background,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: NurtureColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: NurtureColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NurtureColors.surfaceVariant,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: NurtureColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: NurtureColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: NurtureColors.pinkAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: NurtureColors.alertRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: NurtureColors.redAccent, width: 2),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: NurtureColors.textSecondary),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: NurtureColors.textHint),
        prefixIconColor: NurtureColors.textSecondary,
        suffixIconColor: NurtureColors.textSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NurtureColors.pinkAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: NurtureColors.pinkAccent,
          side: const BorderSide(color: NurtureColors.pinkAccent, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: NurtureColors.pinkAccent,
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: NurtureColors.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0x4DF8BBD0),
        selectedColor: NurtureColors.pinkAccent,
        labelStyle: GoogleFonts.inter(fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      dividerTheme: const DividerThemeData(
        color: NurtureColors.border,
        thickness: 1,
        space: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: NurtureColors.textPrimary,
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
