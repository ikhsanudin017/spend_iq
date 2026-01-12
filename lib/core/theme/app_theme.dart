// ignore_for_file: sort_constructors_first, prefer_expression_function_bodies

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class AppTheme {
  final ThemeData light;
  final ThemeData dark;
  final NumberTheme numberTheme;

  AppTheme._(this.light, this.dark, this.numberTheme);

  factory AppTheme.build() {
    final baseText = GoogleFonts.interTextTheme();
    final numberTheme = NumberTheme._internal(
      display: GoogleFonts.spaceGrotesk(
        fontSize: 44,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.1,
      ),
      medium: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
      ),
      small: GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );

    // Tema Biru Putih Bersih
    final colorSchemeLight = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ).copyWith(
      surface: AppColors.surface,
      surfaceTint: Colors.transparent,
      surfaceContainerHighest: AppColors.surfaceAlt,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.accentSoft,
      tertiary: AppColors.primaryLight,
      outline: AppColors.border,
      outlineVariant: AppColors.borderLight,
      error: AppColors.textSecondary,
      onError: Colors.white,
    );

    final colorSchemeDark = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      surface: AppColors.textPrimary,
      surfaceTint: AppColors.primary,
      surfaceContainerHighest: AppColors.textPrimary,
      secondary: AppColors.accent,
      onSecondary: AppColors.textPrimary,
      tertiary: AppColors.primary,
      onTertiary: Colors.white,
      outline: AppColors.border.withAlpha(180),
      error: AppColors.textSecondary,
      onError: Colors.white,
    );

    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeLight,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(baseText, colorSchemeLight),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorSchemeLight.onSurface,
        titleTextStyle: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorSchemeLight.surface,
        indicatorColor: colorSchemeLight.primary.withAlpha(36),
        elevation: 3,
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => baseText.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? colorSchemeLight.primary
                : colorSchemeLight.onSurfaceVariant,
            fontWeight:
                states.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorSchemeLight.surface,
        elevation: 0, // Flat design, clean
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        iconColor: colorSchemeLight.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      dividerTheme: DividerThemeData(
        color: colorSchemeLight.outline.withAlpha(60),
        thickness: 1,
        space: 24,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorSchemeLight.surface,
        modalBackgroundColor: colorSchemeLight.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        showDragHandle: true,
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorSchemeLight.surfaceContainerHighest.withAlpha(36),
        selectedColor: colorSchemeLight.primary.withAlpha(36),
        labelStyle: baseText.labelMedium?.copyWith(
          color: colorSchemeLight.onSurface,
          fontWeight: FontWeight.w600,
        ),
        shape: StadiumBorder(side: BorderSide(color: colorSchemeLight.outline.withAlpha(60))),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      iconTheme: IconThemeData(color: colorSchemeLight.onSurfaceVariant),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorSchemeLight.primary,
          foregroundColor: colorSchemeLight.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorSchemeLight.primary,
          foregroundColor: colorSchemeLight.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorSchemeLight.primary,
          side: BorderSide(color: colorSchemeLight.primary.withAlpha(120)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: _inputTheme(colorSchemeLight),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeDark,
      scaffoldBackgroundColor: AppColors.textPrimary,
      textTheme: _buildTextTheme(baseText, colorSchemeDark),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorSchemeDark.onSurface,
        titleTextStyle: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorSchemeDark.surface,
        indicatorColor: colorSchemeDark.primary.withAlpha(48),
        elevation: 4,
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => baseText.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? colorSchemeDark.primary
                : colorSchemeDark.onSurfaceVariant,
            fontWeight:
                states.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorSchemeDark.surface,
        elevation: 6,
        shadowColor: Colors.black.withAlpha(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        iconColor: colorSchemeDark.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      dividerTheme: DividerThemeData(
        color: colorSchemeDark.outline.withAlpha(80),
        thickness: 1,
        space: 24,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorSchemeDark.surface,
        modalBackgroundColor: colorSchemeDark.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        showDragHandle: true,
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorSchemeDark.surfaceContainerHighest.withAlpha(28),
        selectedColor: colorSchemeDark.primary.withAlpha(48),
        labelStyle: baseText.labelMedium?.copyWith(
          color: colorSchemeDark.onSurface,
          fontWeight: FontWeight.w600,
        ),
        shape: StadiumBorder(side: BorderSide(color: colorSchemeDark.outline.withAlpha(80))),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      iconTheme: IconThemeData(color: colorSchemeDark.onSurfaceVariant),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorSchemeDark.primary,
          foregroundColor: colorSchemeDark.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorSchemeDark.primary,
          foregroundColor: colorSchemeDark.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorSchemeDark.onSurface,
          side: BorderSide(color: colorSchemeDark.primary.withAlpha(160)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: _inputTheme(colorSchemeDark),
    );

    return AppTheme._(lightTheme, darkTheme, numberTheme);
  }

  /// Hierarki Typography Spend-IQ:
  /// 
  /// DISPLAY (Hero Text - Terbesar)
  /// - displayLarge: 57px, w700 - Splash screen, hero title
  /// - displayMedium: 45px, w600 - Landing page title
  /// - displaySmall: 36px, w600 - Section hero
  /// 
  /// HEADLINE (Judul Utama)
  /// - headlineLarge: 32px, w600 - Halaman utama title
  /// - headlineMedium: 28px, w600 - Card besar title
  /// - headlineSmall: 24px, w600 - Section title
  /// 
  /// TITLE (Sub Judul)
  /// - titleLarge: 22px, w600 - AppBar, Card title utama
  /// - titleMedium: 16px, w500 - List item title, Sub section
  /// - titleSmall: 14px, w500 - Small card title, Chip text
  /// 
  /// BODY (Konten Utama)
  /// - bodyLarge: 16px, w400 - Paragraf utama, Deskripsi panjang
  /// - bodyMedium: 14px, w400 - Konten standar, Deskripsi
  /// - bodySmall: 12px, w400 - Konten kecil, Helper text
  /// 
  /// LABEL (Label & Button)
  /// - labelLarge: 14px, w600 - Button text, Input label
  /// - labelMedium: 12px, w500 - Tab label, Navigation
  /// - labelSmall: 11px, w500 - Badge, Tag kecil
  static TextTheme _buildTextTheme(TextTheme base, ColorScheme scheme) {
    return base.copyWith(
      // DISPLAY - Hero Text (Terbesar)
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.2,
        color: scheme.onSurface,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.0,
        height: 1.2,
        color: scheme.onSurface,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.3,
        color: scheme.onSurface,
      ),
      
      // HEADLINE - Judul Utama
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.3,
        color: scheme.onSurface,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.3,
        color: scheme.onSurface,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.4,
        color: scheme.onSurface,
      ),
      
      // TITLE - Sub Judul
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: scheme.onSurface,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.5,
        color: scheme.onSurface,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.5,
        color: scheme.onSurfaceVariant,
      ),
      
      // BODY - Konten Utama
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.6,
        color: scheme.onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.5,
        color: scheme.onSurfaceVariant,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
        height: 1.4,
        color: scheme.onSurfaceVariant,
      ),
      
      // LABEL - Label & Button
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
        color: scheme.onSurface,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        height: 1.4,
        color: scheme.onSurfaceVariant,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        height: 1.3,
        color: scheme.onSurfaceVariant,
      ),
    );
  }

  static InputDecorationTheme _inputTheme(ColorScheme scheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withAlpha(32),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.outline.withAlpha(65)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

class NumberTheme {
  const NumberTheme._internal({
    required this.display,
    required this.medium,
    required this.small,
  });

  final TextStyle display;
  final TextStyle medium;
  final TextStyle small;
}

final appThemeProvider = Provider<AppTheme>((ref) => AppTheme.build());

final numberThemeProvider =
    Provider<NumberTheme>((ref) => ref.watch(appThemeProvider).numberTheme);

