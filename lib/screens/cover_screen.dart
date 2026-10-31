import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/battles.dart';
import '../engine/game_controller.dart';
import '../engine/mutation_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/game_dialog.dart';
import 'battle_screen.dart';
import 'mutation_journey_screen.dart';

/// Tela inicial do jogo: balança da justiça ao fundo, nome do jogo no canto
/// superior esquerdo e menu (Iniciar, Continuar, Ajudar, Sair).
class CoverScreen extends StatelessWidget {
  const CoverScreen({super.key, this.onEnterGame});

  /// Chamado quando o jogador sai da tela inicial (iniciar ou continuar).
  final VoidCallback? onEnterGame;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final mutation = context.watch<MutationController>();
    final hasProgress = controller.hasAnswers;
    final hasBattleJourney = controller.currentStepId != 'cover' || hasProgress;
    final hasJourney = mutation.hasProgress || hasBattleJourney;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navy, Color(0xFF0B2130)],
          ),
        ),
        // A capa também ocupa a tela inteira, até a borda superior.
        child: LayoutBuilder(
          builder: (context, constraints) {
            final short = constraints.maxHeight < 400;
            // `StackFit.expand` garante que o fundo ocupe a tela inteira;
            // sem isso o Stack encolhe para a largura do menu.
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  right: -constraints.maxWidth * 0.06,
                  top: -constraints.maxHeight * 0.18,
                  bottom: -constraints.maxHeight * 0.18,
                  width: constraints.maxWidth * 0.52,
                  child: const IgnorePointer(
                    child: CustomPaint(painter: _ScalesPainter()),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.navy.withValues(alpha: 0.92),
                          AppColors.navy.withValues(alpha: 0.65),
                          AppColors.navy.withValues(alpha: 0.1),
                        ],
                        stops: const [0.0, 0.52, 1.0],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _Title(short: short),
                      const SizedBox(height: 10),
                      if (hasJourney) ...[
                        _JourneyLine(
                          controller: controller,
                          mutation: mutation,
                        ),
                        const SizedBox(height: 8),
                      ],
                      const Spacer(),
                      _Menu(
                        compact: short,
                        canContinue: hasJourney,
                        onStart: () =>
                            _openMutation(context, mutation, startFresh: true),
                        onContinue: () =>
                            _continue(context, controller, mutation),
                        onCards: () => _startBattles(context, controller),
                        onExit: () => SystemNavigator.pop(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '4 processos · 11 interações · 13 a 15 minutos',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 0.6,
                          color: Colors.white.withValues(alpha: 0.55),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openMutation(
    BuildContext context,
    MutationController mutation, {
    required bool startFresh,
  }) async {
    if (startFresh && mutation.hasProgress) {
      final restart = await showDialog<bool>(
        context: context,
        builder: (context) => GameDialog(
          icon: Icons.restart_alt_rounded,
          title: 'Começar a jornada do zero?',
          message:
              'As respostas dos casos e do teste final serão apagadas. As '
              'referências e os créditos continuam disponíveis.',
          secondaryLabel: 'Cancelar',
          onSecondary: () => Navigator.of(context).pop(false),
          primaryLabel: 'Começar de novo',
          onPrimary: () => Navigator.of(context).pop(true),
        ),
      );
      if (restart != true || !context.mounted) return;
    }
    if (!context.mounted) return;
    if (startFresh) await mutation.startJourney();
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MutationJourneyScreen(startFresh: false),
      ),
    );
  }

  Future<void> _continue(
    BuildContext context,
    GameController controller,
    MutationController mutation,
  ) async {
    if (mutation.hasProgress) {
      await _openMutation(context, mutation, startFresh: false);
      return;
    }
    if (controller.hasAnswers || controller.currentStepId != 'cover') {
      await controller.continueJourney();
      onEnterGame?.call();
      return;
    }
    await _openMutation(context, mutation, startFresh: true);
  }

  Future<void> _startBattles(
    BuildContext context,
    GameController controller,
  ) async {
    final entered = onEnterGame;
    final hasJourney =
        controller.hasAnswers || controller.currentStepId != 'cover';
    if (hasJourney) {
      final restart = await showDialog<bool>(
        context: context,
        builder: (context) => GameDialog(
          icon: Icons.restart_alt_rounded,
          title: 'Começar uma nova jornada de cartas?',
          message:
              'As batalhas, cartas e medalhas já conquistadas continuam no '
              'gabarito, mas as respostas e o teste final recomeçam.',
          secondaryLabel: 'Cancelar',
          onSecondary: () => Navigator.of(context).pop(false),
          primaryLabel: 'Recomeçar',
          onPrimary: () => Navigator.of(context).pop(true),
        ),
      );
      if (restart != true || !context.mounted) return;
      await controller.restart();
    } else {
      await controller.beginJourney();
    }
    if (!context.mounted) return;

    // Pergunta o tutorial antes de sair da capa. Assim o tutorial abre por
    // cima da capa e, ao terminar, a jornada entra direto na batalha 1.
    final tutorial = await showDialog<bool>(
      context: context,
      builder: (context) => GameDialog(
        icon: Icons.smart_toy_outlined,
        title: 'Quer ver o tutorial?',
        message:
            'O Guia faz uma partida de exemplo: mostra como levantar a carta, '
            'jogar com duplo toque e montar um conjunto de resposta.',
        secondaryLabel: 'Jogar direto',
        onSecondary: () => Navigator.of(context).pop(false),
        primaryLabel: 'Ver tutorial',
        onPrimary: () => Navigator.of(context).pop(true),
      ),
    );
    if (!context.mounted) return;

    if (tutorial == true) {
      await _openTutorial(context);
      if (!context.mounted) return;
    }
    entered?.call();
  }

  Future<void> _openTutorial(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BattleScreen(
          config: tutorialBattle(battleConfigs.first),
          guide: true,
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.short});

  final bool short;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'DIREITO CONSTITUCIONAL I · OVA 2.0',
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w800,
            color: AppColors.gold.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Assessora do STF',
          style: TextStyle(
            fontSize: short ? 30 : 38,
            height: 1,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.6,
          ),
        ),
        Text(
          'por um dia',
          style: TextStyle(
            fontSize: short ? 22 : 28,
            height: 1.05,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'MUTAÇÃO CONSTITUCIONAL · EXPLICAÇÃO + PRÁTICA',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 2.4,
            fontWeight: FontWeight.w800,
            color: AppColors.teal.withValues(alpha: 0.95),
          ),
        ),
      ],
    );
  }
}

class _JourneyLine extends StatelessWidget {
  const _JourneyLine({required this.controller, required this.mutation});

  final GameController controller;
  final MutationController mutation;

  @override
  Widget build(BuildContext context) {
    final text = mutation.hasProgress
        ? 'Tela ${mutation.stepNumber}/${mutation.stepCount} · '
              '${mutation.quizCorrect}/${mutation.quizTotal} no teste final'
        : '${controller.battlesWon}/${controller.battleTotal} batalhas · '
              '${controller.unlockedCardCount} cartas · '
              '${controller.earnedBadges.length} medalhas';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.bookmark_outline,
          size: 13,
          color: Colors.white.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({
    required this.compact,
    required this.canContinue,
    required this.onStart,
    required this.onContinue,
    required this.onCards,
    required this.onExit,
  });

  final bool compact;
  final bool canContinue;
  final VoidCallback onStart;
  final VoidCallback onContinue;
  final VoidCallback onCards;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 330),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MenuItem(
            icon: Icons.play_arrow_rounded,
            label: 'Iniciar jornada',
            hint: 'explicação e prática',
            primary: true,
            compact: compact,
            onTap: onStart,
          ),
          _MenuItem(
            icon: Icons.history_rounded,
            label: 'Continuar',
            hint: canContinue ? 'retomar de onde parou' : 'sem jornada salva',
            compact: compact,
            enabled: canContinue,
            onTap: onContinue,
          ),
          _MenuItem(
            icon: Icons.style_outlined,
            label: 'Baralho de argumentos',
            hint: 'modo cartas (extra)',
            compact: compact,
            onTap: onCards,
          ),
          _MenuItem(
            icon: Icons.logout_rounded,
            label: 'Sair',
            hint: 'fechar o jogo',
            compact: compact,
            onTap: onExit,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.hint,
    required this.compact,
    required this.onTap,
    this.primary = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final String hint;
  final bool compact;
  final VoidCallback onTap;
  final bool primary;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final foreground = primary
        ? AppColors.navy
        : Colors.white.withValues(alpha: enabled ? 0.95 : 0.4);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: primary
            ? AppColors.gold
            : Colors.white.withValues(alpha: enabled ? 0.09 : 0.04),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: compact ? 40 : 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: primary
                    ? AppColors.gold
                    : Colors.white.withValues(alpha: enabled ? 0.14 : 0.06),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 19, color: foreground),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: compact ? 13 : 14,
                    fontWeight: FontWeight.w800,
                    color: foreground,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 9,
                      color: primary
                          ? AppColors.navy.withValues(alpha: 0.65)
                          : Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: primary
                      ? AppColors.navy.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.35),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Balança da justiça desenhada ao fundo, em traço dourado.
class _ScalesPainter extends CustomPainter {
  const _ScalesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.58;
    final top = h * 0.2;
    final base = h * 0.82;
    final beamY = top + h * 0.1;
    final beamHalf = w * 0.31;
    final panDrop = h * 0.17;
    final stroke = w * 0.012;

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = AppColors.gold.withValues(alpha: 0.22);

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * 2.4
      ..strokeCap = StrokeCap.round
      ..color = AppColors.gold.withValues(alpha: 0.06);

    void both(void Function(Paint paint) draw) {
      draw(glow);
      draw(line);
    }

    // Coluna central e base.
    both((paint) {
      canvas.drawLine(Offset(cx, beamY), Offset(cx, base), paint);
    });
    both((paint) {
      canvas.drawLine(
        Offset(cx - w * 0.09, base),
        Offset(cx + w * 0.09, base),
        paint,
      );
    });
    both((paint) {
      canvas.drawLine(
        Offset(cx - w * 0.05, base + h * 0.018),
        Offset(cx + w * 0.05, base + h * 0.018),
        paint,
      );
    });

    // Pivô e travessa.
    both((paint) {
      canvas.drawCircle(Offset(cx, beamY), stroke * 2.2, paint);
    });
    both((paint) {
      canvas.drawLine(
        Offset(cx - beamHalf, beamY),
        Offset(cx + beamHalf, beamY),
        paint,
      );
    });
    both((paint) {
      canvas.drawCircle(Offset(cx, beamY), stroke * 0.7, paint);
    });

    // Pratos suspensos por três correntes.
    for (final side in [-1.0, 1.0]) {
      final panCenter = Offset(cx + side * beamHalf, beamY + panDrop);
      final panWidth = w * 0.13;
      for (final t in [-0.85, 0.0, 0.85]) {
        both((paint) {
          canvas.drawLine(
            Offset(cx + side * beamHalf, beamY),
            Offset(
              panCenter.dx + t * panWidth * 0.55,
              panCenter.dy - h * 0.012,
            ),
            paint,
          );
        });
      }
      both((paint) {
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(panCenter.dx, panCenter.dy + h * 0.012),
            width: panWidth,
            height: h * 0.075,
          ),
          0.15,
          3.14159 - 0.3,
          false,
          paint,
        );
      });
      both((paint) {
        canvas.drawLine(
          Offset(panCenter.dx - panWidth / 2, panCenter.dy + h * 0.012),
          Offset(panCenter.dx + panWidth / 2, panCenter.dy + h * 0.012),
          paint,
        );
      });
    }
  }

  @override
  bool shouldRepaint(covariant _ScalesPainter oldDelegate) => false;
}
