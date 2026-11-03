import 'package:flutter/material.dart';

import '../data/training_dialogue.dart';
import '../models/mutation.dart';
import '../theme/app_theme.dart';
import '../utils/personalize.dart';
import '../widgets/mentor_avatar.dart';

/// Fase de treinamento em estilo visual novel.
///
/// Cada toque na cena avança uma fala. Ao fim das falas, aparece o resumo do
/// ato e o botão para seguir. O botão "voltar" permite reler a fala anterior.
class TrainingStepView extends StatefulWidget {
  const TrainingStepView({
    super.key,
    required this.act,
    required this.userName,
    required this.actNumber,
    required this.actTotal,
    required this.onContinue,
  });

  final TrainingAct act;
  final String userName;
  final int actNumber;
  final int actTotal;
  final VoidCallback onContinue;

  @override
  State<TrainingStepView> createState() => _TrainingStepViewState();
}

class _TrainingStepViewState extends State<TrainingStepView> {
  int _index = 0;
  bool _summary = false;

  @override
  void didUpdateWidget(covariant TrainingStepView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.act.id != widget.act.id) {
      _index = 0;
      _summary = false;
    }
  }

  void _advance() {
    if (_summary) return;
    if (_index < widget.act.lines.length - 1) {
      setState(() => _index++);
    } else {
      setState(() => _summary = true);
    }
  }

  void _back() {
    if (_summary) {
      setState(() => _summary = false);
    } else if (_index > 0) {
      setState(() => _index--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _summary ? _buildSummary(context) : _buildDialogue(context);
  }

  Widget _buildDialogue(BuildContext context) {
    final line = widget.act.lines[_index];
    final mentor = line.mentorId == null
        ? null
        : mutationMentorById(line.mentorId!);
    final narrator = mentor == null;
    final color = mentor == null ? AppColors.gold : mentorColor(mentor.id);
    final text = personalizeText(line.text, widget.userName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActHeader(
          act: widget.act,
          actNumber: widget.actNumber,
          actTotal: widget.actTotal,
          color: color,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _advance,
          behavior: HitTestBehavior.opaque,
          child: Container(
            constraints: const BoxConstraints(minHeight: 320),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.navy, Color(0xFF0C2230)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.45)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  top: -40,
                  child: Icon(
                    Icons.account_balance_rounded,
                    size: 190,
                    color: Colors.white.withValues(alpha: 0.035),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StageTopBar(
                      index: _index,
                      total: widget.act.lines.length,
                      color: color,
                      summary: false,
                    ),
                    const SizedBox(height: 16),
                    if (narrator)
                      _NarrationBubble(text: text)
                    else
                      _MentorBubble(
                        mentor: mentor,
                        text: text,
                        emphasis: line.emphasis,
                        color: color,
                      ),
                    const SizedBox(height: 16),
                    _StageFooter(
                      index: _index,
                      total: widget.act.lines.length,
                      onBack: _index > 0 ? _back : null,
                      onNext: _advance,
                      color: color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final hint = Row(
              children: [
                const Icon(
                  Icons.touch_app_outlined,
                  size: 15,
                  color: AppColors.ink,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Toque na cena para avançar a conversa',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.ink.withValues(alpha: 0.6)),
                  ),
                ),
              ],
            );
            final buttons = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  onPressed: _index > 0 ? _back : null,
                  style: TextButton.styleFrom(minimumSize: const Size(0, 40)),
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const Text('Fala anterior'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _advance,
                  style: FilledButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 44),
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: Text(
                    _index == widget.act.lines.length - 1
                        ? 'Ver resumo'
                        : 'Próxima fala',
                  ),
                ),
              ],
            );
            if (constraints.maxWidth < 620) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [hint, const SizedBox(height: 8), buttons],
              );
            }
            return Row(
              children: [
                Expanded(child: hint),
                const SizedBox(width: 12),
                buttons,
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActHeader(
          act: widget.act,
          actNumber: widget.actNumber,
          actTotal: widget.actTotal,
          color: AppColors.gold,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.tealSoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.tealText,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumo do treinamento',
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.3,
                            fontWeight: FontWeight.w800,
                            color: AppColors.tealText,
                          ),
                        ),
                        Text(
                          widget.act.summaryTitle,
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _back,
                    style: TextButton.styleFrom(minimumSize: const Size(0, 40)),
                    icon: const Icon(Icons.replay_rounded, size: 17),
                    label: const Text('Rever falas'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < widget.act.summaryBullets.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.goldSoft,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.goldText,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          personalizeText(
                            widget.act.summaryBullets[i],
                            widget.userName,
                          ),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                'Guarde este resumo. Ele será a régua para classificar os '
                'próximos casos.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.ink.withValues(alpha: 0.58),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Rever o diálogo'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: widget.onContinue,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                label: Text(widget.act.nextLabel),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActHeader extends StatelessWidget {
  const _ActHeader({
    required this.act,
    required this.actNumber,
    required this.actTotal,
    required this.color,
  });

  final TrainingAct act;
  final int actNumber;
  final int actTotal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${act.number} · $actNumber/$actTotal',
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  act.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  act.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.ink.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < actTotal; i++)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: i < actNumber ? color : AppColors.line,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StageTopBar extends StatelessWidget {
  const _StageTopBar({
    required this.index,
    required this.total,
    required this.color,
    required this.summary,
  });

  final int index;
  final int total;
  final Color color;
  final bool summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.groups_2_outlined, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          summary ? 'Resumo' : 'Treinamento com os mentores',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        if (!summary)
          Text(
            'Fala ${index + 1} de $total',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.62),
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _MentorBubble extends StatelessWidget {
  const _MentorBubble({
    required this.mentor,
    required this.text,
    required this.emphasis,
    required this.color,
  });

  final MentorProfile mentor;
  final String text;
  final String? emphasis;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 660;
        final avatar = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MentorAvatar(mentor: mentor, radius: wide ? 36 : 26),
            const SizedBox(height: 8),
            Text(
              mentor.name,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              mentor.role,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ],
        );

        final bubble = Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      '${mentor.name} · ${mentor.trait}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  fontSize: 15,
                ),
              ),
              if (emphasis != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    emphasis!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [avatar, const SizedBox(height: 10), bubble],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 128, child: avatar),
            const SizedBox(width: 14),
            Expanded(child: bubble),
          ],
        );
      },
    );
  }
}

class _NarrationBubble extends StatelessWidget {
  const _NarrationBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_stories_outlined,
                size: 16,
                color: AppColors.gold,
              ),
              const SizedBox(width: 7),
              Text(
                'NARRAÇÃO',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.55,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _StageFooter extends StatelessWidget {
  const _StageFooter({
    required this.index,
    required this.total,
    required this.onBack,
    required this.onNext,
    required this.color,
  });

  final int index;
  final int total;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          tooltip: 'Fala anterior',
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white.withValues(alpha: 0.25),
          ),
          icon: const Icon(Icons.arrow_back_rounded, size: 19),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (index + 1) / total,
              minHeight: 6,
              color: color,
              backgroundColor: Colors.white.withValues(alpha: 0.14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: onNext,
          tooltip: 'Próxima fala',
          style: IconButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.arrow_forward_rounded, size: 19),
        ),
      ],
    );
  }
}
