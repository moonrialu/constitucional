import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/cards.dart';
import '../engine/game_controller.dart';
import '../models/card.dart';
import '../theme/app_theme.dart';
import '../widgets/card_view.dart';
import '../widgets/game_dialog.dart';

/// Coleção completa de cartas, com o que já foi desbloqueado e como obter o
/// restante.
class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  static const Map<String?, String> _groupTitles = {
    null: 'Baralho inicial',
    'battle1': 'Recompensa do Caso 1',
    'check1': 'Etapa 1 · Regra ou princípio',
    'battle2': 'Recompensa do Caso 2',
    'check2': 'Etapa 2 · Quem disse o quê',
    'theory2': 'Teoria · Mutação constitucional',
    'battle3': 'Recompensa do Caso 3',
    'battle4': 'Recompensa do Caso 4',
    'battle5': 'Recompensa do Caso 5',
    'check3': 'Etapa 3 · Proporcionalidade',
    'quiz': 'Teste final',
  };

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Coleção de cartas'),
            Text(
              '${controller.unlockedCardCount} de ${allCards.length} desbloqueadas',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.indigoSoft,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.indigo.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'As cartas são cumulativas: vencer batalhas e concluir as etapas '
                'interativas libera fundamentos novos. Nada é perdido ao refazer '
                'uma batalha.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.indigoText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            for (final entry in _groupTitles.entries) ...[
              const SizedBox(height: 18),
              _SectionTitle(
                '${entry.value} · '
                '${allCards.where((c) => c.unlock == entry.key).length} cartas',
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: [
                  for (final card in allCards.where(
                    (c) => c.unlock == entry.key,
                  ))
                    _CollectionCard(
                      card: card,
                      unlocked: controller.isCardUnlocked(card.id),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({required this.card, required this.unlocked});

  final ArgumentCard card;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Stack(
        children: [
          ArgumentCardView(
            card: card,
            width: 118,
            dimmed: !unlocked,
            playable: unlocked,
          ),
          if (!unlocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => GameDialog(
        icon: card.icon,
        accent: card.color,
        title: card.title,
        scrollable: true,
        primaryLabel: 'Fechar',
        onPrimary: () => Navigator.of(context).pop(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${card.kindLabel} · custo ${card.cost} · ${card.effectLabel}',
              style: TextStyle(
                color: card.color,
                fontWeight: FontWeight.w800,
                fontSize: 11.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              card.text,
              style: const TextStyle(
                color: Color(0xFFDDE6EE),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            if (card.precedent != null) ...[
              const SizedBox(height: 8),
              Text(
                'Precedente: ${card.precedent}',
                style: const TextStyle(
                  color: Color(0xFFDDE6EE),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final tag in card.tags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Text(
                      tag.label,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              unlocked
                  ? 'Carta desbloqueada.'
                  : 'Bloqueada · ${card.unlockLabel ?? 'Continue a jornada.'}',
              style: TextStyle(
                color: unlocked ? AppColors.teal : AppColors.gold,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        letterSpacing: 1.2,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
      ),
    );
  }
}
