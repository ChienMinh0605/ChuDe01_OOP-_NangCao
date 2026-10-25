import 'package:flutter/material.dart';

ThemeData createAppTheme() {
  final colors = ColorScheme.fromSeed(seedColor: const Color(0xFFBD602F))
      .copyWith(
        primary: const Color(0xFFAC4E24),
        onPrimary: Colors.white,
        primaryContainer: const Color(0xFFFFEBDC),
        onPrimaryContainer: const Color(0xFF783917),
        secondary: const Color(0xFF2F607D),
        secondaryContainer: const Color(0xFFEAF2F7),
        onSecondaryContainer: const Color(0xFF264A63),
        surface: Colors.white,
        onSurface: const Color(0xFF263545),
        onSurfaceVariant: const Color(0xFF6B7684),
        outlineVariant: const Color(0xFFE6E7E7),
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: const Color(0xFFF7F6F2),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFAFBFC),
      contentPadding: const EdgeInsets.all(18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
