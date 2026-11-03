import 'package:flutter/foundation.dart';

import '../data/mutation_content.dart';
import '../models/mutation.dart';
import '../services/mutation_store.dart';

/// Conduz as 16 telas do OVA de mutação, as respostas e o diagnóstico.
class MutationController extends ChangeNotifier {
  MutationController(this._storage, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final MutationStorage _storage;
  final DateTime Function() _clock;

  MutationProgress _data = const MutationProgress();
  bool _ready = false;

  MutationProgress get data => _data;
  bool get ready => _ready;

  String get userName => _data.userName;

  bool get hasName => _data.userName.trim().isNotEmpty;

  /// Nome usado nos diálogos; cai para uma saudação neutra quando vazio.
  String get displayName => hasName ? _data.userName : 'assessor(a)';

  MutationStep get currentStep =>
      mutationFlow[_data.stepIndex.clamp(0, mutationFlow.length - 1)];

  MutationCase? get currentCase {
    final id = currentStep.caseId;
    if (id == null) return null;
    return mutationCaseById(id);
  }

  MutationTheory? get currentTheory {
    final id = currentStep.caseId;
    if (id == null) return null;
    return mutationTheoryById(id);
  }

  int get stepIndex => _data.stepIndex;
  int get stepCount => mutationFlow.length;

  /// 1-based, para o rótulo "Tela X de 16".
  int get stepNumber => _data.stepIndex + 1;

  bool get isAtStart => _data.stepIndex <= 0;
  bool get isAtEnd => _data.stepIndex >= mutationFlow.length - 1;

  double get progress =>
      (_data.stepIndex / (mutationFlow.length - 1)).clamp(0, 1).toDouble();

  bool get hasProgress => _data.startedAt != null || _data.hasAnswers;

  bool get isFinished => _data.finishedAt != null;

  DateTime? get startedAt => _data.startedAt;

  Duration get elapsed {
    final start = _data.startedAt;
    if (start == null) return Duration.zero;
    return (_data.finishedAt ?? _clock()).difference(start);
  }

  // ------------------------------------------------------------- respostas

  String? caseAnswer(String caseId) => _data.caseAnswers[caseId];

  bool isCaseAnswered(String caseId) => _data.caseAnswers[caseId] != null;

  bool isCaseCorrect(String caseId) {
    final caseStudy = mutationCaseById(caseId);
    final answer = caseAnswer(caseId);
    if (caseStudy == null || answer == null) return false;
    return caseStudy.choiceById(answer)?.correct ?? false;
  }

  static String checkKey(String checkId, String itemId) => '$checkId/$itemId';

  String? checkAnswer(String checkId, String itemId) =>
      _data.checkAnswers[checkKey(checkId, itemId)];

  bool isCheckComplete(MutationCheck check) =>
      check.items.every((item) => checkAnswer(check.id, item.id) != null);

  int checkCorrectCount(MutationCheck check) => check.items
      .where((item) => checkAnswer(check.id, item.id) == item.correct)
      .length;

  bool isCheckItemCorrect(MutationCheckItem item) =>
      checkAnswer(mutationCheck.id, item.id) == item.correct;

  String? quizAnswer(String questionId) => _data.quizAnswers[questionId];

  bool isQuizAnswered(String questionId) =>
      _data.quizAnswers[questionId] != null;

  int get quizCorrect => mutationQuiz
      .where((question) => question.isCorrect(quizAnswer(question.id)))
      .length;

  int get quizTotal => mutationQuiz.length;

  bool get isQuizComplete =>
      mutationQuiz.every((question) => isQuizAnswered(question.id));

  List<MutationQuizQuestion> get wrongQuizQuestions => mutationQuiz
      .where(
        (question) =>
            isQuizAnswered(question.id) &&
            !question.isCorrect(quizAnswer(question.id)),
      )
      .toList();

  DiagnosisBand get diagnosisBand {
    final score = quizCorrect;
    return mutationDiagnosisBands.firstWhere(
      (band) => band.contains(score),
      orElse: () => mutationDiagnosisBands.last,
    );
  }

  // --------------------------------------------------------------- ciclo

  Future<void> load() async {
    final loaded = await _storage.load();
    if (loaded != null) {
      _data = loaded.stepIndex >= mutationFlow.length
          ? loaded.copyWith(stepIndex: 0)
          : loaded;
      if (_data.version != MutationProgress.currentVersion) {
        _data = _data.copyWith(version: MutationProgress.currentVersion);
        await _storage.save(_data);
      }
    }
    _ready = true;
    notifyListeners();
  }

  /// Guarda o nome informado no onboarding, sem iniciar a jornada.
  Future<void> setUserName(String name) async {
    final clean = name.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (clean.isEmpty) return;
    await _update(
      _data.copyWith(userName: clean, version: MutationProgress.currentVersion),
    );
  }

  /// Inicia do zero, na tela de objetivos (a capa fica no app).
  Future<void> startJourney() async {
    await _update(
      MutationProgress(
        userName: _data.userName,
        stepIndex: 1,
        startedAt: _clock(),
        caseAnswers: const {},
        checkAnswers: const {},
        quizAnswers: const {},
      ),
    );
  }

  Future<void> continueJourney() async {
    if (_data.stepIndex <= 0) {
      await startJourney();
    }
  }

  Future<void> next() async {
    if (_data.stepIndex >= mutationFlow.length - 1) return;
    await _update(_data.copyWith(stepIndex: _data.stepIndex + 1));
  }

  Future<void> previous() async {
    if (_data.stepIndex <= 0) return;
    // Não deixa a navegação pular de um feedback para um caso sem resposta.
    final target = _data.stepIndex - 1;
    await _update(_data.copyWith(stepIndex: target));
  }

  Future<void> goToStep(String stepId) async {
    final index = mutationFlow.indexWhere((step) => step.id == stepId);
    if (index < 0) return;
    await _update(_data.copyWith(stepIndex: index));
  }

  /// Refaz a jornada, mantendo a data de início nova e limpando as respostas.
  Future<void> restart() => startJourney();

  Future<void> answerCase({
    required String caseId,
    required String choiceId,
  }) async {
    final caseStudy = mutationCaseById(caseId);
    if (caseStudy?.choiceById(choiceId) == null) return;
    final answers = Map<String, String>.from(_data.caseAnswers)
      ..[caseId] = choiceId;
    await _update(_data.copyWith(caseAnswers: answers));
  }

  Future<void> answerCheck({
    required String checkId,
    required String itemId,
    required String optionId,
  }) async {
    final answers = Map<String, String>.from(_data.checkAnswers)
      ..[checkKey(checkId, itemId)] = optionId;
    await _update(_data.copyWith(checkAnswers: answers));
  }

  Future<void> clearCheckAnswers(MutationCheck check) async {
    final answers = Map<String, String>.from(_data.checkAnswers)
      ..removeWhere((key, _) => key.startsWith('${check.id}/'));
    await _update(_data.copyWith(checkAnswers: answers));
  }

  Future<void> answerQuiz({
    required String questionId,
    required String choiceId,
  }) async {
    final question = mutationQuizById(questionId);
    if (question?.choiceById(choiceId) == null) return;
    final answers = Map<String, String>.from(_data.quizAnswers)
      ..[questionId] = choiceId;
    await _update(_data.copyWith(quizAnswers: answers));
  }

  /// Fecha o teste e leva ao diagnóstico.
  Future<void> finishQuiz() async {
    if (!isQuizComplete) return;
    await _update(
      _data.copyWith(
        stepIndex: mutationFlow.indexWhere(
          (step) => step.kind == MutationStepKind.diagnosis,
        ),
        finishedAt: _clock(),
      ),
    );
  }

  Future<void> clearAll() async {
    _data = const MutationProgress();
    await _storage.clear();
    notifyListeners();
  }

  Future<void> _update(MutationProgress next) async {
    _data = next;
    await _storage.save(_data);
    notifyListeners();
  }
}
