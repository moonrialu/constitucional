import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Medalha concedida ao longo da jornada. Apenas o `id` vai para o save.
class BadgeInfo {
  const BadgeInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.softColor,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  /// Fundo claro de alto contraste para o texto na cor `color`.
  final Color softColor;
}

const List<BadgeInfo> allBadges = [
  BadgeInfo(
    id: 'primeiro-parecer',
    title: 'Primeiro parecer',
    description: 'Você entrou na primeira batalha da mesa.',
    icon: Icons.gavel,
    color: AppColors.tealText,
    softColor: AppColors.tealSoft,
  ),
  BadgeInfo(
    id: 'mesa-limpa',
    title: 'Mesa limpa',
    description: 'Venceu as cinco batalhas da jornada.',
    icon: Icons.folder_copy_outlined,
    color: AppColors.indigoText,
    softColor: AppColors.indigoSoft,
  ),
  BadgeInfo(
    id: 'classificador',
    title: 'Classificador',
    description: 'Acertou todos os itens de regra e princípio.',
    icon: Icons.rule,
    color: AppColors.tealText,
    softColor: AppColors.tealSoft,
  ),
  BadgeInfo(
    id: 'quem-e-quem',
    title: 'Quem é quem',
    description: 'Associou cada tese ao autor correto.',
    icon: Icons.groups_outlined,
    color: AppColors.plumText,
    softColor: AppColors.plumSoft,
  ),
  BadgeInfo(
    id: 'tres-testes',
    title: 'Três testes',
    description: 'Aplicou a proporcionalidade sem errar.',
    icon: Icons.balance,
    color: AppColors.goldText,
    softColor: AppColors.goldSoft,
  ),
  BadgeInfo(
    id: 'gabarito',
    title: 'Gabarito do ministro',
    description: 'Acertou todas as questões do teste final.',
    icon: Icons.workspace_premium_outlined,
    color: AppColors.indigoText,
    softColor: AppColors.indigoSoft,
  ),
  BadgeInfo(
    id: 'jornada-concluida',
    title: 'Jornada concluída',
    description: 'Chegou ao diagnóstico de uma jornada completa.',
    icon: Icons.flag_outlined,
    color: AppColors.crimsonText,
    softColor: AppColors.crimsonSoft,
  ),
  BadgeInfo(
    id: 'segunda-leitura',
    title: 'Segunda leitura',
    description: 'Concluiu duas jornadas e comparou os resultados.',
    icon: Icons.history_edu,
    color: AppColors.tealText,
    softColor: AppColors.tealSoft,
  ),
  BadgeInfo(
    id: 'refutador',
    title: 'Refutador',
    description: 'Refutou dez objeções com o fundamento correto.',
    icon: Icons.sports_martial_arts,
    color: AppColors.crimsonText,
    softColor: AppColors.crimsonSoft,
  ),
  BadgeInfo(
    id: 'colecionador',
    title: 'Baralho completo',
    description: 'Desbloqueou todas as cartas da coleção.',
    icon: Icons.style_outlined,
    color: AppColors.plumText,
    softColor: AppColors.plumSoft,
  ),
];

BadgeInfo? badgeById(String id) {
  for (final badge in allBadges) {
    if (badge.id == id) return badge;
  }
  return null;
}
