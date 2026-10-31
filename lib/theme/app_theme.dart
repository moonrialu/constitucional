import 'package:flutter/material.dart';

/// Paleta do gabinete: base azul-marinho e creme, com cores vivas por área do
/// conteúdo. Todos os tons usados em texto sobre fundo claro foram escolhidos
/// com contraste mínimo de 4.5:1 (WCAG AA).
abstract final class AppColors {
  // Base
  static const Color ink = Color(0xFF12202F);
  static const Color navy = Color(0xFF1B3A57);
  static const Color surface = Color(0xFFFFFCF5);
  static const Color line = Color(0xFFD8D2C4);

  // Cores vivas (superfícies claras) e suas versões para texto
  static const Color teal = Color(0xFF0E7C66);
  static const Color tealText = Color(0xFF0A6353);
  static const Color tealSoft = Color(0xFFE3F4EF);

  static const Color plum = Color(0xFF8A3A6B);
  static const Color plumText = Color(0xFF70305A);
  static const Color plumSoft = Color(0xFFF7E7F1);

  static const Color gold = Color(0xFFC08319);
  static const Color goldText = Color(0xFF7E5610);
  static const Color goldSoft = Color(0xFFFBF0D9);

  static const Color crimson = Color(0xFFB03333);
  static const Color crimsonText = Color(0xFF8E2727);
  static const Color crimsonSoft = Color(0xFFFBE6E6);

  static const Color indigo = Color(0xFF3D4FA3);
  static const Color indigoText = Color(0xFF32408A);
  static const Color indigoSoft = Color(0xFFE7EAF8);

  static const Color success = tealText;
  static const Color danger = crimsonText;

  /// Feedback é uma etapa própria, mas herda a cor do caso de origem.
  static String _baseId(String id) =>
      id.endsWith('-feedback') ? id.replaceAll('-feedback', '') : id;

  /// Cor de destaque de cada caso/etapa, pela posição na jornada.
  static Color accentFor(String stepId) {
    switch (_baseId(stepId)) {
      case 'case1':
      case 'battle1':
      case 'check1':
        return teal;
      case 'case2':
      case 'battle2':
      case 'check2':
        return plum;
      case 'case3':
      case 'battle3':
        return gold;
      case 'case4':
      case 'battle4':
        return crimson;
      case 'case5':
      case 'battle5':
      case 'check3':
        return indigo;
      case 'quiz':
      case 'diagnosis':
        return indigo;
      default:
        return navy;
    }
  }

  static Color accentTextFor(String stepId) {
    switch (_baseId(stepId)) {
      case 'case1':
      case 'battle1':
      case 'check1':
        return tealText;
      case 'case2':
      case 'battle2':
      case 'check2':
        return plumText;
      case 'case3':
      case 'battle3':
        return goldText;
      case 'case4':
      case 'battle4':
        return crimsonText;
      case 'case5':
      case 'battle5':
      case 'check3':
        return indigoText;
      case 'quiz':
      case 'diagnosis':
        return indigoText;
      default:
        return ink;
    }
  }

  static Color softFor(String stepId) {
    switch (_baseId(stepId)) {
      case 'case1':
      case 'battle1':
      case 'check1':
        return tealSoft;
      case 'case2':
      case 'battle2':
      case 'check2':
        return plumSoft;
      case 'case3':
      case 'battle3':
        return goldSoft;
      case 'case4':
      case 'battle4':
        return crimsonSoft;
      case 'case5':
      case 'battle5':
      case 'check3':
        return indigoSoft;
      case 'quiz':
      case 'diagnosis':
        return indigoSoft;
      default:
        return const Color(0xFFEDE9DE);
    }
  }
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.navy,
    primary: AppColors.navy,
    secondary: AppColors.teal,
    tertiary: AppColors.gold,
    error: AppColors.crimson,
    surface: AppColors.surface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        foregroundColor: AppColors.navy,
        side: const BorderSide(color: AppColors.navy, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.tealSoft,
      labelStyle: const TextStyle(
        color: AppColors.tealText,
        fontWeight: FontWeight.w700,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w800,
        height: 1.18,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w800,
        height: 1.22,
        color: AppColors.ink,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.ink,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: AppColors.ink),
      bodyMedium: TextStyle(fontSize: 15, height: 1.5, color: AppColors.ink),
      bodySmall: TextStyle(fontSize: 13, height: 1.45, color: AppColors.ink),
    ),
  );
}
