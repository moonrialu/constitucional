import 'package:flutter/material.dart';

import '../models/game_stats.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum FinaleAction { restart, close }

const Color _gold = Color(0xFFB08A3E);
const Color _goldWash = Color(0xFFF4EBD6);

/// Tela de efetivação exibida ao concluir o caso da Profa. Lúcia.
Future<FinaleAction?> showFinaleSheet(
  BuildContext context, {
  required GameStats stats,
  int? correctAnswers,
  int? answeredQuestions,
}) {
  return showModalBottomSheet<FinaleAction>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    constraints: const BoxConstraints(maxWidth: 560),
    barrierColor: AppColors.ink.withValues(alpha: 0.55),
    builder: (BuildContext sheetContext) {
      return DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 12, 26, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: _goldWash,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    size: 38,
                    color: _gold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'FIM DO TREINAMENTO · STF',
                  style: AppTheme.overline.copyWith(letterSpacing: 1.8),
                ),
                const SizedBox(height: 12),
                Text(
                  '🎉 PARABÉNS!\nVOCÊ FOI EFETIVADO!',
                  textAlign: TextAlign.center,
                  style: AppTheme.sheetTitle.copyWith(fontSize: 27),
                ),
                const SizedBox(height: 14),
                Text(
                  'O Ministro e a Banca aprovaram o seu desempenho! Você demonstrou domínio sobre Mutação Constitucional e mostrou que é um ótimo estagiário. Sua efetivação como Assessor(a) do STF está garantida!',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMuted.copyWith(
                    fontSize: 14,
                    height: 1.55,
                    color: AppColors.inkSoft,
                  ),
                ),
                if (correctAnswers != null && answeredQuestions != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'BANCA FINAL · $correctAnswers DE $answeredQuestions ACERTOS',
                    textAlign: TextAlign.center,
                    style: AppTheme.overline.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      color: AppColors.terracottaDark,
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                  decoration: BoxDecoration(
                    color: AppColors.sand,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _Metric(
                          label: 'PRESTÍGIO FINAL',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                '${stats.prestige}',
                                style: const TextStyle(
                                  fontFamily: AppTheme.headingFont,
                                  fontSize: 30,
                                  height: 1,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.terracottaDark,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Text(
                                '%',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.terracottaDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(width: 1, height: 52, color: AppColors.line),
                      Expanded(
                        child: _Metric(
                          label: 'CAFÉS RESTANTES',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < GameStats.maxCoffees; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: Icon(
                                    Icons.local_cafe_rounded,
                                    size: 22,
                                    color: i < stats.coffees
                                        ? AppColors.terracottaDark
                                        : AppColors.muted.withValues(
                                            alpha: 0.3,
                                          ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.of(sheetContext).pop(FinaleAction.restart),
                    child: const Text('Reiniciar jogo'),
                  ),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () =>
                      Navigator.of(sheetContext).pop(FinaleAction.close),
                  child: const Text(
                    'Voltar para as conversas',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: AppTheme.overline.copyWith(fontSize: 8, letterSpacing: 1.3),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
