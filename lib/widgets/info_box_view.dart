import 'package:flutter/material.dart';

import '../models/content.dart';
import '../theme/app_theme.dart';

/// Caixa de destaque usada para dicas, limites, origem do conceito e debates.
class InfoBoxView extends StatelessWidget {
  const InfoBoxView({
    super.key,
    required this.box,
    this.color = AppColors.navy,
  });

  final InfoBox box;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (box.title != null) ...[
            Text(
              box.title!,
              style: theme.textTheme.titleMedium?.copyWith(color: color),
            ),
            const SizedBox(height: 8),
          ],
          if (box.text != null)
            Text(box.text!, style: theme.textTheme.bodyMedium),
          if (box.bullets.isNotEmpty) ...[
            if (box.text != null) const SizedBox(height: 10),
            for (final bullet in box.bullets)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•',
                      style: theme.textTheme.bodyMedium?.copyWith(color: color),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(bullet, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
