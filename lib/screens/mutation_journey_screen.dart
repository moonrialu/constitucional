import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mutation_content.dart';
import '../engine/mutation_controller.dart';
import '../models/mutation.dart';
import '../theme/app_theme.dart';
import '../widgets/game_dialog.dart';
import 'mutation_steps.dart';

/// Casca das 16 telas: barra de progresso, navegação e transições.
class MutationJourneyScreen extends StatefulWidget {
  const MutationJourneyScreen({super.key, this.startFresh = false});

  /// Quando verdadeiro, começa a jornada do zero antes de abrir.
  final bool startFresh;

  @override
  State<MutationJourneyScreen> createState() => _MutationJourneyScreenState();
}

class _MutationJourneyScreenState extends State<MutationJourneyScreen> {
  final ScrollController _scroll = ScrollController();
  String? _lastStepId;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _started) return;
      _started = true;
      final controller = context.read<MutationController>();
      if (widget.startFresh || controller.isAtStart) {
        await controller.startJourney();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MutationController>();
    final step = controller.currentStep;
    final theme = Theme.of(context);

    if (_lastStepId != step.id) {
      _lastStepId = step.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) _scroll.jumpTo(0);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(controller: controller),
            Container(height: 1, color: AppColors.line),
            Expanded(
              child: SingleChildScrollView(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final offset = Tween<Offset>(
                          begin: const Offset(0.02, 0.015),
                          end: Offset.zero,
                        ).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offset,
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey(step.id),
                        child: _stepContent(controller, step, theme),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (controller.isFinished &&
                step.kind != MutationStepKind.diagnosis &&
                step.kind != MutationStepKind.credits)
              _FinishedBar(onDiagnosis: () => controller.goToStep('diagnosis')),
          ],
        ),
      ),
    );
  }

  Widget _stepContent(
    MutationController controller,
    MutationStep step,
    ThemeData theme,
  ) {
    switch (step.kind) {
      case MutationStepKind.cover:
        return MutationCoverStep(onStart: controller.startJourney);
      case MutationStepKind.objectives:
        return MutationObjectivesStep(onStart: controller.next);
      case MutationStepKind.caseStudy:
        final caseStudy = mutationCaseById(step.caseId ?? '');
        if (caseStudy == null) return const _MissingStep();
        return MutationCaseStep(caseStudy: caseStudy);
      case MutationStepKind.caseFeedback:
        final caseStudy = mutationCaseById(step.caseId ?? '');
        if (caseStudy == null) return const _MissingStep();
        return MutationCaseFeedbackStep(caseStudy: caseStudy);
      case MutationStepKind.theory:
        final theory = mutationTheoryById(step.caseId ?? '');
        if (theory == null) return const _MissingStep();
        return MutationTheoryStepView(theory: theory);
      case MutationStepKind.check:
        return const MutationCheckStepView(check: mutationCheck);
      case MutationStepKind.checkFeedback:
        return const MutationCheckFeedbackStep(check: mutationCheck);
      case MutationStepKind.quiz:
        return const MutationQuizStepView();
      case MutationStepKind.diagnosis:
        return MutationDiagnosisStepView(
          onRestart: () => _confirmRestart(context, controller),
          onCredits: controller.next,
        );
      case MutationStepKind.credits:
        return MutationCreditsStepView(
          onRestart: () => _confirmRestart(context, controller),
          onClose: () => Navigator.of(context).maybePop(),
        );
    }
  }

  Future<void> _confirmRestart(
    BuildContext context,
    MutationController controller,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => GameDialog(
        icon: Icons.restart_alt_rounded,
        title: 'Refazer a jornada?',
        message:
            'As respostas dos casos e do teste final serão apagadas. O '
            'conteúdo continua disponível para uma nova tentativa.',
        secondaryLabel: 'Cancelar',
        onSecondary: () => Navigator.of(context).pop(false),
        primaryLabel: 'Refazer',
        onPrimary: () => Navigator.of(context).pop(true),
      ),
    );
    if (confirmed == true) {
      await controller.restart();
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller});

  final MutationController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final step = controller.currentStep;
    final label = _labelFor(step);
    final canGoBack = controller.stepIndex > 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 10, 9),
      color: Colors.white,
      child: Row(
        children: [
          _RoundIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: canGoBack ? 'Tela anterior' : 'Voltar à capa',
            onTap: canGoBack
                ? controller.previous
                : () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'MUTAÇÃO CONSTITUCIONAL',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w900,
                        color: AppColors.goldText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.stepNumber.toString().padLeft(2, '0')} / '
                      '${controller.stepCount}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.ink.withValues(alpha: 0.45),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(controller.progress * 100).round()}% da jornada',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.ink.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: controller.progress,
                    minHeight: 6,
                    color: AppColors.teal,
                    backgroundColor: AppColors.line,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _RoundIconButton(
            icon: Icons.close_rounded,
            tooltip: 'Fechar a jornada',
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }

  String _labelFor(MutationStep step) {
    switch (step.id) {
      case 'cover':
        return 'Capa · o gabinete está aberto';
      case 'objectives':
        return 'Objetivos e como funciona';
      case 'case1':
        return 'Caso 1 · entre o homem e a mulher';
      case 'case1-feedback':
        return 'Feedback do Caso 1';
      case 'theory1':
        return 'Teoria · texto não é norma';
      case 'theory2':
        return 'Teoria · mutação, reforma e interpretação';
      case 'check2':
        return 'Caso 2 · a triagem do gabinete';
      case 'check2-feedback':
        return 'Feedback da triagem';
      case 'case3':
        return 'Caso 3 · o papel do Senado';
      case 'case3-feedback':
        return 'Feedback do Caso 3';
      case 'theory3':
        return 'Teoria · os limites da mutação';
      case 'case4':
        return 'Caso 4 · o voto secreto reinterpretado';
      case 'case4-feedback':
        return 'Feedback do Caso 4';
      case 'quiz':
        return 'Teste final · 5 questões';
      case 'diagnosis':
        return 'Diagnóstico do gabinete';
      case 'credits':
        return 'Créditos, referências e transparência';
      default:
        return step.id;
    }
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 38,
            height: 38,
            child: Icon(icon, size: 20, color: AppColors.navy),
          ),
        ),
      ),
    );
  }
}

class _FinishedBar extends StatelessWidget {
  const _FinishedBar({required this.onDiagnosis});

  final VoidCallback onDiagnosis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.navy,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.assignment_turned_in_outlined,
            color: AppColors.gold,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sua jornada já foi concluída. Você pode revisar o conteúdo ou '
              'voltar ao diagnóstico.',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
            ),
          ),
          TextButton(
            onPressed: onDiagnosis,
            style: TextButton.styleFrom(foregroundColor: AppColors.gold),
            child: const Text('Ir ao diagnóstico'),
          ),
        ],
      ),
    );
  }
}

class _MissingStep extends StatelessWidget {
  const _MissingStep();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text('Conteúdo não encontrado.'),
    );
  }
}
