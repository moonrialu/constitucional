import '../models/chat_message.dart';
import '../models/chat_script.dart';
import '../models/contact.dart';

/// Tudo que uma estratégia de resposta precisa para responder ao jogador.
class ReplyContext {
  const ReplyContext({
    required this.contact,
    required this.script,
    required this.playerText,
    required this.recentMessages,
    required this.currentNodeId,
    required this.attempt,
  });

  final Contact contact;
  final ChatScript script;
  final String playerText;
  final List<ChatMessage> recentMessages;
  final String? currentNodeId;

  /// Quantas mensagens livres já foram enviadas nesta conversa.
  final int attempt;
}

/// Ponto de extensão para o futuro modelo local.
///
/// A UI só conhece esta interface. Hoje a implementação é roteirizada;
/// amanhã basta injetar uma implementação que converse com o modelo,
/// sem mexer em telas, estado ou widgets.
abstract interface class ReplyStrategy {
  Future<List<BotLine>> reply(ReplyContext context);
}

/// Respostas fixas enquanto o modelo local não existe.
///
/// Texto livre nunca avança a fase: as escolhas continuam sendo o
/// caminho principal do jogo.
class ScriptedReplyStrategy implements ReplyStrategy {
  const ScriptedReplyStrategy();

  @override
  Future<List<BotLine>> reply(ReplyContext context) async {
    final List<BotLine> options = context.script.freeTextReplies;
    if (options.isEmpty) {
      return <BotLine>[
        const BotLine('Melhor escolher uma das respostas ali embaixo.'),
      ];
    }
    return <BotLine>[options[context.attempt % options.length]];
  }
}
