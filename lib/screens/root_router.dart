import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/battles.dart';
import '../engine/game_controller.dart';
import '../engine/mutation_controller.dart';
import 'battle_screen.dart';
import 'cover_screen.dart';
import 'onboarding_screen.dart';

/// Decide qual tela mostrar a partir da etapa salva no progresso.
///
/// O app abre sempre na tela inicial; "Continuar" retoma a batalha salva.
/// As antigas etapas de teoria/check/quiz foram removidas e serão refeitas.
class RootRouter extends StatefulWidget {
  const RootRouter({super.key});

  @override
  State<RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<RootRouter> {
  bool _atStart = true;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final mutation = context.watch<MutationController>();
    if (!controller.ready || !mutation.ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // O nome é a porta de entrada: sem ele, o onboarding segura a jornada.
    // Como setUserName notifica os ouvintes, o router se reconstrói sozinho.
    if (!mutation.hasName) {
      return OnboardingScreen(onComplete: () {});
    }

    if (_atStart) {
      return CoverScreen(
        onEnterGame: () {
          if (mounted) setState(() => _atStart = false);
        },
      );
    }

    final step = controller.currentStepId;
    final battle = battleById(step);
    if (battle != null) return BattleScreen(config: battle);

    // Etapas antigas ou desconhecidas: volta à tela inicial.
    return CoverScreen(
      onEnterGame: () {
        if (mounted) setState(() => _atStart = false);
      },
    );
  }
}
