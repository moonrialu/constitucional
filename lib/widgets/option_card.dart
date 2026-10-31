import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Estado visual de uma alternativa.
enum OptionState { idle, selected, correct, wrong }

/// Alternativa clicável de um caso ou do teste final.
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.letter,
    required this.text,
    this.state = OptionState.idle,
    this.accent,
    this.onTap,
  });

  final String letter;
  final String text;
  final OptionState state;

  /// Cor viva do caso/tema; cai para o azul do gabinete quando ausente.
  final Color? accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = this.accent ?? scheme.primary;

    final (
      Color border,
      Color background,
      Color badge,
      Color badgeText,
    ) = switch (state) {
      OptionState.idle => (
        accent.withValues(alpha: 0.28),
        Colors.white,
        accent.withValues(alpha: 0.14),
        accent,
      ),
      OptionState.selected => (accent, Colors.white, accent, Colors.white),
      OptionState.correct => (
        AppColors.teal,
        AppColors.tealSoft,
        AppColors.teal,
        Colors.white,
      ),
      OptionState.wrong => (
        AppColors.crimson,
        AppColors.crimsonSoft,
        AppColors.crimson,
        Colors.white,
      ),
    };

    return Semantics(
      button: true,
      label: 'Alternativa $letter: $text',
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: border, width: 1.4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badge,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    letter,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: badgeText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: state == OptionState.idle
                          ? FontWeight.w400
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
