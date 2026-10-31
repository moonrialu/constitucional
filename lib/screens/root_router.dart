import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/battles.dart';
import '../engine/game_controller.dart';
import 'battle_screen.dart';
import 'cover_screen.dart';

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
    if (!controller.ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
