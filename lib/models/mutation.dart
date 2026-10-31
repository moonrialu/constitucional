/// Modelos do OVA "Mutação constitucional no gabinete do STF".
///
/// O roteiro é dividido em 16 telas: primeiro a explicação (teoria e casos
/// comentados), depois a dinâmica de fixação (classificação, teste final e
/// diagnóstico). Todo o conteúdo fica em `lib/data/mutation_content.dart`.
library;

import 'content.dart' show AuthorCard, InfoBox;

/// Tipo de tela da jornada.
enum MutationStepKind {
  cover,
  objectives,
  caseStudy,
  caseFeedback,
  theory,
  check,
  checkFeedback,
  quiz,
  diagnosis,
  credits,
}

/// Uma posição da jornada, com o tipo de tela que deve ser montada.
class MutationStep {
  const MutationStep(this.id, this.kind, {this.caseId});

  final String id;
  final MutationStepKind kind;

  /// Caso ou teoria associado à tela (quando houver).
  final String? caseId;
}

/// Estrutura do roteiro: 16 telas na ordem do PDF.
const List<MutationStep> mutationFlow = [
  MutationStep('cover', MutationStepKind.cover),
  MutationStep('objectives', MutationStepKind.objectives),
  MutationStep('case1', MutationStepKind.caseStudy, caseId: 'case1'),
  MutationStep(
    'case1-feedback',
    MutationStepKind.caseFeedback,
    caseId: 'case1',
  ),
  MutationStep('theory1', MutationStepKind.theory, caseId: 'theory1'),
  MutationStep('theory2', MutationStepKind.theory, caseId: 'theory2'),
  MutationStep('check2', MutationStepKind.check, caseId: 'check2'),
  MutationStep(
    'check2-feedback',
    MutationStepKind.checkFeedback,
    caseId: 'check2',
  ),
  MutationStep('case3', MutationStepKind.caseStudy, caseId: 'case3'),
  MutationStep(
    'case3-feedback',
    MutationStepKind.caseFeedback,
    caseId: 'case3',
  ),
  MutationStep('theory3', MutationStepKind.theory, caseId: 'theory3'),
  MutationStep('case4', MutationStepKind.caseStudy, caseId: 'case4'),
  MutationStep(
    'case4-feedback',
    MutationStepKind.caseFeedback,
    caseId: 'case4',
  ),
  MutationStep('quiz', MutationStepKind.quiz),
  MutationStep('diagnosis', MutationStepKind.diagnosis),
  MutationStep('credits', MutationStepKind.credits),
];

/// Alternativa de um caso.
class MutationChoice {
  const MutationChoice({
    required this.id,
    required this.text,
    required this.correct,
    required this.feedback,
  });

  final String id;
  final String text;
  final bool correct;
  final List<String> feedback;
}

/// Linha de uma linha do tempo (ex.: julgamentos do STF).
class TimelineEntry {
  const TimelineEntry({
    required this.year,
    required this.judgment,
    required this.description,
  });

  final String year;
  final String judgment;
  final String description;
}

class MutationTimeline {
  const MutationTimeline({required this.title, required this.entries});

  final String title;
  final List<TimelineEntry> entries;
}

/// Caso prático com alternativas e feedback por alternativa.
class MutationCase {
  const MutationCase({
    required this.id,
    required this.number,
    required this.title,
    required this.body,
    required this.question,
    required this.choices,
    required this.nextLabel,
    this.disclaimer,
    this.timeline,
    this.reflection,
  });

  final String id;
  final String number;
  final String title;
  final String body;
  final String question;
  final List<MutationChoice> choices;
  final String nextLabel;

  /// Aviso de caso hipotético.
  final String? disclaimer;

  /// Linha do tempo exibida no feedback.
  final MutationTimeline? timeline;

  /// Pergunta que fica / debate real exibido no feedback.
  final InfoBox? reflection;

  MutationChoice? choiceById(String? id) {
    for (final choice in choices) {
      if (choice.id == id) return choice;
    }
    return null;
  }

  MutationChoice get correctChoice => choices.firstWhere((c) => c.correct);
}

/// Colunas e linhas de um quadro comparativo (2 ou 3 colunas).
class MutationTable {
  const MutationTable({required this.columns, required this.rows});

  final List<String> columns;
  final List<MutationTableRow> rows;
}

class MutationTableRow {
  const MutationTableRow({required this.label, required this.cells});

  final String label;
  final List<String> cells;
}

/// Cartão clicável de teoria (autores, meios da mutação, limites...).
class MutationCard {
  const MutationCard({required this.title, required this.text});

  final String title;
  final String text;
}

/// Tela de teoria.
class MutationTheory {
  const MutationTheory({
    required this.id,
    required this.kicker,
    required this.title,
    required this.lead,
    required this.nextLabel,
    this.paragraphs = const [],
    this.table,
    this.cards = const [],
    this.cardHeading,
    this.authors = const [],
    this.authorHeading,
    this.concept,
    this.tip,
  });

  final String id;
  final String kicker;
  final String title;
  final String lead;
  final String nextLabel;
  final List<String> paragraphs;
  final MutationTable? table;
  final List<MutationCard> cards;
  final String? cardHeading;
  final List<AuthorCard> authors;
  final String? authorHeading;

  /// Definição em destaque.
  final InfoBox? concept;
  final InfoBox? tip;
}

class MutationCheckOption {
  const MutationCheckOption({required this.id, required this.text});

  final String id;
  final String text;
}

class MutationCheckItem {
  const MutationCheckItem({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correct,
    required this.feedback,
  });

  final String id;
  final String prompt;
  final List<MutationCheckOption> options;
  final String correct;
  final String feedback;

  MutationCheckOption? optionById(String? id) {
    for (final option in options) {
      if (option.id == id) return option;
    }
    return null;
  }

  MutationCheckOption get correctOption =>
      options.firstWhere((o) => o.id == correct);
}

/// Etapa de classificação (Caso 2).
class MutationCheck {
  const MutationCheck({
    required this.id,
    required this.kicker,
    required this.title,
    required this.lead,
    required this.nextLabel,
    required this.items,
    this.note,
  });

  final String id;
  final String kicker;
  final String title;
  final String lead;
  final String nextLabel;
  final List<MutationCheckItem> items;
  final InfoBox? note;
}

class MutationQuizChoice {
  const MutationQuizChoice({required this.id, required this.text});

  final String id;
  final String text;
}

/// Questão do teste final.
class MutationQuizQuestion {
  const MutationQuizQuestion({
    required this.id,
    required this.number,
    required this.statement,
    required this.choices,
    required this.correct,
    required this.feedback,
    required this.reviewStepId,
    required this.reviewLabel,
  });

  final String id;
  final int number;
  final String statement;
  final List<MutationQuizChoice> choices;
  final String correct;
  final String feedback;

  /// Tela sugerida no diagnóstico quando a questão é errada.
  final String reviewStepId;
  final String reviewLabel;

  bool isCorrect(String? choiceId) => choiceId == correct;

  MutationQuizChoice? choiceById(String? id) {
    for (final choice in choices) {
      if (choice.id == id) return choice;
    }
    return null;
  }

  MutationQuizChoice get correctChoice =>
      choices.firstWhere((c) => c.id == correct);
}

/// Faixa de resultado do diagnóstico.
class DiagnosisBand {
  const DiagnosisBand({
    required this.min,
    required this.max,
    required this.title,
    required this.message,
    required this.recommendation,
  });

  final int min;
  final int max;
  final String title;
  final String message;
  final String recommendation;

  bool contains(int score) => score >= min && score <= max;
}

class CreditMember {
  const CreditMember({required this.name, required this.role});

  final String name;
  final String role;
}

/// Estado persistido da jornada de mutação.
class MutationProgress {
  const MutationProgress({
    this.version = currentVersion,
    this.stepIndex = 0,
    this.startedAt,
    this.finishedAt,
    this.caseAnswers = const {},
    this.checkAnswers = const {},
    this.quizAnswers = const {},
  });

  static const int currentVersion = 1;

  final int version;
  final int stepIndex;
  final DateTime? startedAt;
  final DateTime? finishedAt;

  /// caseId -> alternativa escolhida.
  final Map<String, String> caseAnswers;

  /// "checkId/itemId" -> alternativa escolhida.
  final Map<String, String> checkAnswers;

  /// questionId -> alternativa escolhida.
  final Map<String, String> quizAnswers;

  bool get hasAnswers =>
      caseAnswers.isNotEmpty ||
      checkAnswers.isNotEmpty ||
      quizAnswers.isNotEmpty;

  MutationProgress copyWith({
    int? version,
    int? stepIndex,
    DateTime? startedAt,
    DateTime? finishedAt,
    Map<String, String>? caseAnswers,
    Map<String, String>? checkAnswers,
    Map<String, String>? quizAnswers,
  }) {
    return MutationProgress(
      version: version ?? this.version,
      stepIndex: stepIndex ?? this.stepIndex,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      caseAnswers: caseAnswers ?? this.caseAnswers,
      checkAnswers: checkAnswers ?? this.checkAnswers,
      quizAnswers: quizAnswers ?? this.quizAnswers,
    );
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'stepIndex': stepIndex,
    'startedAt': startedAt?.toIso8601String(),
    'finishedAt': finishedAt?.toIso8601String(),
    'caseAnswers': caseAnswers,
    'checkAnswers': checkAnswers,
    'quizAnswers': quizAnswers,
  };

  factory MutationProgress.fromJson(Map<String, dynamic> json) {
    return MutationProgress(
      version: json['version'] as int? ?? 1,
      stepIndex: (json['stepIndex'] as int? ?? 0).clamp(
        0,
        mutationFlow.length - 1,
      ),
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? ''),
      finishedAt: DateTime.tryParse(json['finishedAt'] as String? ?? ''),
      caseAnswers: Map<String, String>.from(
        (json['caseAnswers'] as Map?) ?? const {},
      ),
      checkAnswers: Map<String, String>.from(
        (json['checkAnswers'] as Map?) ?? const {},
      ),
      quizAnswers: Map<String, String>.from(
        (json['quizAnswers'] as Map?) ?? const {},
      ),
    );
  }
}
