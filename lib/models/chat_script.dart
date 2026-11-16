/// Uma mensagem escrita por um contato (ou por um participante do grupo).
class BotLine {
  const BotLine(this.text, {this.sender});

  final String text;
  final String? sender;
}

/// Tom da resposta escolhida, usado na gamificação (prestígio e combo).
enum AnswerStyle {
  /// Resposta técnica, bem fundamentada.
  technical,

  /// Resposta casual, sem prejuízo conceitual.
  informal,

  /// Erro conceitual.
  wrong,
}

extension AnswerStyleScore on AnswerStyle {
  /// Quanto a resposta soma (ou tira) do Prestígio no Gabinete.
  int get prestigeDelta => switch (this) {
    AnswerStyle.technical => 15,
    AnswerStyle.informal => 5,
    AnswerStyle.wrong => -10,
  };

  bool get isHit => this == AnswerStyle.technical;
  bool get isMiss => this == AnswerStyle.wrong;

  /// Emojis que os outros participantes usam para reagir à resposta.
  List<String> get reactionEmojis => switch (this) {
    AnswerStyle.technical => const <String>['❤️', '👏'],
    AnswerStyle.informal => const <String>['👀', '😂'],
    AnswerStyle.wrong => const <String>['😱', '💀'],
  };

  String get feedbackLabel => switch (this) {
    AnswerStyle.technical => 'resposta técnica',
    AnswerStyle.informal => 'resposta informal',
    AnswerStyle.wrong => 'erro conceitual',
  };
}

/// Resposta fixa que o jogador pode escolher.
class ChatChoice {
  const ChatChoice({
    required this.id,
    required this.label,
    this.react = const <BotLine>[],
    this.nextNodeId,
    this.isCorrect,
    this.style,
    this.prestigeDelta,
  });

  final String id;

  /// Texto enviado pelo jogador.
  final String label;

  /// Reação imediata a esta escolha.
  final List<BotLine> react;

  /// Próximo nó da conversa. `null` encerra a fase.
  final String? nextNodeId;

  /// Usado apenas no teste final: `null` em escolhas narrativas.
  final bool? isCorrect;

  /// Tom declarado da resposta. Quando ausente, o teste final usa o gabarito
  /// (`isCorrect`) e as escolhas narrativas contam como técnicas.
  final AnswerStyle? style;

  /// Penalidade/bônus de prestígio específico desta escolha. Sobrepõe o valor
  /// padrão do [style] (usado, por exemplo, na exoneração do Ministro).
  final int? prestigeDelta;

  AnswerStyle get answerStyle {
    if (style != null) return style!;
    if (isCorrect == false) return AnswerStyle.wrong;
    return AnswerStyle.technical;
  }
}

/// Desafio de classificação com tempo limitado, exibido como uma carta
/// jurídica no meio da conversa.
class CardChallenge {
  const CardChallenge({
    required this.situation,
    required this.timeoutLine,
    this.timeoutNextNodeId,
    this.index = 1,
    this.total = 1,
    this.seconds = 10,
  });

  /// Texto da situação impresso na carta.
  final String situation;

  /// Mensagem do contato quando o tempo acaba.
  final BotLine timeoutLine;

  /// Nó para onde ir após o tempo esgotar. Se nulo, segue o próximo nó da
  /// primeira escolha disponível.
  final String? timeoutNextNodeId;

  final int index;
  final int total;
  final int seconds;
}

/// Balão individual do rascunho que o jogador precisa revisar.
class DraftStatement {
  const DraftStatement({
    required this.id,
    required this.text,
    required this.isFalse,
    this.sender,
  });

  final String id;
  final String text;
  final bool isFalse;
  final String? sender;
}

/// Jogo de revisão: o jogador marca os balões falsos do rascunho.
class InspectionChallenge {
  const InspectionChallenge({
    required this.statements,
    required this.successLines,
    this.correctPrestige = 10,
  });

  final List<DraftStatement> statements;

  /// Mensagens enviadas quando todos os balões falsos foram marcados.
  final List<BotLine> successLines;

  final int correctPrestige;

  int get falseCount =>
      statements.where((DraftStatement s) => s.isFalse).length;
}

/// Trecho de conversa: mensagens recebidas e as respostas disponíveis.
class ChatNode {
  const ChatNode({
    required this.id,
    required this.lines,
    required this.choices,
    this.card,
    this.inspection,
  });

  final String id;
  final List<BotLine> lines;
  final List<ChatChoice> choices;

  /// Quando presente, o nó é um minigame de cartas com cronômetro.
  final CardChallenge? card;

  /// Quando presente, o nó é o jogo de marcar balões falsos no rascunho.
  final InspectionChallenge? inspection;
}

class ChatScript {
  const ChatScript({
    required this.contactId,
    required this.startNodeId,
    required this.nodes,
    required this.freeTextReplies,
    this.praiseLines = const <BotLine>[],
    this.isQuiz = false,
    this.isRiskChat = false,
  });

  final String contactId;
  final String startNodeId;
  final Map<String, ChatNode> nodes;

  /// Respostas usadas quando o jogador digita em vez de escolher.
  /// Hoje são fixas; no futuro virão do modelo local.
  final List<BotLine> freeTextReplies;

  /// Elogios dos personagens após um acerto no teste final. São usados em
  /// rodízio, um por acerto.
  final List<BotLine> praiseLines;

  /// Indica que a fase é o teste final e deve gerar um diagnóstico.
  final bool isQuiz;

  /// Conversa de alto risco: os erros custam café e podem exonerar o jogador.
  final bool isRiskChat;

  ChatNode get startNode => nodes[startNodeId]!;

  ChatNode? nodeById(String? id) => id == null ? null : nodes[id];
}
