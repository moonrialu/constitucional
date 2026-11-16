import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.senderAvatarAsset,
    this.onStatementTap,
  });

  final ChatMessage message;

  /// Retrato de quem enviou, quando a conversa é em grupo.
  final String? senderAvatarAsset;

  /// Toque em um balão do rascunho para marcá-lo como falso.
  final VoidCallback? onStatementTap;

  @override
  Widget build(BuildContext context) {
    if (message.isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            message.text.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTheme.overline.copyWith(fontSize: 9, letterSpacing: 1.6),
          ),
        ),
      );
    }

    final bool isPlayer = message.isPlayer;
    final bool falseMarked = message.statementMark == StatementMark.falseMarked;
    final bool trueConfirmed =
        message.statementMark == StatementMark.trueConfirmed;
    final bool tappable =
        message.isStatement &&
        message.statementMark == StatementMark.none &&
        onStatementTap != null;
    final double maxWidth = MediaQuery.sizeOf(context).width * 0.78;

    final Widget bubble = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: EdgeInsets.fromLTRB(15, 11, tappable ? 34 : 15, 12),
      decoration: BoxDecoration(
        color: falseMarked
            ? const Color(0xFFF5E2DA)
            : isPlayer
            ? AppColors.terracotta
            : AppColors.paper,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isPlayer ? 18 : 5),
          bottomRight: Radius.circular(isPlayer ? 5 : 18),
        ),
        border: isPlayer
            ? null
            : Border.all(
                color: falseMarked ? _falseRed : AppColors.line,
                width: falseMarked ? 1.5 : 1,
              ),
      ),
      child: Text(
        message.text,
        style: AppTheme.bubble.copyWith(
          color: isPlayer
              ? AppColors.cream
              : falseMarked
              ? AppColors.muted
              : AppColors.inkSoft,
          decoration: falseMarked ? TextDecoration.lineThrough : null,
          decorationColor: _falseRed,
        ),
      ),
    );

    final Widget interactiveBubble = tappable
        ? Semantics(
            button: true,
            label: 'Marcar como falso: ${message.text}',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onStatementTap,
              child: bubble,
            ),
          )
        : bubble;

    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        bottom: isPlayer && message.hasReactions ? 16 : 4,
      ),
      child: Column(
        crossAxisAlignment: isPlayer
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          if (!isPlayer && message.senderName != null)
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (senderAvatarAsset != null) ...<Widget>[
                    ClipOval(
                      child: Image.asset(
                        senderAvatarAsset!,
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    message.senderName!,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      color: AppColors.terracottaDark,
                    ),
                  ),
                ],
              ),
            ),
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              interactiveBubble,
              if (tappable)
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.touch_app_outlined,
                      size: 15,
                      color: AppColors.terracotta.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              if (message.isStatement && (falseMarked || trueConfirmed))
                Positioned(
                  top: -9,
                  right: 12,
                  child: _StatementSeal(falseMarked: falseMarked),
                ),
              if (isPlayer && message.hasReactions)
                Positioned(
                  right: 12,
                  bottom: -12,
                  child: _MessageReactions(reactions: message.reactions),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

const Color _falseRed = Color(0xFFB1462C);
const Color _trueGreen = Color(0xFF4F7A52);

class _StatementSeal extends StatelessWidget {
  const _StatementSeal({required this.falseMarked});

  final bool falseMarked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: falseMarked ? _falseRed : _trueGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: (falseMarked ? _falseRed : _trueGreen).withValues(
              alpha: 0.28,
            ),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        falseMarked ? 'FALSO · APAGAR 🗑️' : 'CERTA ✓',
        style: const TextStyle(
          fontSize: 8.5,
          height: 1.1,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.7,
          color: AppColors.cream,
        ),
      ),
    );
  }
}

/// Emojis flutuantes que os outros participantes deixam no balão do jogador.
class _MessageReactions extends StatefulWidget {
  const _MessageReactions({required this.reactions});

  final List<MessageReaction> reactions;

  @override
  State<_MessageReactions> createState() => _MessageReactionsState();
}

class _MessageReactionsState extends State<_MessageReactions>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String description = widget.reactions
        .map((MessageReaction r) => '${r.reactorName} reagiu com ${r.emoji}')
        .join('; ');

    return Semantics(
      label: description,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: 1),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutBack,
        builder: (BuildContext context, double value, Widget? child) {
          return Opacity(
            opacity: value.clamp(0, 1),
            child: Transform.scale(scale: 0.7 + 0.3 * value, child: child),
          );
        },
        child: AnimatedBuilder(
          animation: _float,
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
              offset: Offset(0, -2.5 * _float.value),
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (final MessageReaction reaction in widget.reactions)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Text(
                      reaction.emoji,
                      style: const TextStyle(fontSize: 14, height: 1.1),
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
