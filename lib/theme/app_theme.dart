import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tipografia e componentes base do app.
///
/// Títulos em Lora (serifa), corpo em sans do sistema. Nada de sombras
/// fortes: a hierarquia vem de espaço, contraste e divisórias finas.
abstract final class AppTheme {
  static const String headingFont = 'Lora';

  static const TextStyle displayTitle = TextStyle(
    fontFamily: headingFont,
    fontSize: 38,
    height: 1.12,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
    color: AppColors.ink,
  );

  static const TextStyle sheetTitle = TextStyle(
    fontFamily: headingFont,
    fontSize: 25,
    height: 1.2,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
    color: AppColors.ink,
  );

  static const TextStyle name = TextStyle(
    fontFamily: headingFont,
    fontSize: 17.5,
    height: 1.25,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  static const TextStyle appBarName = TextStyle(
    fontFamily: headingFont,
    fontSize: 17,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10.5,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.2,
    color: AppColors.muted,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontSize: 13.5,
    height: 1.5,
    color: AppColors.muted,
  );

  static const TextStyle preview = TextStyle(
    fontSize: 13.5,
    height: 1.35,
    color: AppColors.muted,
  );

  static const TextStyle bubble = TextStyle(
    fontSize: 15,
    height: 1.42,
    color: AppColors.inkSoft,
  );

  static ThemeData light() {
    final ColorScheme scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.terracotta,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.terracotta,
          onPrimary: AppColors.cream,
          primaryContainer: AppColors.terracottaWash,
          onPrimaryContainer: AppColors.terracottaDark,
          secondary: AppColors.olive,
          surface: AppColors.paper,
          onSurface: AppColors.ink,
          surfaceContainerHighest: AppColors.paperDeep,
          outline: AppColors.line,
          outlineVariant: AppColors.line,
        );

    return ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.sand,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.sand,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.ink,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: const TextStyle(
          color: AppColors.cream,
          fontSize: 13.5,
          height: 1.4,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.terracotta,
          foregroundColor: AppColors.cream,
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.paper,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        titleTextStyle: name.copyWith(fontSize: 20),
        contentTextStyle: bodyMuted.copyWith(color: AppColors.inkSoft),
      ),
    );
  }
}
