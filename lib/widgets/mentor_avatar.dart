import 'package:flutter/material.dart';

import '../models/mutation.dart';
import '../theme/app_theme.dart';

/// Cor de cada mentor, usada no avatar, no balão e nos destaques.
Color mentorColor(String id) {
  return switch (id) {
    'amanda' => AppColors.plum,
    'ian' => AppColors.indigo,
    'gabriel' => AppColors.teal,
    'luiza' => AppColors.gold,
    'rafael' => AppColors.crimson,
    _ => AppColors.navy,
  };
}

/// Avatar circular com as iniciais do mentor. Sem imagens externas.
class MentorAvatar extends StatelessWidget {
  const MentorAvatar({
    super.key,
    required this.mentor,
    this.radius = 26,
    this.active = true,
  });

  final MentorProfile mentor;
  final double radius;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = mentorColor(mentor.id);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: radius * 2,
      height: radius * 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: active ? 1 : 0.35),
            color.withValues(alpha: active ? 0.78 : 0.2),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: active
              ? Colors.white.withValues(alpha: 0.9)
              : Colors.white.withValues(alpha: 0.3),
          width: active ? 2.4 : 1.2,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.32),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Text(
        mentor.initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: radius * 0.62,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
