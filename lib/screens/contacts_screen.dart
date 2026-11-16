import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../state/game_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/contact_tile.dart';
import 'chat_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: ListenableBuilder(
          listenable: controller,
          builder: (BuildContext context, _) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: <Widget>[
                    _Header(
                      controller: controller,
                      onReset: () => _confirmReset(context),
                    ),
                    const SizedBox(height: 28),
                    _Progress(controller: controller),
                    if (controller.isGameFinished) ...<Widget>[
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: _EffectiveBadge(),
                      ),
                    ],
                    const SizedBox(height: 20),
                    const Divider(indent: 24, endIndent: 24),
                    for (
                      int i = 0;
                      i < controller.contacts.length;
                      i++
                    ) ...<Widget>[
                      _buildTile(context, controller.contacts[i]),
                      if (i < controller.contacts.length - 1)
                        const Divider(indent: 90, endIndent: 24),
                    ],
                    const SizedBox(height: 26),
                    Text(
                      'PROGRESSO SALVO AUTOMATICAMENTE',
                      textAlign: TextAlign.center,
                      style: AppTheme.overline.copyWith(
                        fontSize: 8.5,
                        letterSpacing: 1.5,
                        color: AppColors.muted.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, Contact contact) {
    final bool unlocked = controller.isUnlocked(contact);
    return ContactTile(
      contact: contact,
      locked: !unlocked,
      completed: controller.isCompleted(contact),
      inProgress: controller.isInProgress(contact),
      preview: controller.previewFor(contact),
      onTap: () => _openChat(context, contact),
    );
  }

  void _openChat(BuildContext context, Contact contact) {
    if (!controller.isUnlocked(contact)) {
      final Contact? previous = controller.previousContact(contact);
      final String message = previous == null
          ? 'Essa conversa ainda está bloqueada.'
          : 'Conclua “${previous.name}” para desbloquear.';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(controller: controller, contact: contact),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final bool? reset = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Reiniciar o jogo?'),
          content: const Text(
            'Todas as conversas voltam a ficar bloqueadas e o progresso salvo será apagado. Essa ação não pode ser desfeita.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Reiniciar',
                style: TextStyle(color: AppColors.terracottaDark),
              ),
            ),
          ],
        );
      },
    );

    if (reset != true || !context.mounted) return;
    await controller.resetProgress();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('O jogo foi reiniciado.')));
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller, required this.onReset});

  final GameController controller;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'OVA · DIREITO CONSTITUCIONAL',
                    style: AppTheme.overline,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (_) => onReset(),
                tooltip: 'Opções',
                color: AppColors.paper,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppColors.line),
                ),
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.muted,
                ),
                itemBuilder: (BuildContext context) =>
                    const <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'reset',
                        child: Text(
                          'Reiniciar progresso',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ),
                    ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(text: 'Mutação\n'),
                TextSpan(
                  text: 'Constitucional',
                  style: AppTheme.displayTitle.copyWith(
                    color: AppColors.terracotta,
                  ),
                ),
              ],
            ),
            style: AppTheme.displayTitle,
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Text(
              'Gabinete do STF. Quatro processos e uma pergunta: a Constituição muda sem mudar o texto?',
              style: AppTheme.bodyMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final int completed = controller.completedCount;
    final int total = controller.totalStages;
    final double value = total == 0 ? 0 : completed / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '$completed de $total conversas concluídas',
                  style: AppTheme.preview.copyWith(fontSize: 12.5),
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: AppTheme.overline.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 3,
              backgroundColor: AppColors.paperDeep,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.terracotta,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Selo permanente de quem concluiu o treinamento com a Profa. Lúcia.
class _EffectiveBadge extends StatelessWidget {
  const _EffectiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.olive.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.olive.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.verified_rounded, size: 17, color: AppColors.olive),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'ASSESSOR(A) EFETIVADO(A) · STF',
              style: AppTheme.overline.copyWith(
                fontSize: 8.5,
                letterSpacing: 1.4,
                color: AppColors.olive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
