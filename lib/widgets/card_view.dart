import 'package:flutter/material.dart';

import '../models/card.dart';
import '../theme/app_theme.dart';

/// Face de uma carta de argumento.
///
/// A carta é desenhada em tamanho fixo (`width`), com tipografia que encolhe
/// para caber na mão em paisagem. O texto completo aparece na leitura da mesa
/// quando a carta é selecionada.
class ArgumentCardView extends StatelessWidget {
  const ArgumentCardView({
    super.key,
    required this.card,
    required this.width,
    this.selected = false,
    this.playable = true,
    this.dimmed = false,
    this.onTap,
  });

  final ArgumentCard card;
  final double width;
  final bool selected;
  final bool playable;
  final bool dimmed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = width * 1.42;
    final radius = width * 0.11;

    return Semantics(
      button: onTap != null,
      selected: selected,
      label:
          '${card.title}. ${card.kindLabel}. Custo ${card.cost}. '
          '${card.effectLabel}. ${card.text}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 260),
          opacity: dimmed ? 0.45 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: card.soft,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: selected
                    ? AppColors.goldText
                    : card.color.withValues(alpha: playable ? 0.55 : 0.25),
                width: selected ? 2.4 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(
                    alpha: selected ? 0.28 : 0.12,
                  ),
                  blurRadius: selected ? 16 : 6,
                  offset: Offset(0, selected ? 7 : 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(card: card, width: width),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        width * 0.09,
                        width * 0.05,
                        width * 0.09,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.ink,
                              fontSize: width * 0.13,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: width * 0.04),
                          Expanded(
                            child: Text(
                              card.text,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: width * 0.095,
                                height: 1.22,
                                color: AppColors.ink.withValues(alpha: 0.86),
                              ),
                            ),
                          ),
                          _TagRow(card: card, width: width),
                        ],
                      ),
                    ),
                  ),
                  _Footer(card: card, width: width),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.card, required this.width});

  final ArgumentCard card;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.09,
        vertical: width * 0.065,
      ),
      color: card.color,
      child: Row(
        children: [
          Icon(card.icon, size: width * 0.15, color: Colors.white),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              card.kindLabel.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.075,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
          Container(
            width: width * 0.24,
            height: width * 0.24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${card.cost}',
              style: TextStyle(
                color: card.color,
                fontSize: width * 0.14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({required this.card, required this.width});

  final ArgumentCard card;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (card.tags.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: width * 0.03),
      child: Wrap(
        spacing: 3,
        runSpacing: 2,
        children: [
          for (final tag in card.tags.take(2))
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                tag.label,
                style: TextStyle(
                  fontSize: width * 0.075,
                  fontWeight: FontWeight.w700,
                  color: card.color,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.card, required this.width});

  final ArgumentCard card;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.09,
        vertical: width * 0.055,
      ),
      color: Colors.white.withValues(alpha: 0.5),
      child: Text(
        card.effectLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: width * 0.085,
          fontWeight: FontWeight.w800,
          color: card.color,
        ),
      ),
    );
  }
}

/// Verso da carta, usado no monte de compra.
class CardBack extends StatelessWidget {
  const CardBack({super.key, required this.width, this.label});

  final double width;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * 1.42,
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(width * 0.11),
        border: Border.all(color: AppColors.gold, width: 1.4),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.balance, color: AppColors.gold, size: width * 0.34),
            if (label != null) ...[
              SizedBox(height: width * 0.06),
              Text(
                label!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
