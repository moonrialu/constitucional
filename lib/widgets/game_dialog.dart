import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Diálogo no visual do jogo: painel escuro, moldura dourada e botões
/// desenhados para a mesa de cartas — no lugar do `AlertDialog` padrão.
class GameDialog extends StatelessWidget {
  const GameDialog({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.child,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.accent = AppColors.gold,
    this.danger = false,
    this.scrollable = false,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? child;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Color accent;
  final bool danger;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = danger ? AppColors.crimson : accent;
    final primaryFg = danger ? Colors.white : AppColors.navy;

    final contentStyle = TextStyle(
      color: Colors.white.withValues(alpha: 0.82),
      height: 1.45,
    );
    final content = child == null
        ? null
        : scrollable
        ? Flexible(
            child: SingleChildScrollView(
              child: DefaultTextStyle.merge(style: contentStyle, child: child!),
            ),
          )
        : DefaultTextStyle.merge(style: contentStyle, child: child!);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF17374F), Color(0xFF091D2A)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: tint.withValues(alpha: 0.55), width: 1.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 4, color: tint),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: tint.withValues(alpha: 0.16),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: tint.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Icon(icon, color: tint, size: 23),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: 14),
                        Text(
                          message!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.82),
                            height: 1.45,
                          ),
                        ),
                      ],
                      if (child != null) ...[
                        const SizedBox(height: 14),
                        content!,
                      ],
                      if (primaryLabel != null || secondaryLabel != null) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            if (secondaryLabel != null)
                              _DialogButton(
                                label: secondaryLabel!,
                                onPressed: onSecondary,
                                tint: tint,
                              ),
                            const Spacer(),
                            if (primaryLabel != null)
                              _DialogButton(
                                label: primaryLabel!,
                                onPressed: onPrimary,
                                tint: tint,
                                foreground: primaryFg,
                                primary: true,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.onPressed,
    required this.tint,
    this.foreground,
    this.primary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color tint;
  final Color? foreground;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(0, 40)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
      ),
    );

    if (!primary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: style.copyWith(
          foregroundColor: WidgetStatePropertyAll(
            Colors.white.withValues(alpha: 0.78),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: Colors.white.withValues(alpha: 0.28)),
          ),
        ),
        child: Text(label),
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: style.copyWith(
        backgroundColor: WidgetStatePropertyAll(tint),
        foregroundColor: WidgetStatePropertyAll(foreground ?? AppColors.navy),
      ),
      child: Text(label),
    );
  }
}
