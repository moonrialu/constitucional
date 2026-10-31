import 'package:flutter/material.dart';

import '../data/theory.dart';
import '../models/content.dart';
import '../theme/app_theme.dart';
import 'info_box_view.dart';

/// Abre a teoria em um diálogo, sem sair da batalha.
Future<void> showTheorySheet(BuildContext context, String theoryId) async {
  final step = theoryById(theoryId);
  if (step == null) return;
  await showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 620),
        child: _TheorySheet(step: step),
      ),
    ),
  );
}

class _TheorySheet extends StatelessWidget {
  const _TheorySheet({required this.step});

  final TheoryStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 12, 0),
          child: Row(
            children: [
              const Icon(Icons.menu_book_outlined, color: AppColors.navy),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Rever a teoria',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              IconButton(
                tooltip: 'Fechar',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(step.lead, style: theme.textTheme.bodyMedium),
                if (step.table != null) ...[
                  const SizedBox(height: 16),
                  _Table(table: step.table!),
                ],
                for (final author in step.authors) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.plumSoft,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.plum.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.plumText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(author.text, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
                if (step.origin != null) ...[
                  const SizedBox(height: 12),
                  InfoBoxView(box: step.origin!, color: AppColors.navy),
                ],
                if (step.tip != null) ...[
                  const SizedBox(height: 12),
                  InfoBoxView(box: step.tip!, color: AppColors.goldText),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.table});

  final ComparisonTable table;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            color: AppColors.navy,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 92),
                Expanded(
                  child: Text(
                    table.leftTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    table.rightTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < table.rows.length; i++)
            Container(
              color: i.isEven ? Colors.white : AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 92,
                    child: Text(
                      table.rows[i].label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      table.rows[i].left,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      table.rows[i].right,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
