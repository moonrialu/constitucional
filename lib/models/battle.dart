import 'card.dart';

/// Ataque da tese adversa. O texto vem de uma alternativa incorreta do caso.
class Objection {
  const Objection({
    required this.id,
    required this.text,
    required this.damage,
    required this.counterTags,
    required this.counterHint,
    this.sourceChoiceId,
  });

  final String id;
  final String text;
  final int damage;

  /// Basta a carta jogada ter uma destas tags para refutar a objeção.
  final Set<CardTag> counterTags;

  /// Dica curta mostrada na mesa ("Regra", "Mutação"...).
  final String counterHint;

  /// Alternativa do caso que originou a objeção (para o relatório).
  final String? sourceChoiceId;

  bool isCounteredBy(ArgumentCard card) => card.tags.any(counterTags.contains);
}

/// Configuração de uma batalha: o caso, o baralho e as objeções da máquina.
class BattleConfig {
  const BattleConfig({
    required this.id,
    required this.caseId,
    required this.title,
    required this.subtitle,
    required this.opponentName,
    required this.opponentTitle,
    required this.intro,
    required this.deck,
    required this.objections,
    required this.rewardLabel,
    this.playerConviction = 20,
    this.machineConviction = 18,
    this.energyPerTurn = 3,
    this.handSize = 5,
    this.theoryId,
  });

  final String id;
  final String caseId;
  final String title;
  final String subtitle;
  final String opponentName;
  final String opponentTitle;
  final String intro;

  /// Ids de cartas, na ordem em que formam o baralho inicial.
  final List<String> deck;
  final List<Objection> objections;
  final String rewardLabel;

  final int playerConviction;
  final int machineConviction;
  final int energyPerTurn;
  final int handSize;

  /// Teoria consultável no botão "Rever a teoria".
  final String? theoryId;
}

/// Resultado persistido de uma batalha.
class BattleRecord {
  const BattleRecord({
    required this.won,
    required this.attempts,
    required this.turns,
    required this.convictionLeft,
    required this.refutations,
    required this.cardsPlayed,
    required this.finishedAt,
  });

  final bool won;
  final int attempts;
  final int turns;
  final int convictionLeft;
  final int refutations;
  final int cardsPlayed;
  final DateTime finishedAt;

  BattleRecord copyWith({
    bool? won,
    int? attempts,
    int? turns,
    int? convictionLeft,
    int? refutations,
    int? cardsPlayed,
    DateTime? finishedAt,
  }) {
    return BattleRecord(
      won: won ?? this.won,
      attempts: attempts ?? this.attempts,
      turns: turns ?? this.turns,
      convictionLeft: convictionLeft ?? this.convictionLeft,
      refutations: refutations ?? this.refutations,
      cardsPlayed: cardsPlayed ?? this.cardsPlayed,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'won': won,
    'attempts': attempts,
    'turns': turns,
    'convictionLeft': convictionLeft,
    'refutations': refutations,
    'cardsPlayed': cardsPlayed,
    'finishedAt': finishedAt.toIso8601String(),
  };

  factory BattleRecord.fromJson(Map<String, dynamic> json) => BattleRecord(
    won: json['won'] as bool? ?? false,
    attempts: json['attempts'] as int? ?? 1,
    turns: json['turns'] as int? ?? 0,
    convictionLeft: json['convictionLeft'] as int? ?? 0,
    refutations: json['refutations'] as int? ?? 0,
    cardsPlayed: json['cardsPlayed'] as int? ?? 0,
    finishedAt:
        DateTime.tryParse(json['finishedAt'] as String? ?? '') ??
        DateTime.now(),
  );
}

/// Fase da batalha. `playerTurn` e `machineTurn` alternam a cada turno.
enum BattlePhase { playerTurn, machineTurn, won, lost }

/// Linha do log de turno exibida na mesa.
class BattleLogEntry {
  const BattleLogEntry(this.text, {this.kind = BattleLogKind.neutral});

  final String text;
  final BattleLogKind kind;
}

enum BattleLogKind { neutral, player, machine, good, bad }
