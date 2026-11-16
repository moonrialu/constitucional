import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Campo de texto livre + botão de enviar.
///
/// O texto livre já existe para a futura conversa com o modelo local.
/// Hoje ele não substitui as escolhas de resposta.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.hint,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final String hint;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.line),
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  maxLines: 1,
                  textInputAction: TextInputAction.send,
                  cursorColor: AppColors.terracotta,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    color: AppColors.inkSoft,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: AppColors.muted,
                    ),
                  ),
                  onSubmitted: (String value) {
                    if (enabled) onSend(value);
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (BuildContext context, TextEditingValue value, _) {
                final bool canSend = enabled && value.text.trim().isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: canSend ? AppColors.terracotta : AppColors.paperDeep,
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: canSend ? () => onSend(controller.text) : null,
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        size: 20,
                        color: canSend ? AppColors.cream : AppColors.muted,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
