import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mutation_content.dart';
import '../data/training_dialogue.dart';
import '../engine/mutation_controller.dart';
import '../models/content.dart';
import '../models/mutation.dart';
import '../theme/app_theme.dart';
import '../widgets/mutation_widgets.dart';
import '../widgets/option_card.dart';

const Color _gold = AppColors.gold;

/// Tela 1 — capa interna do OVA.
class MutationCoverStep extends StatelessWidget {
  const MutationCoverStep({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MutationPanel(
      padding: const EdgeInsets.all(0),
      borderColor: _gold.withValues(alpha: 0.4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.navy, Color(0xFF0B2130)],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(28, 26, 28, 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 760;
              final text = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MutationKicker(
                    'OVA 2 · Mutação constitucional',
                    color: AppColors.gold,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'A Constituição muda\nsem mudar uma palavra?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: wide ? 38 : 30,
                      height: 1.08,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Text(
                      mutationCoverLead,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.84),
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _CoverChip(
                        icon: Icons.schedule_rounded,
                        label: '13 a 15 minutos',
                      ),
                      _CoverChip(
                        icon: Icons.gavel_rounded,
                        label: '4 processos',
                      ),
                      _CoverChip(
                        icon: Icons.touch_app_rounded,
                        label: '11 interações',
                      ),
                    ],
                  ),
                ],
              );

              final action = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.account_balance_rounded,
                          color: AppColors.gold,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Seu gabinete está aberto.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Quatro processos, uma pergunta: até onde a '
                          'interpretação pode ir?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.72),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: onStart,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.navy,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('Assumir o gabinete'),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [text, const SizedBox(height: 20), action],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 7, child: text),
                  const SizedBox(width: 28),
                  Expanded(flex: 4, child: action),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CoverChip extends StatelessWidget {
  const _CoverChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.gold),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tela 2 — objetivos e como funciona.
class MutationObjectivesStep extends StatelessWidget {
  const MutationObjectivesStep({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MutationPanel(
          color: AppColors.tealSoft.withValues(alpha: 0.42),
          borderColor: AppColors.teal.withValues(alpha: 0.32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.account_balance_rounded,
                color: AppColors.tealText,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MutationKicker(
                      'Você assumiu o gabinete',
                      color: AppColors.tealText,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      mutationCoverLead,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 820;
            final objectives = MutationPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MutationKicker('Ao final, você será capaz de'),
                  const SizedBox(height: 12),
                  for (var i = 0; i < mutationObjectives.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.tealSoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${i + 1}',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.tealText,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              mutationObjectives[i],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );

            final howTo = MutationPanel(
              color: AppColors.goldSoft.withValues(alpha: 0.55),
              borderColor: _gold.withValues(alpha: 0.35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MutationKicker(
                    'Como funciona',
                    color: AppColors.goldText,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mutationHowToPlay,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  MutationInfoBox(
                    box: const InfoBox(
                      title: 'A ordem importa',
                      text:
                          'Primeiro a explicação: casos e teoria. Depois a '
                          'fixação: classificação, teste final e diagnóstico.',
                    ),
                    color: _gold,
                    icon: Icons.route_rounded,
                  ),
                  const SizedBox(height: 16),
                  MutationPrimaryButton(
                    label: 'Abrir o primeiro processo',
                    onPressed: onStart,
                  ),
                ],
              ),
            );

            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [objectives, const SizedBox(height: 16), howTo],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: objectives),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: howTo),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Telas 3, 9 e 12 — casos com alternativas.
class MutationCaseStep extends StatefulWidget {
  const MutationCaseStep({super.key, required this.caseStudy});

  final MutationCase caseStudy;

  @override
  State<MutationCaseStep> createState() => _MutationCaseStepState();
}

class _MutationCaseStepState extends State<MutationCaseStep> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<MutationController>().caseAnswer(
      widget.caseStudy.id,
    );
  }

  Future<void> _confirm() async {
    final choice = _selected;
    if (choice == null) return;
    final controller = context.read<MutationController>();
    await controller.answerCase(caseId: widget.caseStudy.id, choiceId: choice);
    if (!mounted) return;
    await controller.next();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<MutationController>();
    final answered = controller.isCaseAnswered(widget.caseStudy.id);

    final body = MutationPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MutationKicker(widget.caseStudy.number),
          const SizedBox(height: 8),
          Text(
            widget.caseStudy.title,
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
          ),
          if (widget.caseStudy.disclaimer != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.caseStudy.disclaimer!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.crimsonText,
              ),
            ),
          ],
          const SizedBox(height: 14),
          for (final paragraph in widget.caseStudy.body.split('\n\n'))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                paragraph,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
              ),
            ),
          const SizedBox(height: 6),
          MutationInfoBox(
            box: InfoBox(
              title: 'Pergunta do ministro a ${controller.displayName}',
              text: widget.caseStudy.question,
            ),
            color: AppColors.teal,
            icon: Icons.help_outline_rounded,
          ),
        ],
      ),
    );

    final options = MutationPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MutationKicker('Escolha uma resposta'),
          const SizedBox(height: 12),
          for (final choice in widget.caseStudy.choices)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OptionCard(
                letter: choice.id,
                text: choice.text,
                state: _stateFor(choice, answered),
                accent: AppColors.teal,
                onTap: answered
                    ? null
                    : () => setState(() => _selected = choice.id),
              ),
            ),
          const SizedBox(height: 6),
          MutationPrimaryButton(
            label: answered ? 'Ver o feedback' : 'Confirmar resposta',
            enabled: _selected != null,
            onPressed: answered
                ? () => context.read<MutationController>().next()
                : _confirm,
            icon: answered ? Icons.arrow_forward_rounded : Icons.check_rounded,
          ),
          if (!answered && _selected != null) ...[
            const SizedBox(height: 8),
            Text(
              'Você pode trocar a alternativa antes de confirmar.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.ink.withValues(alpha: 0.55),
              ),
            ),
          ],
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 860) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [body, const SizedBox(height: 16), options],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: body),
            const SizedBox(width: 16),
            Expanded(flex: 4, child: options),
          ],
        );
      },
    );
  }

  OptionState _stateFor(MutationChoice choice, bool answered) {
    if (!answered) {
      return _selected == choice.id ? OptionState.selected : OptionState.idle;
    }
    if (choice.correct) return OptionState.correct;
    if (_selected == choice.id) return OptionState.wrong;
    return OptionState.idle;
  }
}

/// Telas 4, 10 e 13 — feedback do caso.
class MutationCaseFeedbackStep extends StatelessWidget {
  const MutationCaseFeedbackStep({super.key, required this.caseStudy});

  final MutationCase caseStudy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<MutationController>();
    final answerId = controller.caseAnswer(caseStudy.id);
    final chosen = caseStudy.choiceById(answerId);
    final correct = caseStudy.correctChoice;

    if (chosen == null) {
      return MutationPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Falta responder o caso.', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Volte e escolha uma alternativa para receber o feedback.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            MutationPrimaryButton(
              label: 'Voltar ao caso',
              icon: Icons.arrow_back_rounded,
              onPressed: () => controller.previous(),
            ),
          ],
        ),
      );
    }

    final isCorrect = chosen.correct;
    final color = isCorrect ? AppColors.teal : AppColors.crimson;
    final soft = isCorrect ? AppColors.tealSoft : AppColors.crimsonSoft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MutationPanel(
          borderColor: color.withValues(alpha: 0.45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: soft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCorrect
                          ? Icons.check_rounded
                          : Icons.info_outline_rounded,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MutationKicker(
                          isCorrect
                              ? 'Escolha acertada · ${controller.displayName}'
                              : 'Escolha comentada · ${controller.displayName}',
                          color: color,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Alternativa ${chosen.id} · ${caseStudy.title}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: soft.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  chosen.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!isCorrect) ...[
                const SizedBox(height: 12),
                Text(
                  'Resposta correta: alternativa ${correct.id}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.tealText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(correct.text, style: theme.textTheme.bodyMedium),
              ],
              const SizedBox(height: 14),
              for (final paragraph in chosen.feedback)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    paragraph,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                  ),
                ),
            ],
          ),
        ),
        if (caseStudy.timeline != null) ...[
          const SizedBox(height: 16),
          MutationTimelineView(timeline: caseStudy.timeline!),
        ],
        if (caseStudy.reflection != null) ...[
          const SizedBox(height: 16),
          MutationInfoBox(
            box: caseStudy.reflection!,
            color: _gold,
            icon: Icons.forum_outlined,
          ),
        ],
        const SizedBox(height: 18),
        MutationPrimaryButton(
          label: caseStudy.nextLabel,
          onPressed: () => controller.next(),
        ),
      ],
    );
  }
}

/// Telas 5, 6 e 11 — teoria essencial.
class MutationTheoryStepView extends StatelessWidget {
  const MutationTheoryStepView({super.key, required this.theory});

  final MutationTheory theory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<MutationController>();

    final cards = <Widget>[
      for (var i = 0; i < theory.cards.length; i++)
        MutationExpandableCard(
          card: theory.cards[i],
          index: i + 1,
          accent: theory.id == 'theory3' ? AppColors.crimson : AppColors.gold,
        ),
      for (var i = 0; i < theory.authors.length; i++)
        MutationExpandableCard(
          card: MutationCard(
            title: theory.authors[i].name,
            text: theory.authors[i].text,
          ),
          accent: AppColors.teal,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MutationPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MutationKicker(theory.kicker),
              const SizedBox(height: 8),
              Text(
                theory.title,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 12),
              Text(
                theory.lead,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.55,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (theory.paragraphs.isNotEmpty) ...[
                const SizedBox(height: 12),
                for (final paragraph in theory.paragraphs)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      paragraph,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                    ),
                  ),
              ],
            ],
          ),
        ),
        if (theory.table != null) ...[
          const SizedBox(height: 16),
          MutationTableView(table: theory.table!),
        ],
        if (theory.concept != null) ...[
          const SizedBox(height: 16),
          MutationInfoBox(
            box: theory.concept!,
            color: AppColors.teal,
            icon: Icons.menu_book_rounded,
          ),
        ],
        if (cards.isNotEmpty) ...[
          const SizedBox(height: 18),
          MutationSectionTitle(
            theory.cardHeading ?? theory.authorHeading ?? 'Para aprofundar',
            trailing: Text(
              'toque nos cartões',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.ink.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 760 ? 2 : 1;
              if (columns == 1) {
                return Column(
                  children: [
                    for (final card in cards)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: card,
                      ),
                  ],
                );
              }
              final rows = <Widget>[];
              for (var i = 0; i < cards.length; i += 2) {
                rows.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: cards[i]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: i + 1 < cards.length
                              ? cards[i + 1]
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(children: rows);
            },
          ),
        ],
        if (theory.tip != null) ...[
          const SizedBox(height: 16),
          MutationInfoBox(
            box: theory.tip!,
            color: theory.id == 'theory3' ? AppColors.crimson : AppColors.gold,
            icon: Icons.tips_and_updates_outlined,
          ),
        ],
        const SizedBox(height: 18),
        MutationPrimaryButton(
          label: theory.nextLabel,
          onPressed: () => controller.next(),
        ),
      ],
    );
  }
}

/// Tela 7 — classificação das três situações.
class MutationCheckStepView extends StatelessWidget {
  const MutationCheckStepView({super.key, required this.check});

  final MutationCheck check;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<MutationController>();
    final complete = controller.isCheckComplete(check);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MutationPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MutationKicker(check.kicker),
              const SizedBox(height: 8),
              Text(
                check.title,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(check.lead, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _LegendPill(
                    label: 'Reforma',
                    color: AppColors.gold,
                    text: 'o texto muda',
                  ),
                  _LegendPill(
                    label: 'Mutação',
                    color: AppColors.teal,
                    text: 'sentido muda, texto igual',
                  ),
                  _LegendPill(
                    label: 'Mutação inconstitucional',
                    color: AppColors.crimson,
                    text: 'sentido contra o texto',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < check.items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CheckItemCard(
              index: i + 1,
              item: check.items[i],
              checkId: check.id,
              selected: controller.checkAnswer(check.id, check.items[i].id),
              onSelect: (optionId) => controller.answerCheck(
                checkId: check.id,
                itemId: check.items[i].id,
                optionId: optionId,
              ),
            ),
          ),
        if (check.note != null) ...[
          const SizedBox(height: 4),
          MutationInfoBox(
            box: check.note!,
            color: AppColors.teal,
            icon: Icons.filter_alt_outlined,
          ),
        ],
        const SizedBox(height: 18),
        MutationPrimaryButton(
          label: complete ? check.nextLabel : 'Responda as três situações',
          enabled: complete,
          onPressed: () => context.read<MutationController>().next(),
          icon: Icons.fact_check_outlined,
        ),
        if (complete) ...[
          const SizedBox(height: 6),
          TextButton.icon(
            onPressed: () =>
                context.read<MutationController>().clearCheckAnswers(check),
            icon: const Icon(Icons.restart_alt_rounded, size: 18),
            label: const Text('Refazer a triagem'),
          ),
        ],
      ],
    );
  }
}

class _LegendPill extends StatelessWidget {
  const _LegendPill({
    required this.label,
    required this.color,
    required this.text,
  });

  final String label;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label · ',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.ink.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckItemCard extends StatelessWidget {
  const _CheckItemCard({
    required this.index,
    required this.item,
    required this.checkId,
    required this.selected,
    required this.onSelect,
  });

  final int index;
  final MutationCheckItem item;
  final String checkId;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MutationPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$index',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.prompt,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in item.options)
                _CheckOptionPill(
                  option: option,
                  selected: selected == option.id,
                  onTap: () => onSelect(option.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckOptionPill extends StatelessWidget {
  const _CheckOptionPill({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final MutationCheckOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (option.id) {
      'R' => AppColors.gold,
      'M' => AppColors.teal,
      _ => AppColors.crimson,
    };
    return Material(
      color: selected ? color : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? color : color.withValues(alpha: 0.45),
              width: selected ? 1.6 : 1.2,
            ),
          ),
          child: Text(
            option.text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: selected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tela 8 — feedback da classificação.
class MutationCheckFeedbackStep extends StatelessWidget {
  const MutationCheckFeedbackStep({super.key, required this.check});

  final MutationCheck check;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<MutationController>();
    final correctCount = controller.checkCorrectCount(check);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MutationPanel(
          borderColor: AppColors.teal.withValues(alpha: 0.4),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.tealSoft,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$correctCount/${check.items.length}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.tealText,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MutationKicker(
                      'Feedback da triagem',
                      color: AppColors.tealText,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      correctCount == check.items.length
                          ? 'Triagem impecável. Você separou reforma, mutação e mutação inconstitucional.'
                          : 'Boa triagem. Confira abaixo o porquê de cada classificação.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < check.items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CheckFeedbackCard(
              index: i + 1,
              item: check.items[i],
              selected: controller.checkAnswer(check.id, check.items[i].id),
            ),
          ),
        if (check.note != null) ...[
          const SizedBox(height: 4),
          MutationInfoBox(box: check.note!, color: _gold),
        ],
        const SizedBox(height: 18),
        MutationPrimaryButton(
          label: 'Próximo processo',
          onPressed: () => controller.next(),
        ),
      ],
    );
  }
}

class _CheckFeedbackCard extends StatelessWidget {
  const _CheckFeedbackCard({
    required this.index,
    required this.item,
    required this.selected,
  });

  final int index;
  final MutationCheckItem item;
  final String? selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCorrect = selected == item.correct;
    final color = isCorrect ? AppColors.teal : AppColors.crimson;
    final selectedOption = item.optionById(selected);

    return MutationPanel(
      borderColor: color.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Situação $index',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
              Text(
                isCorrect ? 'acertou' : 'revisar',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.prompt,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _FeedbackPill(
                label: 'Você: ${selectedOption?.text ?? '—'}',
                color: color,
              ),
              _FeedbackPill(
                label: 'Correta: ${item.correctOption.text}',
                color: AppColors.teal,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(item.feedback, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _FeedbackPill extends StatelessWidget {
  const _FeedbackPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

/// Tela 14 — teste final com feedback imediato.
class MutationQuizStepView extends StatefulWidget {
  const MutationQuizStepView({super.key});

  @override
  State<MutationQuizStepView> createState() => _MutationQuizStepViewState();
}

class _MutationQuizStepViewState extends State<MutationQuizStepView> {
  int _current = 0;
  String? _selected;

  @override
  void initState() {
    super.initState();
    final controller = context.read<MutationController>();
    final firstOpen = mutationQuiz.indexWhere(
      (question) => !controller.isQuizAnswered(question.id),
    );
    _current = firstOpen < 0 ? mutationQuiz.length - 1 : firstOpen;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MutationController>();
    final question = mutationQuiz[_current];
    final answered = controller.isQuizAnswered(question.id);
    final answerId = controller.quizAnswer(question.id);
    final isCorrect = question.isCorrect(answerId);
    final theme = Theme.of(context);
    final isLast = _current == mutationQuiz.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MutationPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const MutationKicker('Teste final · feedback imediato'),
                  const Spacer(),
                  Text(
                    'Questão ${_current + 1} de ${mutationQuiz.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.ink.withValues(alpha: 0.55),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (var i = 0; i < mutationQuiz.length; i++) ...[
                    Expanded(
                      child: Container(
                        height: 5,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: controller.isQuizAnswered(mutationQuiz[i].id)
                              ? (mutationQuiz[i].isCorrect(
                                      controller.quizAnswer(mutationQuiz[i].id),
                                    )
                                    ? AppColors.teal
                                    : AppColors.crimson)
                              : AppColors.line,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              Text(
                question.statement,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 21),
              ),
              const SizedBox(height: 8),
              Text(
                '${controller.displayName}, antes de liberar você para o '
                'plenário, o ministro quer cinco respostas rápidas.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.ink.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (final choice in question.choices)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: OptionCard(
              letter: choice.id,
              text: choice.text,
              accent: AppColors.indigo,
              state: _optionState(choice.id, answered, answerId, question),
              onTap: answered
                  ? null
                  : () => setState(() => _selected = choice.id),
            ),
          ),
        if (answered) ...[
          const SizedBox(height: 4),
          MutationInfoBox(
            box: InfoBox(
              title: isCorrect ? 'Resposta correta' : 'Por que não é essa',
              text: question.feedback,
            ),
            color: isCorrect ? AppColors.teal : AppColors.crimson,
            icon: isCorrect
                ? Icons.check_circle_outline
                : Icons.info_outline_rounded,
          ),
          const SizedBox(height: 14),
          MutationPrimaryButton(
            label: isLast ? 'Ver diagnóstico' : 'Próxima questão',
            onPressed: () async {
              if (isLast) {
                await controller.finishQuiz();
                return;
              }
              setState(() {
                _current++;
                _selected = null;
              });
            },
          ),
        ] else ...[
          const SizedBox(height: 4),
          MutationPrimaryButton(
            label: 'Confirmar resposta',
            enabled: _selected != null,
            icon: Icons.check_rounded,
            onPressed: () async {
              final choice = _selected;
              if (choice == null) return;
              await controller.answerQuiz(
                questionId: question.id,
                choiceId: choice,
              );
            },
          ),
        ],
      ],
    );
  }

  OptionState _optionState(
    String choiceId,
    bool answered,
    String? answerId,
    MutationQuizQuestion question,
  ) {
    if (!answered) {
      return _selected == choiceId ? OptionState.selected : OptionState.idle;
    }
    if (choiceId == question.correct) return OptionState.correct;
    if (choiceId == answerId) return OptionState.wrong;
    return OptionState.idle;
  }
}

/// Tela 15 — diagnóstico.
class MutationDiagnosisStepView extends StatelessWidget {
  const MutationDiagnosisStepView({
    super.key,
    required this.onRestart,
    required this.onCredits,
  });

  final VoidCallback onRestart;
  final VoidCallback onCredits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<MutationController>();
    final score = controller.quizCorrect;
    final band = controller.diagnosisBand;
    final perfect = score == controller.quizTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MutationPanel(
          color: perfect ? AppColors.tealSoft : AppColors.surface,
          borderColor: (perfect ? AppColors.teal : _gold).withValues(
            alpha: 0.45,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 700;
              final scoreWidget = Container(
                width: 118,
                height: 118,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: perfect ? AppColors.teal : AppColors.navy,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (perfect ? AppColors.teal : AppColors.navy)
                          .withValues(alpha: 0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$score',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 40,
                        height: 1,
                      ),
                    ),
                    Text(
                      'de ${controller.quizTotal}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MutationKicker(
                    'Diagnóstico do gabinete · ${controller.displayName}',
                  ),
                  const SizedBox(height: 6),
                  Text(
                    band.title,
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 25),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${controller.displayName}, você acertou $score de '
                    '${controller.quizTotal}. ${band.message}',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  MutationInfoBox(
                    box: InfoBox(
                      title: 'Recomendação do ministro',
                      text: band.recommendation,
                    ),
                    color: perfect ? AppColors.teal : _gold,
                    icon: Icons.assignment_turned_in_outlined,
                  ),
                ],
              );
              if (!wide) {
                return Column(
                  children: [scoreWidget, const SizedBox(height: 16), copy],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  scoreWidget,
                  const SizedBox(width: 22),
                  Expanded(child: copy),
                ],
              );
            },
          ),
        ),
        if (controller.wrongQuizQuestions.isNotEmpty) ...[
          const SizedBox(height: 16),
          MutationSectionTitle('Para revisar'),
          const SizedBox(height: 10),
          for (final question in controller.wrongQuizQuestions)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MutationPanel(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bookmark_border_rounded,
                      size: 19,
                      color: AppColors.crimson,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Questão ${question.number} — ${question.reviewLabel}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            question.statement,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.ink.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showReview(context, question),
                      child: const Text('Revisar'),
                    ),
                  ],
                ),
              ),
            ),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCredits,
                icon: const Icon(Icons.menu_book_outlined, size: 18),
                label: const Text('Créditos e referências'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onRestart,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                ),
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: const Text('Refazer a jornada'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showReview(BuildContext context, MutationQuizQuestion question) {
    final act = mutationTrainingById(question.reviewStepId);
    final theory = mutationTheoryById(question.reviewStepId);
    final caseStudy = mutationCaseById(
      question.reviewStepId.replaceAll('-feedback', ''),
    );
    final body = StringBuffer();
    if (act != null) {
      body
        ..writeln(act.summaryTitle)
        ..writeln();
      for (final bullet in act.summaryBullets) {
        body
          ..writeln('• $bullet')
          ..writeln();
      }
    } else if (theory != null) {
      body
        ..writeln(theory.lead)
        ..writeln();
      for (final paragraph in theory.paragraphs) {
        body
          ..writeln(paragraph)
          ..writeln();
      }
      if (theory.concept != null) {
        body
          ..writeln(theory.concept!.title ?? '')
          ..writeln(theory.concept!.text ?? '');
      }
    } else if (caseStudy != null) {
      body.writeln(caseStudy.body);
      body.writeln();
      body.writeln(caseStudy.correctChoice.feedback.join('\n\n'));
    } else {
      body.writeln(question.feedback);
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question.reviewLabel),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(child: Text(body.toString().trim())),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

/// Tela 16 — créditos, referências e transparência.
class MutationCreditsStepView extends StatelessWidget {
  const MutationCreditsStepView({
    super.key,
    required this.onRestart,
    required this.onClose,
  });

  final VoidCallback onRestart;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<MutationController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MutationPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MutationKicker('Créditos e transparência'),
              const SizedBox(height: 8),
              Text(
                'Mutação constitucional no gabinete do STF',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 6),
              Text(
                'Direito Constitucional I · Faculdade Baiana de Direito · '
                '2026.2',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.ink.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final member in mutationCreditsTeam)
                    Container(
                      width: 210,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            member.role,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.ink.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MutationPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MutationSectionTitle('Referências'),
              const SizedBox(height: 10),
              for (final reference in mutationReferences)
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('•'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          reference,
                          style: theme.textTheme.bodySmall?.copyWith(
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MutationPanel(
          color: AppColors.goldSoft.withValues(alpha: 0.5),
          borderColor: _gold.withValues(alpha: 0.35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MutationSectionTitle('Transparência'),
              const SizedBox(height: 8),
              Text(mutationTransparency, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: 18),
        MutationInfoBox(
          box: InfoBox(
            title: 'Sua jornada, ${controller.displayName}',
            text:
                'Tempo: ${_formatDuration(controller.elapsed)} · Teste final: '
                '${controller.quizCorrect}/${controller.quizTotal}. O progresso '
                'fica salvo neste aparelho.',
          ),
          color: AppColors.teal,
          icon: Icons.timer_outlined,
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: const Text('Refazer a jornada'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onClose,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                ),
                icon: const Icon(Icons.home_outlined, size: 18),
                label: const Text('Voltar à capa'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }
}
