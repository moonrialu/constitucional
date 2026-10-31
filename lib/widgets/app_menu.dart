import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../engine/game_controller.dart';
import '../screens/collection_screen.dart';
import '../screens/glossary_screen.dart';
import '../theme/app_theme.dart';
import 'game_dialog.dart';

/// Ações do menu do gabinete. As marcadas como `future` já aparecem na lista
/// desabilitadas, para as próximas fases do projeto.
enum AppMenuAction { howToPlay, restart, reset, glossary, collection, export }

class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key, this.color, this.compact = false});

  /// Cor do ícone, para uso sobre fundos escuros.
  final Color? color;

  /// Versão reduzida, para barras e painéis compactos.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    // Em modo compacto o ícone é o próprio filho, para não herdar o
    // tamanho mínimo de 48 dp do IconButton.
    final compactChild = compact
        ? SizedBox(
            width: 26,
            height: 26,
            child: Icon(Icons.more_vert, size: 18, color: color),
          )
        : null;

    return PopupMenuButton<AppMenuAction>(
      tooltip: 'Menu do gabinete',
      padding: EdgeInsets.zero,
      icon: compact ? null : Icon(Icons.more_vert, color: color),
      iconSize: compact ? null : 24,
      onSelected: (action) => _handle(context, action),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: AppMenuAction.howToPlay,
          child: _MenuRow(icon: Icons.help_outline, label: 'Como jogar'),
        ),
        PopupMenuItem(
          value: AppMenuAction.restart,
          child: _MenuRow(icon: Icons.refresh, label: 'Reiniciar jornada'),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: AppMenuAction.glossary,
          child: _MenuRow(icon: Icons.translate, label: 'Glossário'),
        ),
        PopupMenuItem(
          value: AppMenuAction.collection,
          child: _MenuRow(
            icon: Icons.style_outlined,
            label: 'Coleção de cartas',
          ),
        ),
        PopupMenuItem(
          value: AppMenuAction.export,
          child: _MenuRow(icon: Icons.ios_share, label: 'Exportar resultado'),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: AppMenuAction.reset,
          child: _MenuRow(
            icon: Icons.delete_outline,
            label: 'Apagar progresso e histórico',
            danger: true,
          ),
        ),
      ],
      child: compactChild,
    );
  }

  Future<void> _handle(BuildContext context, AppMenuAction action) async {
    final controller = context.read<GameController>();

    switch (action) {
      case AppMenuAction.howToPlay:
        await showDialog<void>(
          context: context,
          builder: (context) => const _HowToPlayDialog(),
        );
      case AppMenuAction.restart:
        await controller.restart();
      case AppMenuAction.reset:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => GameDialog(
            icon: Icons.delete_outline,
            title: 'Apagar tudo?',
            danger: true,
            message:
                'O progresso e o histórico de tentativas serão apagados. '
                'Esta ação não pode ser desfeita.',
            secondaryLabel: 'Cancelar',
            onSecondary: () => Navigator.of(context).pop(false),
            primaryLabel: 'Apagar',
            onPrimary: () => Navigator.of(context).pop(true),
          ),
        );
        if (confirmed ?? false) await controller.resetAll();
      case AppMenuAction.glossary:
        await Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const GlossaryScreen()));
      case AppMenuAction.collection:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const CollectionScreen()),
        );
      case AppMenuAction.export:
        await Clipboard.setData(ClipboardData(text: controller.buildReport()));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Resultado copiado para a área de transferência.'),
          ),
        );
    }
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = danger
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: color)),
      ],
    );
  }
}

class _HowToPlayDialog extends StatelessWidget {
  const _HowToPlayDialog();

  @override
  Widget build(BuildContext context) {
    return GameDialog(
      icon: Icons.auto_stories_outlined,
      title: 'Como jogar',
      scrollable: true,
      primaryLabel: 'Entendi',
      onPrimary: () => Navigator.of(context).pop(),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HowToItem(
            icon: Icons.style_outlined,
            text:
                'Cinco processos passam pela sua mesa, cada um como uma '
                'batalha de cartas. A tese adversa ataca com uma objeção; '
                'você responde com fundamentos do seu baralho.',
          ),
          _HowToItem(
            icon: Icons.bolt_outlined,
            text:
                'A objeção indica o tipo de fundamento que a refuta. Jogar a '
                'carta certa zera o dano do turno e causa dano extra. A '
                'energia é 3 por turno e a mão tem 5 cartas.',
          ),
          _HowToItem(
            icon: Icons.touch_app_outlined,
            text:
                'Levante a carta com um toque para ler o fundamento e dê '
                'duplo toque para jogá-la. Várias cartas levantadas formam um '
                'conjunto de resposta. Vencer batalhas desbloqueia cartas.',
          ),
          _HowToItem(
            icon: Icons.shield_outlined,
            text:
                'Perder uma batalha não apaga progresso: você pode retomar. '
                'O progresso é salvo automaticamente.',
          ),
        ],
      ),
    );
  }
}

class _HowToItem extends StatelessWidget {
  const _HowToItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 15, color: AppColors.gold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFFDDE6EE),
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
