import 'package:flutter/material.dart';

import '../models/content.dart';
import '../theme/app_theme.dart';
import 'info_box_view.dart';

/// Painel de feedback: veredito, explicação e caixa extra opcional.
class FeedbackPanel extends StatelessWidget {
  const FeedbackPanel({super.key, required this.choice});

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final correct = choice.correct;
    final color = correct ? AppColors.success : AppColors.danger;
    final label = correct ? 'Escolha acertada' : 'Escolha comentada';
    final icon = correct ? Icons.check_circle_outline : Icons.info_outline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final paragraph in choice.feedback) ...[
          Text(paragraph, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 12),
        ],
        if (choice.note != null) InfoBoxView(box: choice.note!),
      ],
    );
  }
}
