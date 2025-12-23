import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Material Design 3 Theme System
/// Following Google's Material You design principles
class AppTheme {
  // Seed color for Material You dynamic theming
  static const Color seedColor = Color(0xFF6750A4); // Material Purple

  // Material 3 Light Color Scheme
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  // Material 3 Dark Color Scheme
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );

  // Note colors - Material 3 pastel palette
  static const List<Color> noteColors = [
    Color(0xFFFEF7FF), // Default (lightest purple)
    Color(0xFFFFF8E1), // Amber
    Color(0xFFF1F8E9), // Light Green
    Color(0xFFE1F5FE), // Light Blue
    Color(0xFFFCE4EC), // Pink
    Color(0xFFF3E5F5), // Deep Purple
    Color(0xFFE0F2F1), // Teal
    Color(0xFFFFF3E0), // Orange
    Color(0xFFE8EAF6), // Indigo
    Color(0xFFE0F7FA), // Cyan
  ];

  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,

      // Typography - Google Sans style
      textTheme: _buildTextTheme(lightColorScheme),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: lightColorScheme.surfaceTint,
        backgroundColor: lightColorScheme.surface,
        foregroundColor: lightColorScheme.onSurface,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: lightColorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: lightColorScheme.onSurfaceVariant),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 1,
        surfaceTintColor: lightColorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
      ),

      // FAB Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 3,
        highlightElevation: 4,
        backgroundColor: lightColorScheme.primaryContainer,
        foregroundColor: lightColorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        height: 80,
        backgroundColor: lightColorScheme.surface,
        surfaceTintColor: lightColorScheme.surfaceTint,
        indicatorColor: lightColorScheme.secondaryContainer,
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(color: lightColorScheme.onSecondaryContainer);
          }
          return IconThemeData(color: lightColorScheme.onSurfaceVariant);
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: lightColorScheme.onSurface,
            );
          }
          return GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: lightColorScheme.onSurfaceVariant,
          );
        }),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: lightColorScheme.surfaceVariant,
        deleteIconColor: lightColorScheme.onSurfaceVariant,
        selectedColor: lightColorScheme.secondaryContainer,
        secondarySelectedColor: lightColorScheme.secondaryContainer,
        labelStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
        hintStyle: GoogleFonts.roboto(color: lightColorScheme.onSurfaceVariant),
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: lightColorScheme.onSurfaceVariant),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: lightColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,

      // Typography - Google Sans style
      textTheme: _buildTextTheme(darkColorScheme),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: darkColorScheme.surfaceTint,
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: darkColorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: darkColorScheme.onSurfaceVariant),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 1,
        surfaceTintColor: darkColorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
      ),

      // FAB Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 3,
        highlightElevation: 4,
        backgroundColor: darkColorScheme.primaryContainer,
        foregroundColor: darkColorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        height: 80,
        backgroundColor: darkColorScheme.surface,
        surfaceTintColor: darkColorScheme.surfaceTint,
        indicatorColor: darkColorScheme.secondaryContainer,
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(color: darkColorScheme.onSecondaryContainer);
          }
          return IconThemeData(color: darkColorScheme.onSurfaceVariant);
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: darkColorScheme.onSurface,
            );
          }
          return GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: darkColorScheme.onSurfaceVariant,
          );
        }),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: darkColorScheme.surfaceVariant,
        deleteIconColor: darkColorScheme.onSurfaceVariant,
        selectedColor: darkColorScheme.secondaryContainer,
        secondarySelectedColor: darkColorScheme.secondaryContainer,
        labelStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
        hintStyle: GoogleFonts.roboto(color: darkColorScheme.onSurfaceVariant),
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: darkColorScheme.onSurfaceVariant),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: darkColorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Build Material 3 Text Theme
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display
      displayLarge: GoogleFonts.roboto(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 64 / 57,
        color: colorScheme.onSurface,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 52 / 45,
        color: colorScheme.onSurface,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 44 / 36,
        color: colorScheme.onSurface,
      ),

      // Headline
      headlineLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 40 / 32,
        color: colorScheme.onSurface,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 36 / 28,
        color: colorScheme.onSurface,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 32 / 24,
        color: colorScheme.onSurface,
      ),

      // Title
      titleLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 28 / 22,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 24 / 16,
        color: colorScheme.onSurface,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 20 / 14,
        color: colorScheme.onSurface,
      ),

      // Body
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 24 / 16,
        color: colorScheme.onSurface,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 20 / 14,
        color: colorScheme.onSurface,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 16 / 12,
        color: colorScheme.onSurface,
      ),

      // Label
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 20 / 14,
        color: colorScheme.onSurface,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 16 / 12,
        color: colorScheme.onSurface,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 16 / 11,
        color: colorScheme.onSurface,
      ),
    );
  }
}
