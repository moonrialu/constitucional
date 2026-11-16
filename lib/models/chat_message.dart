enum MessageAuthor { player, contact, system }

/// Emoji que um personagem deixou como reação a uma mensagem do jogador.
class MessageReaction {
  const MessageReaction({required this.emoji, required this.reactorName});

  final String emoji;
  final String reactorName;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'e': emoji,
    'r': reactorName,
  };

  static MessageReaction? fromJson(Map<String, dynamic> json) {
    final Object? emoji = json['e'];
    final Object? reactor = json['r'];
    if (emoji is! String || reactor is! String) return null;
    if (emoji.isEmpty || reactor.isEmpty) return null;
    return MessageReaction(emoji: emoji, reactorName: reactor);
  }
}

/// Estado de um balão do rascunho no jogo de revisão da Dra. Helena.
enum StatementMark { none, falseMarked, trueConfirmed }

/// Balão de rascunho que pode ser marcado como falso no chat.
class StatementMessage {
  const StatementMessage({
    required this.text,
    required this.isFalse,
    this.sender,
  });

  final String text;
  final bool isFalse;
  final String? sender;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.author,
    required this.text,
    this.senderName,
    this.reactions = const <MessageReaction>[],
    this.statementId,
    this.statementIsFalse,
    this.statementMark = StatementMark.none,
  });

  final String id;
  final MessageAuthor author;
  final String text;

  /// Nome de quem enviou, usado em conversas de grupo.
  final String? senderName;

  /// Emojis deixados pelos outros participantes na mensagem do jogador.
  final List<MessageReaction> reactions;

  /// Identifica um balão do rascunho revisável (jogo da Dra. Helena).
  final String? statementId;

  /// Gabarito do balão: `true` quando é um erro conceitual.
  final bool? statementIsFalse;

  /// Marca deixada pelo jogador no balão do rascunho.
  final StatementMark statementMark;

  bool get isPlayer => author == MessageAuthor.player;
  bool get isSystem => author == MessageAuthor.system;

  bool get hasReactions => reactions.isNotEmpty;

  bool get isStatement => statementId != null;

  ChatMessage copyWith({
    List<MessageReaction>? reactions,
    StatementMark? statementMark,
  }) {
    return ChatMessage(
      id: id,
      author: author,
      text: text,
      senderName: senderName,
      reactions: reactions ?? this.reactions,
      statementId: statementId,
      statementIsFalse: statementIsFalse,
      statementMark: statementMark ?? this.statementMark,
    );
  }
}
