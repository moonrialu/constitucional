import 'package:assessora_stf_cards/data/mutation_content.dart';
import 'package:assessora_stf_cards/data/training_dialogue.dart';
import 'package:assessora_stf_cards/engine/mutation_controller.dart';
import 'package:assessora_stf_cards/models/mutation.dart';
import 'package:assessora_stf_cards/services/mutation_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryMutationStorage storage;
  late MutationController controller;

  setUp(() async {
    storage = InMemoryMutationStorage();
    controller = MutationController(
      storage,
      clock: () => DateTime(2026, 10, 24, 12),
    );
    await controller.load();
  });

  Future<void> answerCaseCorrectly(String caseId) async {
    final caseStudy = mutationCaseById(caseId)!;
    await controller.answerCase(
      caseId: caseId,
      choiceId: caseStudy.correctChoice.id,
    );
  }

  Future<void> answerAllQuiz({bool correct = true, int wrongFrom = 99}) async {
    for (final question in mutationQuiz) {
      final choice = correct && question.number < wrongFrom
          ? question.correct
          : question.choices.firstWhere((c) => c.id != question.correct).id;
      await controller.answerQuiz(questionId: question.id, choiceId: choice);
    }
  }

  test('a jornada tem as 16 telas do roteiro, na ordem', () {
    expect(mutationFlow, hasLength(16));
    expect(mutationFlow.first.id, 'cover');
    expect(mutationFlow.last.id, 'credits');
    expect(
      mutationFlow.map((step) => step.id),
      containsAllInOrder([
        'objectives',
        'training1',
        'training2',
        'training3',
        'case1',
        'case1-feedback',
        'check2',
        'check2-feedback',
        'case3',
        'case3-feedback',
        'case4',
        'case4-feedback',
        'quiz',
        'diagnosis',
      ]),
    );
    expect(
      mutationFlow
          .where((step) => step.kind == MutationStepKind.training)
          .map((step) => step.caseId),
      ['training1', 'training2', 'training3'],
    );
  });

  test('o treinamento apresenta os seis mentores e três atos', () {
    expect(mutationMentors, hasLength(6));
    expect(mutationMentors.map((mentor) => mentor.name), [
      'Amanda',
      'Ian',
      'Gabriel',
      'Luiza',
      'Rafael',
      'Paola',
    ]);
    expect(mutationTraining, hasLength(3));
    for (final act in mutationTraining) {
      expect(act.lines.length, greaterThan(5));
      expect(act.summaryBullets, isNotEmpty);
      expect(act.lines.any((line) => line.mentorId != null), isTrue);
      // Todos os mentores citados existem no elenco.
      for (final line in act.lines) {
        if (line.mentorId != null) {
          expect(mutationMentorById(line.mentorId!), isNotNull);
        }
      }
    }
  });

  test('o nome é guardado, normalizado e usado nos diálogos', () async {
    expect(controller.hasName, isFalse);
    expect(controller.displayName, 'assessor(a)');

    await controller.setUserName('  Ana   Luiza  ');

    expect(controller.userName, 'Ana Luiza');
    expect(controller.hasName, isTrue);
    expect(controller.displayName, 'Ana Luiza');

    // Nome vazio não apaga o nome já salvo.
    await controller.setUserName('   ');
    expect(controller.userName, 'Ana Luiza');
  });

  test('iniciar e refazer a jornada preservam o nome', () async {
    await controller.setUserName('Ana');
    await controller.startJourney();
    expect(controller.userName, 'Ana');
    expect(controller.currentStep.id, 'objectives');

    await controller.restart();
    expect(controller.userName, 'Ana');
    expect(controller.currentStep.id, 'objectives');
  });

  test('o nome e a versão são restaurados ao reabrir o app', () async {
    await controller.setUserName('Ana');
    await controller.startJourney();

    final reopened = MutationController(storage);
    await reopened.load();

    expect(reopened.userName, 'Ana');
    expect(reopened.data.version, MutationProgress.currentVersion);
    expect(reopened.hasName, isTrue);
  });

  test('save antigo (versão 1) é migrado ao carregar', () async {
    await storage.save(
      const MutationProgress(version: 1, stepIndex: 3, userName: 'Beto'),
    );

    final reopened = MutationController(storage);
    await reopened.load();

    expect(reopened.data.version, MutationProgress.currentVersion);
    expect(reopened.userName, 'Beto');
    expect(reopened.currentStep.id, mutationFlow[3].id);
  });

  test('começa na capa e inicia na tela de objetivos', () async {
    expect(controller.currentStep.id, 'cover');
    expect(controller.hasProgress, isFalse);

    await controller.startJourney();

    expect(controller.currentStep.id, 'objectives');
    expect(controller.stepNumber, 2);
    expect(controller.hasProgress, isTrue);
    expect(controller.data.startedAt, isNotNull);
  });

  test('avançar e voltar percorre as telas sem perder a ordem', () async {
    await controller.startJourney();
    await controller.next();
    expect(controller.currentStep.id, 'training1');

    await controller.next();
    expect(controller.currentStep.id, 'training2');

    await controller.previous();
    expect(controller.currentStep.id, 'training1');

    await controller.goToStep('case1');
    await controller.next();
    expect(controller.currentStep.id, 'case1-feedback');

    await controller.previous();
    expect(controller.currentStep.id, 'case1');
  });

  test('resposta do caso fica salva e é usada no feedback', () async {
    await controller.startJourney();
    await controller.goToStep('case1');

    await controller.answerCase(caseId: 'case1', choiceId: 'B');

    expect(controller.caseAnswer('case1'), 'B');
    expect(controller.isCaseCorrect('case1'), isTrue);
    expect(controller.isCaseAnswered('case1'), isTrue);
  });

  test('classificação guarda as três respostas e conta os acertos', () async {
    await controller.startJourney();
    await controller.goToStep('check2');

    for (final item in mutationCheck.items) {
      await controller.answerCheck(
        checkId: mutationCheck.id,
        itemId: item.id,
        optionId: item.correct,
      );
    }

    expect(controller.isCheckComplete(mutationCheck), isTrue);
    expect(controller.checkCorrectCount(mutationCheck), 3);
  });

  test('teste final só fecha com as cinco respostas', () async {
    await controller.startJourney();
    await controller.goToStep('quiz');

    await controller.finishQuiz();
    expect(controller.currentStep.id, 'quiz');

    await answerAllQuiz();
    await controller.finishQuiz();

    expect(controller.currentStep.id, 'diagnosis');
    expect(controller.quizCorrect, 5);
    expect(controller.isFinished, isTrue);
    expect(controller.diagnosisBand.title, 'Gabinete aprovado!');
  });

  test('diagnóstico indica as questões erradas e a tela de revisão', () async {
    await controller.startJourney();
    await answerAllQuiz(correct: false);
    await controller.finishQuiz();

    expect(controller.quizCorrect, 0);
    expect(controller.wrongQuizQuestions, hasLength(5));
    expect(controller.diagnosisBand.min, 0);
    for (final question in controller.wrongQuizQuestions) {
      expect(question.reviewStepId, isNotEmpty);
      expect(question.reviewLabel, isNotEmpty);
    }
  });

  test('progresso e respostas são restaurados ao reabrir o app', () async {
    await controller.startJourney();
    await controller.goToStep('case1');
    await answerCaseCorrectly('case1');
    await controller.next();

    final reopened = MutationController(storage);
    await reopened.load();

    expect(reopened.currentStep.id, 'case1-feedback');
    expect(reopened.caseAnswer('case1'), 'B');
    expect(reopened.isCaseCorrect('case1'), isTrue);
  });

  test('refazer a jornada limpa respostas e volta aos objetivos', () async {
    await controller.startJourney();
    await answerCaseCorrectly('case1');
    await answerAllQuiz();
    await controller.finishQuiz();

    await controller.restart();

    expect(controller.currentStep.id, 'objectives');
    expect(controller.data.caseAnswers, isEmpty);
    expect(controller.data.quizAnswers, isEmpty);
    expect(controller.quizCorrect, 0);
    expect(controller.isFinished, isFalse);
  });

  test('limpar tudo apaga o save', () async {
    await controller.startJourney();
    await answerCaseCorrectly('case1');

    await controller.clearAll();

    expect(controller.currentStep.id, 'cover');
    expect(controller.hasProgress, isFalse);
    expect(await storage.load(), isNull);
  });

  test('conteúdo dos casos e do teste segue o roteiro', () {
    expect(mutationCases, hasLength(3));
    expect(mutationTheory, hasLength(3));
    expect(mutationCheck.items, hasLength(3));
    expect(mutationQuiz, hasLength(5));
    expect(mutationDiagnosisBands, hasLength(3));

    for (final caseStudy in mutationCases) {
      expect(caseStudy.choices.where((choice) => choice.correct), hasLength(1));
    }
    for (final question in mutationQuiz) {
      expect(
        question.choices.map((choice) => choice.id),
        contains(question.correct),
      );
    }
  });
}
