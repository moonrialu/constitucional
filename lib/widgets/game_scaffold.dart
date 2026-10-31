import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../engine/game_controller.dart';
import '../theme/app_theme.dart';
import 'app_menu.dart';

/// Estrutura comum das telas: barra superior, progresso e conteúdo rolável.
class GameScaffold extends StatelessWidget {
  const GameScaffold({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.showProgress = true,
    this.showBack,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final bool showProgress;

  /// Setas de voltar. Por padrão aparece em todas as telas menos a capa.
  final bool? showBack;

  /// Sobrescreve o comportamento padrão (voltar uma etapa da jornada).
  final VoidCallback? onBack;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final theme = Theme.of(context);
    final canGoBack = showBack ?? controller.currentStepId != 'cover';
    final accent = AppColors.accentFor(controller.currentStepId);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        leading: canGoBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Voltar',
                onPressed: onBack ?? controller.previous,
              )
            : null,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        bottom: showProgress
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: controller.progress,
                  minHeight: 4,
                  color: accent,
                  backgroundColor: accent.withValues(alpha: 0.16),
                ),
              )
            : null,
        actions: const [AppMenuButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final child in children) ...[
                child,
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Cartão branco padrão.
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Rótulo pequeno em caixa alta (usado acima de títulos).
class Kicker extends StatelessWidget {
  const Kicker(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        letterSpacing: 1.4,
        fontWeight: FontWeight.w700,
        color: color ?? theme.colorScheme.primary,
      ),
    );
  }
}
