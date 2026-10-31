import 'dart:math';

import 'package:assessora_stf_cards/data/battles.dart';
import 'package:assessora_stf_cards/data/checks.dart';
import 'package:assessora_stf_cards/data/flow.dart';
import 'package:assessora_stf_cards/data/quiz.dart';
import 'package:assessora_stf_cards/engine/game_controller.dart';
import 'package:assessora_stf_cards/models/battle.dart';
import 'package:assessora_stf_cards/models/progress.dart';
import 'package:assessora_stf_cards/services/progress_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryProgressStorage storage;
  late GameController controller;

  setUp(() async {
    storage = InMemoryProgressStorage();
    controller = GameController(storage, random: Random(7));
    await controller.load();
  });

  Future<void> finishQuizCorrectly(GameController game) async {
    for (final question in game.sessionQuizQuestions) {
      final correct = question.choices.firstWhere((c) => c.correct);
      await game.answerQuiz(question, correct.id);
    }
    await game.finishQuiz();
  }

  BattleRecord record({
    bool won = true,
    int attempts = 1,
    int refutations = 2,
  }) {
    return BattleRecord(
      won: won,
      attempts: attempts,
      turns: 4,
      convictionLeft: won ? 8 : 0,
      refutations: refutations,
      cardsPlayed: 6,
      finishedAt: DateTime(2026, 10, 24),
    );
  }

  test('começa na capa sem respostas e com o baralho inicial', () {
    expect(controller.currentStepId, 'cover');
    expect(controller.hasAnswers, isFalse);
    expect(controller.data.quizIds, hasLength(GameController.quizSessionSize));
    expect(controller.unlockedCardCount, 10);
    expect(controller.isCardUnlocked('subsuncao'), isTrue);
    expect(controller.isCardUnlocked('adi-4815'), isFalse);
  });

  test('a jornada tem cinco batalhas no lugar dos casos', () {
    expect(
      journeyFlow,
      containsAll(['battle1', 'battle2', 'battle3', 'battle4', 'battle5']),
    );
    expect(
      journeyFlow.indexOf('battle1'),
      lessThan(journeyFlow.indexOf('battle2')),
    );
    expect(
      journeyFlow.indexOf('battle4'),
      lessThan(journeyFlow.indexOf('battle5')),
    );
    expect(battleConfigs, hasLength(5));
    expect(quizQuestions, hasLength(10));
  });

  test('assumir o gabinete inicia a jornada e marca o horário', () async {
    await controller.beginJourney();
    expect(controller.currentStepId, 'battle1');
    expect(controller.currentBattle?.caseId, 'case1');
    expect(controller.data.startedAt, isNotNull);

    await controller.next();
    expect(controller.currentStepId, 'battle2');
  });

  test('vencer a batalha salva o resultado e libera cartas', () async {
    await controller.beginJourney();
    await controller.next();
    await controller.beginBattleAttempt('battle1');
    expect(controller.recordForBattle('battle1')?.attempts, 1);

    await controller.completeBattle('battle1', record());

    expect(controller.battlesWon, 1);
    expect(controller.hasWonBattle('battle1'), isTrue);
    expect(controller.hasBadge('primeiro-parecer'), isTrue);
    expect(controller.isCardUnlocked('ponderacao'), isTrue);
    expect(controller.isCardUnlocked('alexy'), isTrue);
    // As recompensas da antiga etapa de classificação vêm com a batalha1.
    expect(controller.isCardUnlocked('adi-4815'), isTrue);
    expect(controller.unlockedCardCount, 20);
  });

  test('derrota conta tentativa e pode ser refeita', () async {
    await controller.beginBattleAttempt('battle1');
    await controller.completeBattle('battle1', record(won: false));

    expect(controller.battlesWon, 0);
    expect(controller.recordForBattle('battle1')?.attempts, 1);

    await controller.beginBattleAttempt('battle1');
    expect(controller.recordForBattle('battle1')?.attempts, 2);

    await controller.completeBattle('battle1', record(won: true));
    expect(controller.battlesWon, 1);
    // A vitória não se perde ao repetir a batalha.
    expect(controller.recordForBattle('battle1')?.won, isTrue);
  });

  test('progresso é restaurado após reabrir o app', () async {
    await controller.beginJourney();
    await controller.next();
    await controller.beginBattleAttempt('battle1');
    await controller.completeBattle('battle1', record());

    final reopened = GameController(storage, random: Random(99));
    await reopened.load();

    expect(reopened.currentStepId, 'battle2');
    expect(reopened.hasWonBattle('battle1'), isTrue);
    expect(reopened.isCardUnlocked('ponderacao'), isTrue);
    expect(reopened.hasBadge('primeiro-parecer'), isTrue);
  });

  test('vencer a batalha libera as cartas da etapa interativa', () async {
    await controller.beginBattleAttempt('battle1');
    await controller.completeBattle('battle1', record());

    expect(controller.isCardUnlocked('adi-4815'), isTrue);
    expect(controller.isCardUnlocked('liberdade-expressao'), isTrue);

    final check1 = checkStepById('check1')!;

    for (final question in check1.questions) {
      final correct = question.options.firstWhere((o) => o.correct);
      await controller.answerCheck(check1, question, correct.id);
    }

    expect(controller.isCheckComplete(check1), isTrue);
    expect(controller.checkCorrectCount(check1), check1.questions.length);
    expect(controller.hasBadge('classificador'), isTrue);

    await controller.clearCheckAnswers(check1);

    expect(controller.isCheckComplete(check1), isFalse);
    expect(controller.answerForCheck('check1', 'c1-1'), isNull);
    // A coleção é cumulativa: tentar de novo não bloqueia as cartas.
    expect(controller.isCardUnlocked('adi-4815'), isTrue);
  });

  test('vencer a batalha2 libera as cartas de mutação', () async {
    expect(controller.isCardUnlocked('mutacao'), isFalse);

    await controller.beginBattleAttempt('battle2');
    await controller.completeBattle('battle2', record());

    expect(controller.isCardUnlocked('mutacao'), isTrue);
    expect(controller.isCardUnlocked('mutacao-limite'), isTrue);
  });

  test('teste final usa 6 questões sorteadas e pontua a sessão', () async {
    expect(controller.sessionQuizQuestions, hasLength(6));
    expect(
      controller.sessionQuizQuestions.map((q) => q.id).toSet(),
      hasLength(6),
    );

    // A carta de recompensa do teste final é liberada com a batalha5.
    await controller.beginBattleAttempt('battle5');
    await controller.completeBattle('battle5', record());
    await finishQuizCorrectly(controller);

    expect(controller.quizScore, 6);
    expect(controller.currentStepId, 'diagnosis');
    expect(controller.data.history, hasLength(1));
    expect(controller.data.history.first.quizScore, 6);
    expect(controller.data.history.first.quizTotal, 6);
    expect(controller.hasBadge('gabarito'), isTrue);
    expect(controller.isCardUnlocked('gabarito'), isTrue);
  });

  test('diagnóstico aponta as questões erradas da sessão', () async {
    for (final question in controller.sessionQuizQuestions) {
      final wrong = question.choices.firstWhere((c) => !c.correct);
      await controller.answerQuiz(question, wrong.id);
    }
    await controller.finishQuiz();

    expect(controller.quizScore, 0);
    expect(controller.wrongQuestions, hasLength(6));
  });

  test('não fecha o teste com questões da sessão em branco', () async {
    final first = controller.sessionQuizQuestions.first;
    await controller.answerQuiz(first, first.choices.first.id);

    await controller.finishQuiz();

    expect(controller.currentStepId, 'cover');
    expect(controller.data.history, isEmpty);
  });

  test('sorteio das questões é mantido ao reabrir o app', () async {
    final ids = controller.data.quizIds;
    expect(ids, hasLength(6));

    final reopened = GameController(storage, random: Random(123));
    await reopened.load();

    expect(reopened.data.quizIds, ids);
  });

  test('save antigo ganha os campos novos ao carregar', () async {
    await storage.save(const ProgressData(version: 1, currentStep: 'cover'));

    final migrated = GameController(storage, random: Random(3));
    await migrated.load();

    expect(migrated.currentStepId, 'cover');
    expect(migrated.data.quizIds, hasLength(6));
    expect(migrated.data.battles, isEmpty);
    expect(migrated.unlockedCardCount, 10);
    expect(migrated.data.version, ProgressData.currentVersion);
  });

  test('medalhas e coleção persistem ao refazer a jornada', () async {
    await controller.beginBattleAttempt('battle1');
    await controller.completeBattle('battle1', record());
    expect(controller.hasBadge('primeiro-parecer'), isTrue);
    expect(controller.isCardUnlocked('ponderacao'), isTrue);

    await controller.restart();

    expect(controller.data.battles, isEmpty);
    expect(controller.hasBadge('primeiro-parecer'), isTrue);
    expect(controller.isCardUnlocked('ponderacao'), isTrue);
    expect(controller.data.quizIds, hasLength(6));
  });

  test('refazer a jornada limpa respostas e mantém o histórico', () async {
    await finishQuizCorrectly(controller);
    expect(controller.data.history, hasLength(1));

    await controller.restart();

    expect(controller.currentStepId, 'battle1');
    expect(controller.data.battles, isEmpty);
    expect(controller.data.quizAnswers, isEmpty);
    expect(controller.data.checkAnswers, isEmpty);
    expect(controller.data.history, hasLength(1));
  });

  test('reset apaga tudo', () async {
    await controller.beginJourney();
    await controller.beginBattleAttempt('battle1');
    await controller.completeBattle('battle1', record());

    await controller.resetAll();

    expect(controller.currentStepId, 'cover');
    expect(controller.hasAnswers, isFalse);
    expect(controller.unlockedCardCount, 10);
    expect(await storage.load(), isNull);
  });

  test('voltar retorna à etapa anterior', () async {
    await controller.beginJourney();
    await controller.next();
    expect(controller.currentStepId, 'battle2');

    await controller.previous();
    expect(controller.currentStepId, 'battle1');

    await controller.previous();
    expect(controller.currentStepId, 'cover');
  });

  test('voltar na capa não faz nada', () async {
    await controller.previous();
    expect(controller.currentStepId, 'cover');
  });

  test('voltar da última batalha retorna à batalha anterior', () async {
    await controller.goToStep('battle5');
    expect(controller.currentStepId, 'battle5');

    await controller.previous();

    expect(controller.currentStepId, 'battle4');
  });

  test('menu pode saltar para uma batalha', () async {
    await controller.goToStep('battle3');
    expect(controller.currentStepId, 'battle3');

    await controller.goToStep('etapa-inexistente');
    expect(controller.currentStepId, 'battle3');
  });

  test('relatório resume batalhas, refutações e medalhas', () async {
    await controller.beginBattleAttempt('battle1');
    await controller.completeBattle('battle1', record());

    final report = controller.buildReport();

    expect(report, contains('Batalhas vencidas: 1/5'));
    expect(report, contains('Objeções refutadas: 2'));
    expect(report, contains('Teste final: 0/6'));
    expect(report, contains('Medalhas'));
  });
}
