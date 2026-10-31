/// Modelos de conteúdo do OVA "Assessora do STF por um dia".
///
/// O conteúdo jurídico fica separado dos widgets: novos casos são adicionados
/// apenas em `lib/data/`, sem tocar nas telas.
library;

/// Caixa de destaque exibida abaixo de um feedback ou de uma teoria.
class InfoBox {
  const InfoBox({this.title, this.text, this.bullets = const []});

  final String? title;
  final String? text;
  final List<String> bullets;
}

/// Alternativa de um caso, com o feedback específico daquela escolha.
class Choice {
  const Choice({
    required this.id,
    required this.text,
    required this.correct,
    required this.feedback,
    this.note,
  });

  final String id;
  final String text;
  final bool correct;
  final List<String> feedback;

  /// Caixa extra (ex.: os três testes da proporcionalidade).
  final InfoBox? note;
}

/// Um caso prático (etapa "Problema" + "Interação" do motor OVA).
class CaseStudy {
  const CaseStudy({
    required this.id,
    required this.number,
    required this.title,
    required this.body,
    required this.question,
    required this.choices,
    required this.nextLabel,
    this.disclaimer,
    this.feedbackTitle,
  });

  final String id;
  final String number;
  final String title;
  final String body;
  final String question;
  final List<Choice> choices;
  final String nextLabel;

  /// Aviso de que o caso é hipotético, criado para o exercício.
  final String? disclaimer;
  final String? feedbackTitle;

  Choice? choiceById(String? id) {
    for (final c in choices) {
      if (c.id == id) return c;
    }
    return null;
  }
}

/// Linha do quadro comparativo.
class ComparisonRow {
  const ComparisonRow({
    required this.label,
    required this.left,
    required this.right,
  });

  final String label;
  final String left;
  final String right;
}

/// Quadro comparativo de duas colunas.
class ComparisonTable {
  const ComparisonTable({
    required this.leftTitle,
    required this.rightTitle,
    required this.rows,
  });

  final String leftTitle;
  final String rightTitle;
  final List<ComparisonRow> rows;
}

/// Cartão "quem disse isso".
class AuthorCard {
  const AuthorCard({required this.name, required this.text});

  final String name;
  final String text;
}

/// Tela de teoria (etapa "Conteúdo" do motor OVA).
class TheoryStep {
  const TheoryStep({
    required this.id,
    required this.title,
    required this.lead,
    required this.nextLabel,
    this.table,
    this.authors = const [],
    this.tip,
    this.origin,
  });

  final String id;
  final String title;
  final String lead;
  final String nextLabel;
  final ComparisonTable? table;
  final List<AuthorCard> authors;
  final InfoBox? tip;
  final InfoBox? origin;
}

/// Alternativa de uma questão do teste final.
class QuizChoice {
  const QuizChoice({
    required this.id,
    required this.text,
    required this.correct,
  });

  final String id;
  final String text;
  final bool correct;
}

/// Alternativa de uma questão de etapa interativa (classificar, associar...).
class CheckOption {
  const CheckOption({
    required this.id,
    required this.text,
    required this.correct,
  });

  final String id;
  final String text;
  final bool correct;
}

/// Item de uma etapa interativa: um comando com alternativas e feedback.
class CheckQuestion {
  const CheckQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.feedback,
  });

  final String id;
  final String prompt;
  final List<CheckOption> options;
  final String feedback;

  CheckOption? optionById(String? id) {
    for (final o in options) {
      if (o.id == id) return o;
    }
    return null;
  }

  bool isCorrect(String? optionId) => optionById(optionId)?.correct ?? false;
}

/// Etapa interativa em que o estudante responde vários itens e depois confere.
///
/// Serve para três mecânicas: classificar dispositivos (regra/princípio),
/// associar autores às teses e preencher os testes da proporcionalidade.
class CheckStep {
  const CheckStep({
    required this.id,
    required this.title,
    required this.lead,
    required this.questions,
    required this.nextLabel,
    this.kicker,
    this.note,
  });

  final String id;
  final String title;
  final String lead;
  final List<CheckQuestion> questions;
  final String nextLabel;
  final String? kicker;
  final InfoBox? note;
}

/// Questão do teste final (etapa "Avaliação" do motor OVA).
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.number,
    required this.statement,
    required this.choices,
    required this.feedback,
    required this.reviewTopic,
  });

  final String id;
  final int number;
  final String statement;
  final List<QuizChoice> choices;
  final String feedback;

  /// Tópico indicado no diagnóstico quando a questão é errada.
  final String reviewTopic;

  bool isCorrect(String? choiceId) {
    for (final c in choices) {
      if (c.id == choiceId) return c.correct;
    }
    return false;
  }

  QuizChoice? choiceById(String? id) {
    for (final c in choices) {
      if (c.id == id) return c;
    }
    return null;
  }
}
