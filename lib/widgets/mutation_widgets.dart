import 'package:flutter/material.dart';

import '../models/content.dart';
import '../models/mutation.dart';
import '../theme/app_theme.dart';

/// Cartão branco padrão das telas do OVA de mutação.
class MutationPanel extends StatelessWidget {
  const MutationPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor ?? AppColors.line, width: 1.2),
      ),
      child: child,
    );
  }
}

/// Rótulo pequeno em caixa alta.
class MutationKicker extends StatelessWidget {
  const MutationKicker(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        letterSpacing: 1.5,
        fontWeight: FontWeight.w800,
        color: color ?? AppColors.goldText,
      ),
    );
  }
}

/// Título de seção com filete dourado.
class MutationSectionTitle extends StatelessWidget {
  const MutationSectionTitle(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleMedium),
        ),
        ?trailing,
      ],
    );
  }
}

/// Cartão expansível para autores, meios e limites.
class MutationExpandableCard extends StatefulWidget {
  const MutationExpandableCard({
    super.key,
    required this.card,
    this.accent = AppColors.gold,
    this.index,
  });

  final MutationCard card;
  final Color accent;
  final int? index;

  @override
  State<MutationExpandableCard> createState() => _MutationExpandableCardState();
}

class _MutationExpandableCardState extends State<MutationExpandableCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: _open ? widget.accent.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.accent.withValues(alpha: _open ? 0.65 : 0.28),
          width: 1.2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _open = !_open),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.index != null) ...[
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        '${widget.index}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: widget.accent,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                  ],
                  Expanded(
                    child: Text(
                      widget.card.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  Icon(
                    _open
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: widget.accent,
                    size: 20,
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 180),
                crossFadeState: _open
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    widget.card.text,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quadro comparativo com 2 ou 3 colunas; rola na horizontal em telas
/// estreitas, sem esmagar o texto.
class MutationTableView extends StatelessWidget {
  const MutationTableView({super.key, required this.table});

  final MutationTable table;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = 170.0 * table.columns.length + 104;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 104),
                  for (final column in table.columns)
                    SizedBox(
                      width: 170,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          column,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            for (var i = 0; i < table.rows.length; i++)
              Container(
                color: i.isEven
                    ? Colors.white
                    : AppColors.surface.withValues(alpha: 0.8),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 104,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          table.rows[i].label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.goldText,
                          ),
                        ),
                      ),
                    ),
                    for (final cell in table.rows[i].cells)
                      SizedBox(
                        width: 170,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            cell,
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            Container(height: 1, color: AppColors.line),
          ],
        ),
      ),
    );
  }
}

/// Linha do tempo vertical compacta dos julgamentos.
class MutationTimelineView extends StatelessWidget {
  const MutationTimelineView({super.key, required this.timeline});

  final MutationTimeline timeline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MutationPanel(
      color: AppColors.goldSoft.withValues(alpha: 0.55),
      borderColor: AppColors.gold.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MutationKicker(timeline.title, color: AppColors.goldText),
          const SizedBox(height: 12),
          for (var i = 0; i < timeline.entries.length; i++)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 54,
                    child: Text(
                      timeline.entries[i].year,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.goldText,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(top: 3),
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (i < timeline.entries.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            color: AppColors.gold.withValues(alpha: 0.4),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timeline.entries[i].judgment,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeline.entries[i].description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
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

/// Caixa de destaque com a mesma linguagem dos feedbacks.
class MutationInfoBox extends StatelessWidget {
  const MutationInfoBox({
    super.key,
    required this.box,
    this.color = AppColors.teal,
    this.icon = Icons.lightbulb_outline_rounded,
  });

  final InfoBox box;
  final Color color;
  final IconData icon;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (box.title != null) ...[
                  Text(
                    box.title!,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                if (box.text != null)
                  Text(box.text!, style: theme.textTheme.bodyMedium),
                if (box.bullets.isNotEmpty) ...[
                  if (box.text != null) const SizedBox(height: 8),
                  for (final bullet in box.bullets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '•',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              bullet,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Botão principal do OVA.
class MutationPrimaryButton extends StatelessWidget {
  const MutationPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
    this.enabled = true,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool enabled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled && !loading ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading) ...[
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (!loading) ...[const SizedBox(width: 8), Icon(icon, size: 19)],
        ],
      ),
    );
  }
}
