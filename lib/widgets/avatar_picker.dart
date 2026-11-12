import 'package:flutter/material.dart';

import '../data/training_dialogue.dart';
import '../models/mutation.dart';
import '../theme/app_theme.dart';
import 'mentor_avatar.dart';

/// Escolha do rosto do jogador entre os integrantes do grupo.
///
/// As fotos são as mesmas usadas no treinamento: o estudante joga com o rosto
/// de uma das pessoas que construiu o OVA. O avatar fica salvo no progresso.
class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    super.key,
    required this.selectedId,
    required this.onSelected,
    this.radius = 24,
    this.showNames = true,
    this.dark = false,
  });

  final String selectedId;
  final ValueChanged<String> onSelected;
  final double radius;
  final bool showNames;

  /// Versão para fundos escuros (onboarding e capa).
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final labelColor = dark
        ? Colors.white.withValues(alpha: 0.72)
        : AppColors.ink.withValues(alpha: 0.6);

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        for (final mentor in mutationMentors)
          _AvatarOption(
            mentor: mentor,
            selected: mentor.id == selectedId,
            onTap: () => onSelected(mentor.id),
            radius: radius,
            showName: showNames,
            dark: dark,
            labelColor: labelColor,
          ),
      ],
    );
  }
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.mentor,
    required this.selected,
    required this.onTap,
    required this.radius,
    required this.showName,
    required this.dark,
    required this.labelColor,
  });

  final MentorProfile mentor;
  final bool selected;
  final VoidCallback onTap;
  final double radius;
  final bool showName;
  final bool dark;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final color = mentorColor(mentor.id);
    return Semantics(
      button: true,
      selected: selected,
      label: 'Avatar de ${mentor.name}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius + 8),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? AppColors.gold : Colors.transparent,
                        width: 2.6,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: MentorAvatar(
                      mentor: mentor,
                      radius: radius,
                      active: selected,
                    ),
                  ),
                  if (selected)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              if (showName) ...[
                const SizedBox(height: 4),
                Text(
                  mentor.name,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                    color: selected
                        ? (dark ? Colors.white : AppColors.goldText)
                        : labelColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
