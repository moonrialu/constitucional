import 'package:flutter/material.dart';

import '../models/chat_script.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Respostas fixas disponíveis para o jogador.
class ChoiceList extends StatelessWidget {
  const ChoiceList({
    super.key,
    required this.choices,
    required this.onSelected,
  });

  final List<ChatChoice> choices;
  final ValueChanged<ChatChoice> onSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: choices.isEmpty
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (final ChatChoice choice in choices)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Material(
                        color: AppColors.paper,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.line),
                        ),
                        child: InkWell(
                          onTap: () => onSelected(choice),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 13, 14, 13),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    choice.label,
                                    style: AppTheme.bubble.copyWith(
                                      fontSize: 14.5,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.north_east_rounded,
                                  size: 15,
                                  color: AppColors.terracotta,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
