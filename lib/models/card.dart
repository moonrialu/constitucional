import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Tipo de carta define o papel dela na mesa.
enum CardKind { ataque, defesa, apoio }

/// Eixo jurídico da carta. É o que permite refutar a objeção da máquina:
/// cada objeção só cede a um fundamento com a tag correspondente.
enum CardTag {
  regra('Regra'),
  principio('Princípio'),
  mutacao('Mutação'),
  proporcionalidade('Proporcionalidade'),
  competencia('Competência'),
  precedente('Precedente'),
  doutrina('Doutrina');

  const CardTag(this.label);

  final String label;

  static CardTag? byName(String name) {
    for (final tag in values) {
      if (tag.name == name) return tag;
    }
    return null;
  }
}

/// Carta de argumento do baralho da assessora.
class ArgumentCard {
  const ArgumentCard({
    required this.id,
    required this.title,
    required this.text,
    required this.kind,
    required this.cost,
    required this.tags,
    this.power = 0,
    this.block = 0,
    this.draw = 0,
    this.energy = 0,
    this.precedent,
    this.unlock,
    this.unlockLabel,
  });

  final String id;
  final String title;

  /// Fundamento que aparece na face da carta.
  final String text;
  final CardKind kind;
  final int cost;

  /// Dano causado à convicção da tese adversa.
  final int power;

  /// Bloqueio aplicado ao próximo ataque da máquina.
  final int block;

  /// Cartas compradas ao jogar.
  final int draw;

  /// Energia recuperada ao jogar.
  final int energy;
  final Set<CardTag> tags;

  /// Julgado citado, quando a carta é um precedente.
  final String? precedent;

  /// Etapa que desbloqueia a carta. `null` = disponível desde o início.
  final String? unlock;
  final String? unlockLabel;

  bool get isAttack => kind == CardKind.ataque;

  String get kindLabel => switch (kind) {
    CardKind.ataque => 'Ataque',
    CardKind.defesa => 'Defesa',
    CardKind.apoio => 'Apoio',
  };

  Color get color => switch (kind) {
    CardKind.ataque => AppColors.crimsonText,
    CardKind.defesa => AppColors.tealText,
    CardKind.apoio => AppColors.plumText,
  };

  Color get soft => switch (kind) {
    CardKind.ataque => AppColors.crimsonSoft,
    CardKind.defesa => AppColors.tealSoft,
    CardKind.apoio => AppColors.plumSoft,
  };

  IconData get icon => switch (kind) {
    CardKind.ataque => Icons.gavel,
    CardKind.defesa => Icons.shield_outlined,
    CardKind.apoio => Icons.auto_stories_outlined,
  };

  /// Linha curta de efeito, usada no rodapé da carta.
  String get effectLabel {
    final parts = <String>[];
    if (power > 0) parts.add('$power de dano');
    if (block > 0) parts.add('$block de bloqueio');
    if (draw > 0) parts.add('compra $draw');
    if (energy > 0) parts.add('+$energy energia');
    return parts.isEmpty ? 'Fundamento' : parts.join(' · ');
  }
}
