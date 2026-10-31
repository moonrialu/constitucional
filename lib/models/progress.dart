/// Estruturas de progresso persistidas localmente na v2.
library;

import 'dart:convert';

import 'battle.dart';

/// Registro de uma jornada concluída (teste final respondido).
class AttemptRecord {
  const AttemptRecord({
    required this.finishedAt,
    required this.battlesWon,
    required this.battlesTotal,
    required this.quizScore,
    required this.quizTotal,
    required this.elapsedMs,
  });

  final DateTime finishedAt;
  final int battlesWon;
  final int battlesTotal;
  final int quizScore;
  final int quizTotal;
  final int elapsedMs;

  Map<String, dynamic> toJson() => {
    'finishedAt': finishedAt.toIso8601String(),
    'battlesWon': battlesWon,
    'battlesTotal': battlesTotal,
    'quizScore': quizScore,
    'quizTotal': quizTotal,
    'elapsedMs': elapsedMs,
  };

  factory AttemptRecord.fromJson(Map<String, dynamic> json) => AttemptRecord(
    finishedAt:
        DateTime.tryParse(json['finishedAt'] as String? ?? '') ??
        DateTime.now(),
    battlesWon: json['battlesWon'] as int? ?? 0,
    battlesTotal: json['battlesTotal'] as int? ?? 0,
    quizScore: json['quizScore'] as int? ?? 0,
    quizTotal: json['quizTotal'] as int? ?? 0,
    elapsedMs: json['elapsedMs'] as int? ?? 0,
  );
}

/// Estado completo da jornada, serializado em JSON no armazenamento local.
class ProgressData {
  const ProgressData({
    this.version = currentVersion,
    this.currentStep = 'cover',
    this.startedAt,
    this.finishedAt,
    this.battles = const {},
    this.unlockedCards = const [],
    this.visited = const [],
    this.quizAnswers = const {},
    this.checkAnswers = const {},
    this.quizIds = const [],
    this.badges = const [],
    this.history = const [],
  });

  static const int currentVersion = 3;

  final int version;
  final String currentStep;
  final DateTime? startedAt;
  final DateTime? finishedAt;

  /// battleId -> resultado da batalha.
  final Map<String, BattleRecord> battles;

  /// Ids das cartas já desbloqueadas.
  final List<String> unlockedCards;

  /// Etapas por que a pessoa já passou (usado nos desbloqueios de teoria).
  final List<String> visited;

  /// questionId -> optionId
  final Map<String, String> quizAnswers;

  /// "stepId/questionId" -> optionId (etapas de classificar e associar).
  final Map<String, String> checkAnswers;

  /// Questões sorteadas para a tentativa atual do teste final.
  final List<String> quizIds;

  /// Ids dos badges conquistados (definidos em `data/badges.dart`).
  final List<String> badges;

  final List<AttemptRecord> history;

  bool get hasAnswers =>
      battles.isNotEmpty || quizAnswers.isNotEmpty || checkAnswers.isNotEmpty;

  int get battlesWon => battles.values.where((b) => b.won).length;

  int get battlesPlayed => battles.length;

  int get totalAttempts => battles.values.fold(0, (sum, b) => sum + b.attempts);

  int get totalRefutations =>
      battles.values.fold(0, (sum, b) => sum + b.refutations);

  int get totalCardsPlayed =>
      battles.values.fold(0, (sum, b) => sum + b.cardsPlayed);

  Duration get elapsed {
    final start = startedAt;
    if (start == null) return Duration.zero;
    return (finishedAt ?? DateTime.now()).difference(start);
  }

  ProgressData copyWith({
    int? version,
    String? currentStep,
    DateTime? startedAt,
    DateTime? finishedAt,
    Map<String, BattleRecord>? battles,
    List<String>? unlockedCards,
    List<String>? visited,
    Map<String, String>? quizAnswers,
    Map<String, String>? checkAnswers,
    List<String>? quizIds,
    List<String>? badges,
    List<AttemptRecord>? history,
  }) {
    return ProgressData(
      version: version ?? this.version,
      currentStep: currentStep ?? this.currentStep,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      battles: battles ?? this.battles,
      unlockedCards: unlockedCards ?? this.unlockedCards,
      visited: visited ?? this.visited,
      quizAnswers: quizAnswers ?? this.quizAnswers,
      checkAnswers: checkAnswers ?? this.checkAnswers,
      quizIds: quizIds ?? this.quizIds,
      badges: badges ?? this.badges,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'currentStep': currentStep,
    'startedAt': startedAt?.toIso8601String(),
    'finishedAt': finishedAt?.toIso8601String(),
    'battles': battles.map((key, value) => MapEntry(key, value.toJson())),
    'unlockedCards': unlockedCards,
    'visited': visited,
    'quizAnswers': quizAnswers,
    'checkAnswers': checkAnswers,
    'quizIds': quizIds,
    'badges': badges,
    'history': history.map((e) => e.toJson()).toList(),
  };

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    final rawBattles = (json['battles'] as Map?) ?? const {};
    return ProgressData(
      version: json['version'] as int? ?? 1,
      currentStep: json['currentStep'] as String? ?? 'cover',
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? ''),
      finishedAt: DateTime.tryParse(json['finishedAt'] as String? ?? ''),
      battles: {
        for (final entry in rawBattles.entries)
          if (entry.value is Map)
            entry.key as String: BattleRecord.fromJson(
              Map<String, dynamic>.from(entry.value as Map),
            ),
      },
      unlockedCards: ((json['unlockedCards'] as List?) ?? const [])
          .whereType<String>()
          .toList(),
      visited: ((json['visited'] as List?) ?? const [])
          .whereType<String>()
          .toList(),
      quizAnswers: Map<String, String>.from(
        (json['quizAnswers'] as Map?) ?? const {},
      ),
      checkAnswers: Map<String, String>.from(
        (json['checkAnswers'] as Map?) ?? const {},
      ),
      quizIds: ((json['quizIds'] as List?) ?? const [])
          .whereType<String>()
          .toList(),
      badges: ((json['badges'] as List?) ?? const [])
          .whereType<String>()
          .toList(),
      history: ((json['history'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => AttemptRecord.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  String encode() => jsonEncode(toJson());

  static ProgressData? decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return ProgressData.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      // Save corrompido ou de versão incompatível: recomeça do zero.
      return null;
    }
  }
}
