import 'package:flutter/material.dart';

/// MAHALLI design tokens. All styling values live here so screens stay free
/// of scattered raw colors/sizes.
class MahalliColors {
  const MahalliColors._();

  // Brand palette — deep teal + warm amber accent.
  static const Color primary = Color(0xFF0E7C61);
  static const Color primaryDark = Color(0xFF095C48);
  static const Color primaryLight = Color(0xFF3DA98B);
  static const Color accent = Color(0xFFF5A623);
  static const Color accentDark = Color(0xFFD98A0B);

  static const Color background = Color(0xFFF6F7F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFEFF3F0);

  static const Color textPrimary = Color(0xFF14231E);
  static const Color textSecondary = Color(0xFF5C6B65);
  static const Color border = Color(0xFFDFE6E2);

  static const Color success = Color(0xFF1E9E5A);
  static const Color warning = Color(0xFFE28C00);
  static const Color danger = Color(0xFFCE4B3E);

  /// Demo-mode banner (must always be visually distinct from real data).
  static const Color demoBanner = Color(0xFFFFF3D6);
  static const Color demoBannerText = Color(0xFF8A5A00);

  static Color fromHex(String hex) {
    var value = hex.replaceFirst('#', '');
    if (value.length == 6) value = 'FF$value';
    final parsed = int.tryParse(value, radix: 16);
    return parsed == null ? primary : Color(parsed);
  }
}

class MahalliSpacing {
  const MahalliSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class MahalliRadius {
  const MahalliRadius._();

  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;
  static const double card = 22;
  static const double pill = 999;
}

/// Builds the single MaterialApp theme used by MAHALLI.
ThemeData mahalliTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: MahalliColors.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: MahalliColors.primary,
    secondary: MahalliColors.accent,
    surface: MahalliColors.surface,
    error: MahalliColors.danger,
  );

  // Handicrafts is a decorative display font (Arabic + Latin glyphs) used
  // for brand headings and loyalty-card titles. Body text uses Roboto, which
  // ships with Flutter and covers both languages fully, so any glyph missing
  // from Handicrafts never breaks rendering — Flutter also falls back
  // per-character automatically.
  const bodyFont = 'Roboto';
  const displayFont = 'Handicrafts';

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: MahalliColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: MahalliColors.background,
      foregroundColor: MahalliColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: MahalliColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        fontFamily: displayFont,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: MahalliColors.surface,
      indicatorColor: MahalliColors.primary.withValues(alpha: 0.14),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? MahalliColors.primary
              : MahalliColors.textSecondary,
        ),
      ),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardThemeData(
      color: MahalliColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MahalliRadius.card),
        side: const BorderSide(color: MahalliColors.border),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: MahalliColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MahalliRadius.md),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: MahalliColors.primary,
        minimumSize: const Size(0, 44),
        side: const BorderSide(color: MahalliColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MahalliRadius.md),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MahalliColors.surface,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: MahalliSpacing.lg, vertical: MahalliSpacing.md),
      hintStyle: const TextStyle(color: MahalliColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MahalliRadius.md),
        borderSide: const BorderSide(color: MahalliColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MahalliRadius.md),
        borderSide: const BorderSide(color: MahalliColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MahalliRadius.md),
        borderSide: const BorderSide(color: MahalliColors.primary, width: 1.6),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: MahalliColors.surfaceAlt,
      side: const BorderSide(color: MahalliColors.border),
      labelStyle: const TextStyle(
        color: MahalliColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MahalliRadius.pill),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: MahalliColors.border,
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MahalliRadius.sm),
      ),
    ),
    textTheme: Typography.englishLike2021.apply(
      bodyColor: MahalliColors.textPrimary,
      displayColor: MahalliColors.textPrimary,
    ).copyWith(
      bodyMedium: const TextStyle(
        color: MahalliColors.textPrimary,
        fontFamily: bodyFont,
      ),
      titleLarge: const TextStyle(
        fontWeight: FontWeight.w700,
        fontFamily: displayFont,
      ),
    ),
  );
}
