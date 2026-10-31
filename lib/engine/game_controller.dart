import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/badges.dart';
import '../data/battles.dart';
import '../data/cards.dart';
import '../data/checks.dart';
import '../data/flow.dart';
import '../data/quiz.dart';
import '../models/battle.dart';
import '../models/card.dart';
import '../models/content.dart';
import '../models/progress.dart';
import '../services/progress_store.dart';

/// Controla o fluxo da jornada, as batalhas, a pontuação e a persistência.
class GameController extends ChangeNotifier {
  GameController(this._storage, {DateTime Function()? clock, Random? random})
    : _clock = clock ?? DateTime.now,
      _random = random ?? Random();

  final ProgressStorage _storage;
  final DateTime Function() _clock;
  final Random _random;

  /// Quantas questões do banco entram no teste final de cada tentativa.
  static const int quizSessionSize = 6;

  ProgressData _data = const ProgressData();
  bool _ready = false;

  ProgressData get data => _data;
  bool get ready => _ready;

  String get currentStepId => _data.currentStep;

  int get battleTotal => battleConfigs.length;

  // ------------------------------------------------------------- batalhas

  BattleConfig? get currentBattle => battleById(currentStepId);

  BattleRecord? recordForBattle(String battleId) => _data.battles[battleId];

  bool hasWonBattle(String battleId) => _data.battles[battleId]?.won ?? false;

  int get battlesWon => _data.battlesWon;

  int get battlesPlayed => _data.battlesPlayed;

  int get totalRefutations => _data.totalRefutations;

  int get totalCardsPlayed => _data.totalCardsPlayed;

  /// Registra o início (ou a retomada) de uma tentativa de batalha.
  Future<void> beginBattleAttempt(String battleId) async {
    final previous = _data.battles[battleId];
    final record = BattleRecord(
      won: previous?.won ?? false,
      attempts: (previous?.attempts ?? 0) + 1,
      turns: previous?.turns ?? 0,
      convictionLeft: previous?.convictionLeft ?? 0,
      refutations: previous?.refutations ?? 0,
      cardsPlayed: previous?.cardsPlayed ?? 0,
      finishedAt: previous?.finishedAt ?? _clock(),
    );
    await _update(
      _data.copyWith(
        battles: {..._data.battles, battleId: record},
        startedAt: _data.startedAt ?? _clock(),
      ),
    );
  }

  /// Salva o resultado da batalha. A vitória é permanente: repetir a batalha
  /// não apaga o fato de já ter vencido.
  Future<void> completeBattle(String battleId, BattleRecord result) async {
    final previous = _data.battles[battleId];
    final merged = result.copyWith(
      won: result.won || (previous?.won ?? false),
      attempts: max(result.attempts, previous?.attempts ?? 1),
    );
    await _update(
      _data.copyWith(
        battles: {..._data.battles, battleId: merged},
        startedAt: _data.startedAt ?? _clock(),
      ),
    );
  }

  // ------------------------------------------------------------- cartas

  List<ArgumentCard> get unlockedCardList => [
    for (final card in allCards)
      if (_data.unlockedCards.contains(card.id)) card,
  ];

  int get unlockedCardCount => unlockedCardList.length;

  bool isCardUnlocked(String id) => _data.unlockedCards.contains(id);

  /// Cartas recém-liberadas ao concluir uma etapa (para o relatório).
  List<ArgumentCard> newCardsFor(String stage) => cardsUnlockedBy(stage);

  // ------------------------------------------------------------- teste final

  List<QuizQuestion> get sessionQuizQuestions => _sessionFor(_data);

  int get quizTotal => sessionQuizQuestions.length;

  int get quizScore {
    var score = 0;
    for (final question in sessionQuizQuestions) {
      if (question.isCorrect(_data.quizAnswers[question.id])) score++;
    }
    return score;
  }

  List<QuizQuestion> get wrongQuestions => sessionQuizQuestions
      .where(
        (q) =>
            _data.quizAnswers.containsKey(q.id) &&
            !q.isCorrect(_data.quizAnswers[q.id]),
      )
      .toList();

  // -------------------------------------------------- etapas interativas

  static String checkKey(String stepId, String questionId) =>
      '$stepId/$questionId';

  String? answerForCheck(String stepId, String questionId) =>
      _data.checkAnswers[checkKey(stepId, questionId)];

  int checkAnsweredCount(CheckStep step) =>
      step.questions.where((q) => answerForCheck(step.id, q.id) != null).length;

  int checkCorrectCount(CheckStep step) => step.questions
      .where((q) => q.isCorrect(answerForCheck(step.id, q.id)))
      .length;

  bool isCheckComplete(CheckStep step) =>
      step.questions.every((q) => answerForCheck(step.id, q.id) != null);

  bool isCheckAllCorrect(CheckStep step) =>
      step.questions.isNotEmpty &&
      step.questions.every((q) => q.isCorrect(answerForCheck(step.id, q.id)));

  int get checkItemTotal =>
      checkSteps.fold(0, (sum, step) => sum + step.questions.length);

  int get checkItemCorrect {
    var total = 0;
    for (final step in checkSteps) {
      total += checkCorrectCount(step);
    }
    return total;
  }

  // ---------------------------------------------------------------- badges

  List<BadgeInfo> get earnedBadges =>
      _data.badges.map(badgeById).whereType<BadgeInfo>().toList();

  bool hasBadge(String id) => _data.badges.contains(id);

  // ---------------------------------------------------------------- leitura

  bool get hasAnswers => _data.hasAnswers;

  bool get isFinished => battlesWon >= battleTotal;

  double get progress {
    final index = indexOfStep(currentStepId);
    return ((index - 1).clamp(0, playableSteps) / playableSteps).toDouble();
  }

  Duration get elapsed => _data.elapsed;

  Future<void> load() async {
    var loaded = await _storage.load() ?? const ProgressData();
    if (!journeyFlow.contains(loaded.currentStep)) {
      // Save de uma etapa removida (teoria, check, quiz...): volta à capa.
      loaded = loaded.copyWith(currentStep: 'cover');
    }
    _data = _withBadges(_withUnlocks(_withSession(loaded)));
    _ready = true;

    if (loaded.quizIds.length != quizSessionSize ||
        loaded.version != ProgressData.currentVersion ||
        loaded.badges.length != _data.badges.length ||
        loaded.unlockedCards.length != _data.unlockedCards.length) {
      await _storage.save(_data);
    }
    notifyListeners();
  }

  String? answerForQuiz(String quizId) => _data.quizAnswers[quizId];

  // ---------------------------------------------------------------- escrita

  Future<void> beginJourney() async {
    await _update(
      _data.copyWith(
        currentStep: 'battle1',
        startedAt: _data.startedAt ?? _clock(),
      ),
    );
  }

  Future<void> continueJourney() async {
    if (currentStepId == 'cover') {
      await beginJourney();
    }
  }

  Future<void> answerQuiz(QuizQuestion question, String choiceId) async {
    if (!sessionQuizQuestions.any((q) => q.id == question.id)) return;
    final answers = Map<String, String>.from(_data.quizAnswers)
      ..[question.id] = choiceId;
    await _update(_data.copyWith(quizAnswers: answers));
  }

  Future<void> answerCheck(
    CheckStep step,
    CheckQuestion question,
    String optionId,
  ) async {
    if (question.optionById(optionId) == null) return;
    final answers = Map<String, String>.from(_data.checkAnswers)
      ..[checkKey(step.id, question.id)] = optionId;
    await _update(_data.copyWith(checkAnswers: answers));
  }

  Future<void> clearCheckAnswers(CheckStep step) async {
    final answers = Map<String, String>.from(_data.checkAnswers)
      ..removeWhere((key, _) => key.startsWith('${step.id}/'));
    await _update(_data.copyWith(checkAnswers: answers));
  }

  Future<void> next() async {
    final following = stepAfter(currentStepId);
    if (following == null) {
      // Fim da jornada atual: volta à tela inicial com o progresso salvo.
      if (currentStepId == 'battle5') {
        await _update(_data.copyWith(currentStep: 'cover'));
      }
      return;
    }
    await _update(_data.copyWith(currentStep: following));
  }

  Future<void> previous() async {
    final index = indexOfStep(currentStepId);
    if (index <= 0) return;

    final leavingDiagnosis = currentStepId == 'diagnosis';
    final history = leavingDiagnosis && _data.history.isNotEmpty
        ? _data.history.sublist(0, _data.history.length - 1)
        : _data.history;

    await _update(
      ProgressData(
        version: _data.version,
        currentStep: journeyFlow[index - 1],
        startedAt: _data.startedAt,
        finishedAt: leavingDiagnosis ? null : _data.finishedAt,
        battles: _data.battles,
        unlockedCards: _data.unlockedCards,
        visited: _data.visited,
        quizAnswers: _data.quizAnswers,
        checkAnswers: _data.checkAnswers,
        quizIds: _data.quizIds,
        badges: _data.badges,
        history: history,
      ),
    );
  }

  Future<void> goToStep(String stepId) async {
    if (!journeyFlow.contains(stepId)) return;
    await _update(_data.copyWith(currentStep: stepId));
  }

  Future<void> finishQuiz() async {
    final questions = sessionQuizQuestions;
    final allAnswered =
        questions.isNotEmpty &&
        questions.every((q) => _data.quizAnswers.containsKey(q.id));
    if (!allAnswered) return;

    final finishedAt = _clock();
    final record = AttemptRecord(
      finishedAt: finishedAt,
      battlesWon: battlesWon,
      battlesTotal: battleTotal,
      quizScore: quizScore,
      quizTotal: quizTotal,
      elapsedMs: finishedAt
          .difference(_data.startedAt ?? finishedAt)
          .inMilliseconds,
    );
    await _update(
      _data.copyWith(
        currentStep: 'diagnosis',
        finishedAt: finishedAt,
        history: [..._data.history, record],
      ),
    );
  }

  /// Refaz a jornada mantendo histórico, medalhas e a coleção de cartas.
  Future<void> restart() async {
    await _update(
      ProgressData(
        currentStep: 'battle1',
        startedAt: _clock(),
        unlockedCards: _data.unlockedCards,
        badges: _data.badges,
        history: _data.history,
      ),
      newQuizSession: true,
    );
  }

  Future<void> resetAll() async {
    _data = _withBadges(_withUnlocks(_withSession(const ProgressData())));
    await _storage.clear();
    notifyListeners();
  }

  // ------------------------------------------------------------- relatório

  String buildReport() {
    final buffer = StringBuffer()
      ..writeln('Assessora do STF — Baralho de Argumentos')
      ..writeln('Batalhas vencidas: $battlesWon/$battleTotal')
      ..writeln('Tentativas de batalha: ${_data.totalAttempts}')
      ..writeln('Objeções refutadas: $totalRefutations')
      ..writeln('Cartas jogadas: $totalCardsPlayed')
      ..writeln('Cartas na coleção: $unlockedCardCount/${allCards.length}')
      ..writeln('Etapas interativas: $checkItemCorrect/$checkItemTotal')
      ..writeln('Teste final: $quizScore/$quizTotal')
      ..writeln('Tempo: ${_formatDuration(elapsed)}')
      ..writeln('Jornadas concluídas: ${_data.history.length}');

    final medals = earnedBadges;
    buffer.writeln(
      medals.isEmpty
          ? 'Medalhas: nenhuma ainda'
          : 'Medalhas: ${medals.map((b) => b.title).join(', ')}',
    );

    if (wrongQuestions.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Para revisar:');
      for (final question in wrongQuestions) {
        buffer.writeln('- ${question.reviewTopic}');
      }
    }
    return buffer.toString().trim();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  // --------------------------------------------------------------- internos

  List<QuizQuestion> _sessionFor(ProgressData data) {
    if (data.quizIds.isEmpty) {
      return quizQuestions.take(quizSessionSize).toList();
    }
    final selected = <QuizQuestion>[];
    for (final id in data.quizIds) {
      final question = quizById(id);
      if (question != null) selected.add(question);
    }
    return selected;
  }

  ProgressData _withSession(ProgressData data, {bool force = false}) {
    final valid =
        data.quizIds.length == quizSessionSize &&
        data.quizIds.every((id) => quizById(id) != null);
    if (valid && !force) {
      return data.version == ProgressData.currentVersion
          ? data
          : data.copyWith(version: ProgressData.currentVersion);
    }
    if (quizQuestions.length <= quizSessionSize) {
      return data.copyWith(
        version: ProgressData.currentVersion,
        quizIds: quizQuestions.map((q) => q.id).toList(),
      );
    }

    final pool = [...quizQuestions]..shuffle(_random);
    final ids = pool.take(quizSessionSize).toList()
      ..sort((a, b) => a.number.compareTo(b.number));
    return data.copyWith(
      version: ProgressData.currentVersion,
      quizIds: ids.map((q) => q.id).toList(),
    );
  }

  bool _checkAllCorrect(ProgressData data, String stepId) {
    final step = checkStepById(stepId);
    if (step == null) return false;
    return step.questions.every(
      (q) => q.isCorrect(data.checkAnswers[checkKey(step.id, q.id)]),
    );
  }

  /// Etapas que desbloqueiam cartas. As antigas etapas de check/teoria/quiz
  /// foram removidas por enquanto: enquanto não voltam, suas recompensas são
  /// liberadas ao vencer a batalha correspondente.
  bool _stageCompleted(ProgressData data, String stage) {
    if (stage.startsWith('battle')) {
      return data.battles[stage]?.won ?? false;
    }
    if (stage == 'check1') return data.battles['battle1']?.won ?? false;
    if (stage == 'check2') return data.battles['battle2']?.won ?? false;
    if (stage == 'check3') return data.battles['battle5']?.won ?? false;
    if (stage == 'theory2') return data.battles['battle2']?.won ?? false;
    if (stage == 'quiz') return data.battles['battle5']?.won ?? false;
    return false;
  }

  /// A coleção é cumulativa: nada é bloqueado de novo por "tentar outra vez".
  ProgressData _withUnlocks(ProgressData data) {
    final unlocked = <String>{
      for (final card in starterCards) card.id,
      ...data.unlockedCards,
    };
    for (final stage in unlockStages) {
      if (!_stageCompleted(data, stage)) continue;
      for (final card in cardsUnlockedBy(stage)) {
        unlocked.add(card.id);
      }
    }
    final ordered = [
      for (final card in allCards)
        if (unlocked.contains(card.id)) card.id,
    ];
    if (ordered.length == data.unlockedCards.length &&
        ordered.every(data.unlockedCards.contains)) {
      return data;
    }
    return data.copyWith(unlockedCards: ordered);
  }

  ProgressData _withBadges(ProgressData data) {
    final earned = <String>{
      for (final id in data.badges)
        if (badgeById(id) != null) id,
    };

    if (data.battles.values.any((b) => b.attempts > 0)) {
      earned.add('primeiro-parecer');
    }
    if (data.battlesWon >= battleTotal) earned.add('mesa-limpa');
    if (_checkAllCorrect(data, 'check1')) earned.add('classificador');
    if (_checkAllCorrect(data, 'check2')) earned.add('quem-e-quem');
    if (_checkAllCorrect(data, 'check3')) earned.add('tres-testes');

    final questions = _sessionFor(data);
    final quizComplete =
        questions.isNotEmpty &&
        questions.every((q) => data.quizAnswers.containsKey(q.id));
    if (quizComplete &&
        questions.every((q) => q.isCorrect(data.quizAnswers[q.id]))) {
      earned.add('gabarito');
    }

    if (data.totalRefutations >= 10) earned.add('refutador');
    if (data.unlockedCards.length >= allCards.length) {
      earned.add('colecionador');
    }

    if (data.history.isNotEmpty) earned.add('jornada-concluida');
    if (data.history.length >= 2) earned.add('segunda-leitura');

    final ordered = [
      for (final badge in allBadges)
        if (earned.contains(badge.id)) badge.id,
    ];
    if (ordered.length == data.badges.length) return data;
    return data.copyWith(badges: ordered);
  }

  Future<void> _update(ProgressData next, {bool newQuizSession = false}) async {
    final visited = {...next.visited, next.currentStep}.toList();
    var prepared = _withSession(
      next.copyWith(visited: visited),
      force: newQuizSession,
    );
    prepared = _withUnlocks(prepared);
    prepared = _withBadges(prepared);
    _data = prepared;
    await _storage.save(_data);
    notifyListeners();
  }
}
