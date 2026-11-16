import 'package:flutter/material.dart';

import '../models/game_stats.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Barra de status superior: xícaras (vidas), prestígio e combo.
///
/// As xícaras só entram em cena no teste de respostas ([showCoffees]).
class StatusBar extends StatelessWidget {
  const StatusBar({super.key, required this.stats, this.showCoffees = false});

  final GameStats stats;
  final bool showCoffees;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 9, 18, 10),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: <Widget>[
          if (showCoffees) ...<Widget>[
            _Coffees(count: stats.coffees),
            const SizedBox(width: 16),
          ],
          Expanded(child: _Prestige(stats: stats)),
          if (stats.hasCombo) ...<Widget>[
            const SizedBox(width: 10),
            _ComboBadge(combo: stats.combo),
          ],
        ],
      ),
    );
  }
}

class _Coffees extends StatelessWidget {
  const _Coffees({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$count de ${GameStats.maxCoffees} cafés disponíveis',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < GameStats.maxCoffees; i++)
            Padding(
              padding: EdgeInsets.only(
                right: i == GameStats.maxCoffees - 1 ? 0 : 2,
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: i < count ? 1 : 0.32,
                child: Icon(
                  Icons.local_cafe_rounded,
                  size: 19,
                  color: i < count ? AppColors.terracottaDark : AppColors.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Prestige extends StatelessWidget {
  const _Prestige({required this.stats});

  final GameStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Text(
                'PRESTÍGIO NO GABINETE',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.overline.copyWith(
                  fontSize: 8,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${stats.prestige}%',
              style: const TextStyle(
                fontSize: 9.5,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: AppColors.terracottaDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            height: 5,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                const ColoredBox(color: AppColors.paperDeep),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: stats.prestigeRatio),
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  builder: (BuildContext context, double value, _) {
                    return FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value.clamp(0, 1),
                      child: const ColoredBox(color: AppColors.terracotta),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ComboBadge extends StatefulWidget {
  const _ComboBadge({required this.combo});

  final int combo;

  @override
  State<_ComboBadge> createState() => _ComboBadgeState();
}

class _ComboBadgeState extends State<_ComboBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0,
    upperBound: 1,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.97,
        end: 1.07,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.terracottaWash,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.terracotta.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.local_fire_department_rounded,
              size: 14,
              color: AppColors.terracottaDark,
            ),
            const SizedBox(width: 3),
            Text(
              '${widget.combo}x COMBO',
              style: const TextStyle(
                fontSize: 9.5,
                height: 1.1,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: AppColors.terracottaDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
