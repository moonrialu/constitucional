import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../models/chat_script.dart';
import '../models/contact.dart';
import '../models/game_stats.dart';
import '../services/progress_store.dart';
import '../services/reply_strategy.dart';

/// Estado de uma conversa aberta.
class ChatSession {
  final List<ChatMessage> messages = <ChatMessage>[];
  String? currentNodeId;
  bool started = false;
  bool busy = false;
  bool finished = false;
  int freeTextCount = 0;
  int correctAnswers = 0;
  int answeredQuestions = 0;

  /// Entrou no minigame de cartas (mantém os cafés visíveis entre cartas).
  bool cardGameStarted = false;

  /// Entrou no jogo de revisão do rascunho (Dra. Helena).
  bool inspectionStarted = false;

  /// Foi exonerado pelo Ministro (bad ending).
  bool exonerated = false;
}

/// Resultado do fim de uma fase, usado pela tela de chat.
class StageCompletion {
  const StageCompletion({
    required this.contact,
    required this.nextContact,
    required this.isFinale,
    required this.isReplay,
    this.isQuiz = false,
    this.correctAnswers = 0,
    this.answeredQuestions = 0,
  });

  final Contact contact;
  final Contact? nextContact;
  final bool isFinale;
  final bool isReplay;
  final bool isQuiz;
  final int correctAnswers;
  final int answeredQuestions;

  /// A banca encerra o treinamento e gera a efetivação.
  bool get isCareerFinale => contact.id == 'banca' && !isReplay;
}

/// Cérebro do jogo: progresso, conversas e desbloqueio das fases.
class GameController extends ChangeNotifier {
  GameController({
    required this.store,
    required List<Contact> contacts,
    required this.scripts,
    this.replyStrategy = const ScriptedReplyStrategy(),
  }) : contacts = List<Contact>.unmodifiable(
         <Contact>[...contacts]
           ..sort((Contact a, Contact b) => a.order.compareTo(b.order)),
       );

  static const Duration _reactionDelay = Duration(milliseconds: 450);
  static const Duration _typingDelay = Duration(milliseconds: 850);
  static const Duration _lineDelay = Duration(milliseconds: 650);

  final ProgressStore store;
  final Map<String, ChatScript> scripts;
  final ReplyStrategy replyStrategy;

  final List<Contact> contacts;
  final Set<String> _completed = <String>{};
  final Map<String, ChatSession> _sessions = <String, ChatSession>{};
  GameStats _stats = const GameStats();
  bool _gameFinished = false;

  GameStats get stats => _stats;
  bool get isOutOfCoffee => _stats.isOutOfCoffee;

  /// O treinamento terminou com a efetivação no caso da Profa. Lúcia.
  bool get isGameFinished => _gameFinished;

  /// Consulta permanente (Sala de Dúvidas), usada pelo modal de café.
  Contact? get referenceContact {
    for (final Contact contact in contacts) {
      if (contact.isReference) return contact;
    }
    return null;
  }

  // Prefixo único por execução para que mensagens restauradas do disco e
  // mensagens novas nunca colidam no `ListView`.
  final String _messagePrefix = DateTime.now().microsecondsSinceEpoch
      .toRadixString(36);
  int _messageSeq = 0;

  int get totalStages =>
      contacts.where((Contact contact) => !contact.isReference).length;
  int get completedCount => contacts
      .where(
        (Contact contact) =>
            !contact.isReference && _completed.contains(contact.id),
      )
      .length;

  Future<void> load() async {
    _stats = store.loadStats();
    _gameFinished = store.loadGameFinished();
    _completed
      ..clear()
      ..addAll(
        store.loadCompleted().where((String id) => scripts.containsKey(id)),
      );

    _sessions.clear();
    final Map<String, StoredSession> saved = store.loadSessions();
    final Set<String> knownContacts = contacts
        .map((Contact contact) => contact.id)
        .toSet();
    saved.forEach((String id, StoredSession stored) {
      if (!knownContacts.contains(id)) return;
      final ChatScript? script = scripts[id];
      if (script == null) return;

      final ChatSession session = ChatSession();
      session.messages.addAll(stored.messages);
      session.currentNodeId = stored.currentNodeId;
      session.started = stored.started;
      session.finished = stored.finished;
      session.freeTextCount = stored.freeTextCount;
      session.correctAnswers = stored.correctAnswers;
      session.answeredQuestions = stored.answeredQuestions;
      session.exonerated = stored.exonerated;

      // Se o roteiro mudou e o nó salvo não existe mais, recomeça com
      // segurança em vez de abrir uma conversa quebrada.
      if (!session.finished && script.nodeById(session.currentNodeId) == null) {
        session
          ..messages.clear()
          ..currentNodeId = null
          ..started = false
          ..freeTextCount = 0
          ..correctAnswers = 0
          ..answeredQuestions = 0;
      }

      if (session.started && !session.finished) {
        _sessions[id] = session;
      }
    });

    notifyListeners();
  }

  bool isCompleted(Contact contact) => _completed.contains(contact.id);

  /// O chat está travado pelo decreto de exoneração?
  bool isExonerated(Contact contact) =>
      _sessions[contact.id]?.exonerated ?? false;

  /// Uma fase começou, ainda não terminou e não está marcada como concluída.
  bool isInProgress(Contact contact) {
    if (contact.isReference) return false;
    final ChatSession? session = _sessions[contact.id];
    return session != null &&
        session.started &&
        !session.finished &&
        !_completed.contains(contact.id);
  }

  bool isUnlocked(Contact contact) {
    if (contact.isReference) return true;
    final String? previous = contact.unlocksAfter;
    return previous == null || _completed.contains(previous);
  }

  Contact? previousContact(Contact contact) {
    for (final Contact c in contacts) {
      if (c.id == contact.unlocksAfter) return c;
    }
    return null;
  }

  ChatScript scriptFor(Contact contact) => scripts[contact.id]!;

  ChatSession sessionFor(Contact contact) =>
      _sessions.putIfAbsent(contact.id, ChatSession.new);

  String previewFor(Contact contact) {
    final ChatSession? session = _sessions[contact.id];
    if (session == null || session.messages.isEmpty) return contact.preview;
    final ChatMessage last = session.messages.last;
    if (last.isPlayer) return 'Você: ${last.text}';
    if (last.senderName != null) return '${last.senderName}: ${last.text}';
    return last.text;
  }

  /// Carta ativa do minigame, ou `null` fora dele.
  CardChallenge? cardFor(Contact contact) {
    final ChatSession? session = _sessions[contact.id];
    if (session == null || session.busy || session.finished) return null;
    if (!session.started) return null;
    return scripts[contact.id]?.nodeById(session.currentNodeId)?.card;
  }

  /// O contato está em um jogo de respostas (teste final ou cartas com tempo)?
  /// É quando as xícaras de café entram em cena.
  bool isAnswerGame(Contact contact) {
    final ChatScript? script = scripts[contact.id];
    if (script == null) return false;
    if (script.isQuiz || script.isRiskChat) return true;
    final ChatSession? session = _sessions[contact.id];
    if (session == null || session.finished) return false;
    return session.cardGameStarted ||
        session.inspectionStarted ||
        script.nodeById(session.currentNodeId)?.card != null ||
        script.nodeById(session.currentNodeId)?.inspection != null;
  }

  List<ChatChoice> choicesFor(Contact contact) {
    final ChatSession session = sessionFor(contact);
    if (!session.started || session.busy || session.finished) {
      return const <ChatChoice>[];
    }
    if (session.exonerated) return const <ChatChoice>[];
    final ChatScript? script = scripts[contact.id];
    // Sem cafés, o teste e a conversa de alto risco ficam travados.
    if ((script?.isQuiz == true || script?.isRiskChat == true) &&
        isOutOfCoffee) {
      return const <ChatChoice>[];
    }
    return script?.nodeById(session.currentNodeId)?.choices ??
        const <ChatChoice>[];
  }

  /// Inicia a fase na primeira vez que a conversa é aberta.
  /// Fases já concluídas podem ser revisitadas desde o começo.
  Future<void> openChat(Contact contact) async {
    final ChatSession session = sessionFor(contact);
    if (session.started && !session.finished) {
      // Revisão interrompida bem no último acerto: conclui ao reabrir.
      final ChatNode? node = scriptFor(contact).nodeById(session.currentNodeId);
      final InspectionChallenge? inspection = node?.inspection;
      if (inspection != null &&
          !session.busy &&
          !session.messages.any(
            (ChatMessage m) =>
                m.statementIsFalse == true &&
                m.statementMark == StatementMark.none,
          )) {
        unawaited(_completeInspection(contact, session, inspection));
      }
      return;
    }

    if (session.finished) {
      session.messages.clear();
      session.currentNodeId = null;
      session.finished = false;
      session.freeTextCount = 0;
      session.correctAnswers = 0;
      session.answeredQuestions = 0;
      session.cardGameStarted = false;
      session.inspectionStarted = false;
      session.exonerated = false;
    }

    session.started = true;
    session.busy = true;
    notifyListeners();
    await Future<void>.delayed(_reactionDelay);
    await _playNode(contact, session, scriptFor(contact).startNode);
  }

  /// Envia uma resposta fixa. Retorna algo apenas quando a fase termina.
  Future<StageCompletion?> choose(Contact contact, ChatChoice choice) async {
    final ChatSession session = sessionFor(contact);
    if (session.busy || session.finished) return null;

    _appendPlayer(session, choice.label);
    final int playerIndex = session.messages.length - 1;
    session.busy = true;
    if (choice.isCorrect != null) {
      session.answeredQuestions++;
      if (choice.isCorrect!) session.correctAnswers++;
    }

    // A Sala de Dúvidas é consulta: não altera prestígio nem combo.
    if (!contact.isReference) {
      _applyChoiceScore(
        choice.answerStyle,
        quizError: choice.isCorrect == false,
        prestigeDelta: choice.prestigeDelta,
      );
      await store.saveStats(_stats);
    }

    // No chat do Ministro, prestígio zerado encerra o expediente na hora.
    if (!contact.isReference &&
        contact.id == 'ministro' &&
        _stats.prestige <= 0) {
      session
        ..exonerated = true
        ..busy = false;
      notifyListeners();
      await _persistSessions();
      return null;
    }

    notifyListeners();
    unawaited(
      _scheduleReactions(contact, session, playerIndex, choice.answerStyle),
    );
    await Future<void>.delayed(_reactionDelay);

    for (final BotLine line in choice.react) {
      _appendBot(contact, session, line);
      notifyListeners();
      await Future<void>.delayed(_lineDelay);
    }

    final ChatScript script = scriptFor(contact);
    if (script.isQuiz &&
        choice.isCorrect == true &&
        script.praiseLines.isNotEmpty) {
      final int index =
          (session.correctAnswers - 1) % script.praiseLines.length;
      _appendBot(contact, session, script.praiseLines[index]);
      notifyListeners();
      await Future<void>.delayed(_lineDelay);
    }

    final ChatNode? nextNode = script.nodeById(choice.nextNodeId);
    if (nextNode != null) {
      await _playNode(contact, session, nextNode);
      return null;
    }
    return _finish(contact, session);
  }

  /// Tempo esgotado em uma carta: perde café e prestígio, Bruno explica o
  /// erro e a conversa segue para a próxima carta.
  Future<StageCompletion?> timeoutCard(Contact contact) async {
    final ChatSession session = sessionFor(contact);
    if (session.busy || session.finished || !session.started) return null;

    final ChatScript script = scriptFor(contact);
    final ChatNode? node = script.nodeById(session.currentNodeId);
    final CardChallenge? card = node?.card;
    if (node == null || card == null) return null;

    session.busy = true;
    session.answeredQuestions++;
    _applyChoiceScore(AnswerStyle.wrong, quizError: true);
    await store.saveStats(_stats);
    notifyListeners();
    await Future<void>.delayed(_reactionDelay);

    _appendBot(contact, session, card.timeoutLine);
    notifyListeners();
    await Future<void>.delayed(_lineDelay);

    String? nextId = card.timeoutNextNodeId;
    if (nextId == null) {
      for (final ChatChoice choice in node.choices) {
        if (choice.nextNodeId != null) {
          nextId = choice.nextNodeId;
          break;
        }
      }
    }

    final ChatNode? nextNode = script.nodeById(nextId);
    if (nextNode != null) {
      await _playNode(contact, session, nextNode);
      return null;
    }
    return _finish(contact, session);
  }

  /// Marca um balão do rascunho da Dra. Helena como falso (ou acusa um
  /// verdadeiro). Retorna algo quando a revisão inteira termina.
  Future<StageCompletion?> inspectStatement(
    Contact contact,
    String messageId,
  ) async {
    final ChatSession session = sessionFor(contact);
    if (session.busy ||
        session.finished ||
        session.exonerated ||
        !session.started) {
      return null;
    }
    if (isOutOfCoffee) return null;

    final ChatScript script = scriptFor(contact);
    final ChatNode? node = script.nodeById(session.currentNodeId);
    final InspectionChallenge? inspection = node?.inspection;
    if (node == null || inspection == null) return null;

    final int index = session.messages.indexWhere(
      (ChatMessage message) => message.id == messageId,
    );
    if (index < 0) return null;
    final ChatMessage message = session.messages[index];
    if (!message.isStatement || message.statementMark != StatementMark.none) {
      return null;
    }

    if (message.statementIsFalse == true) {
      session.messages[index] = message.copyWith(
        statementMark: StatementMark.falseMarked,
      );
      _stats = _stats.copyWith(
        prestige: _stats.prestige + inspection.correctPrestige,
      );
      await store.saveStats(_stats);
      notifyListeners();
      await _persistSessions();

      final bool pending = session.messages.any(
        (ChatMessage m) =>
            m.statementIsFalse == true && m.statementMark == StatementMark.none,
      );
      if (!pending) {
        return _completeInspection(contact, session, inspection);
      }
      return null;
    }

    // Balão verdadeiro: Amanda se assusta e o jogador perde 1 café.
    session.messages[index] = message.copyWith(
      statementMark: StatementMark.trueConfirmed,
    );
    _stats = _stats.copyWith(coffees: _stats.coffees - 1);
    await store.saveStats(_stats);
    session.busy = true;
    notifyListeners();
    await Future<void>.delayed(_reactionDelay);
    _appendBot(
      contact,
      session,
      const BotLine('Ei, essa parte tava certa! 👀', sender: 'Profa. Lúcia'),
    );
    notifyListeners();
    await Future<void>.delayed(_lineDelay);
    session.busy = false;
    notifyListeners();
    await _persistSessions();
    return null;
  }

  Future<StageCompletion> _completeInspection(
    Contact contact,
    ChatSession session,
    InspectionChallenge inspection,
  ) async {
    session.busy = true;
    notifyListeners();
    await Future<void>.delayed(_reactionDelay);
    for (final BotLine line in inspection.successLines) {
      _appendBot(contact, session, line);
      notifyListeners();
      await Future<void>.delayed(_lineDelay);
    }
    session.busy = false;
    return _finish(contact, session);
  }

  /// Texto livre: aparece no chat, mas não avança a fase.
  /// A estratégia é o ponto de extensão para o futuro modelo local.
  Future<void> sendFreeText(Contact contact, String text) async {
    final String trimmed = text.trim();
    final ChatSession session = sessionFor(contact);
    if (trimmed.isEmpty ||
        session.busy ||
        session.finished ||
        !session.started) {
      return;
    }

    _appendPlayer(session, trimmed);
    session.busy = true;
    session.freeTextCount++;
    notifyListeners();
    await Future<void>.delayed(_reactionDelay);

    final List<BotLine> lines = await replyStrategy.reply(
      ReplyContext(
        contact: contact,
        script: scriptFor(contact),
        playerText: trimmed,
        recentMessages: List<ChatMessage>.unmodifiable(session.messages),
        currentNodeId: session.currentNodeId,
        attempt: session.freeTextCount - 1,
      ),
    );

    for (final BotLine line in lines) {
      _appendBot(contact, session, line);
      notifyListeners();
      await Future<void>.delayed(_lineDelay);
    }

    session.busy = false;
    notifyListeners();
    await _persistSessions();
  }

  Future<void> resetProgress() async {
    _completed.clear();
    _sessions.clear();
    _stats = const GameStats();
    _gameFinished = false;
    await store.clear();
    notifyListeners();
  }

  /// Bad ending do Ministro: volta ao Grupo 1, zerando o treinamento.
  Future<void> restartTraining() => resetProgress();

  /// Recarrega as xícaras (ação do modal de bloqueio, após revisar a Sala de
  /// Dúvidas). O combo recomeça do zero.
  Future<void> reloadCoffees() async {
    _stats = _stats.copyWith(coffees: GameStats.maxCoffees, combo: 0);
    notifyListeners();
    await store.saveStats(_stats);
  }

  /// Um segundo depois da resposta, os outros participantes reagem à
  /// mensagem do jogador com emojis.
  Future<void> _scheduleReactions(
    Contact contact,
    ChatSession session,
    int messageIndex,
    AnswerStyle style,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (_sessions[contact.id] != session) return;
    if (session.finished) return;
    if (messageIndex < 0 || messageIndex >= session.messages.length) return;

    final ChatMessage message = session.messages[messageIndex];
    if (!message.isPlayer || message.hasReactions) return;

    final List<String> reactors = contact.isGroup
        ? contact.participants
              .map((ChatParticipant p) => p.firstName)
              .toList(growable: false)
        : <String>[contact.name];
    if (reactors.isEmpty) return;

    final List<String> emojis = style.reactionEmojis;
    session.messages[messageIndex] = message.copyWith(
      reactions: <MessageReaction>[
        for (int i = 0; i < emojis.length; i++)
          MessageReaction(
            emoji: emojis[i],
            reactorName: reactors[i % reactors.length],
          ),
      ],
    );
    notifyListeners();
  }

  void _applyChoiceScore(
    AnswerStyle style, {
    required bool quizError,
    int? prestigeDelta,
  }) {
    int combo = _stats.combo;
    if (style.isHit) {
      combo += 1;
    } else if (style.isMiss) {
      combo = 0;
    }
    _stats = _stats.copyWith(
      prestige: _stats.prestige + (prestigeDelta ?? style.prestigeDelta),
      combo: combo,
      // O café só é consumido por erro no teste/cartas ou na conversa de risco.
      coffees: quizError ? _stats.coffees - 1 : null,
    );
  }

  Future<void> _playNode(
    Contact contact,
    ChatSession session,
    ChatNode node,
  ) async {
    session.busy = true;
    session.currentNodeId = null;
    session.cardGameStarted = node.card != null;
    session.inspectionStarted = node.inspection != null;
    notifyListeners();
    await Future<void>.delayed(_typingDelay);

    for (final BotLine line in node.lines) {
      _appendBot(contact, session, line);
      notifyListeners();
      await Future<void>.delayed(_lineDelay);
    }

    final InspectionChallenge? inspection = node.inspection;
    if (inspection != null) {
      for (final DraftStatement statement in inspection.statements) {
        _appendStatement(contact, session, statement);
        notifyListeners();
        await Future<void>.delayed(const Duration(milliseconds: 240));
      }
    }

    session.currentNodeId = node.id;
    session.busy = false;
    notifyListeners();
    await _persistSessions();
  }

  Future<StageCompletion> _finish(Contact contact, ChatSession session) async {
    session.busy = true;
    session.currentNodeId = null;
    notifyListeners();

    final bool wasCompleted = _completed.contains(contact.id);
    Contact? next;
    if (!wasCompleted) {
      _completed.add(contact.id);
      await store.saveCompleted(_completed);
      next = _nextContact(contact);
    }

    // Encerramento seguro do treinamento após o teste da banca: não há
    // próxima fase. O estado final é ligado antes de qualquer transição de
    // tela e os cronômetros pendentes deixam de ser agendados.
    final bool careerFinale = contact.id == 'banca' && !wasCompleted;
    if (careerFinale) {
      _gameFinished = true;
      await store.saveGameFinished(true);
    }

    session.finished = true;
    session.busy = false;
    notifyListeners();
    await _persistSessions();

    return StageCompletion(
      contact: contact,
      nextContact: next,
      isFinale: careerFinale || (!wasCompleted && next == null),
      isReplay: wasCompleted,
      isQuiz: scriptFor(contact).isQuiz,
      correctAnswers: session.correctAnswers,
      answeredQuestions: session.answeredQuestions,
    );
  }

  Contact? _nextContact(Contact contact) {
    final int index = contacts.indexWhere((Contact c) => c.id == contact.id);
    if (index < 0) return null;
    for (int i = index + 1; i < contacts.length; i++) {
      if (!contacts[i].isReference) return contacts[i];
    }
    return null;
  }

  /// Salva um retrato consistente de cada conversa em andamento.
  /// Chamado apenas em pontos seguros (fim de nó, fim de fase, fim de uma
  /// resposta livre), nunca no meio da digitação do contato.
  Future<void> _persistSessions() async {
    final Map<String, StoredSession> snapshot = <String, StoredSession>{};
    _sessions.forEach((String id, ChatSession session) {
      if (!session.started) return;
      final ChatScript? script = scripts[id];
      if (script == null) return;
      if (!session.finished && script.nodeById(session.currentNodeId) == null) {
        return;
      }
      snapshot[id] = StoredSession(
        messages: List<ChatMessage>.unmodifiable(session.messages),
        currentNodeId: session.currentNodeId,
        started: session.started,
        finished: session.finished,
        freeTextCount: session.freeTextCount,
        correctAnswers: session.correctAnswers,
        answeredQuestions: session.answeredQuestions,
        exonerated: session.exonerated,
      );
    });
    await store.saveSessions(snapshot);
  }

  void _appendPlayer(ChatSession session, String text) {
    session.messages.add(
      ChatMessage(
        id: _nextMessageId(),
        author: MessageAuthor.player,
        text: text,
      ),
    );
  }

  void _appendBot(Contact contact, ChatSession session, BotLine line) {
    session.messages.add(
      ChatMessage(
        id: _nextMessageId(),
        author: MessageAuthor.contact,
        text: line.text,
        senderName: line.sender ?? (contact.isGroup ? contact.name : null),
      ),
    );
  }

  void _appendStatement(
    Contact contact,
    ChatSession session,
    DraftStatement statement,
  ) {
    session.messages.add(
      ChatMessage(
        id: _nextMessageId(),
        author: MessageAuthor.contact,
        text: statement.text,
        senderName: statement.sender ?? (contact.isGroup ? contact.name : null),
        statementId: statement.id,
        statementIsFalse: statement.isFalse,
      ),
    );
  }

  String _nextMessageId() => 'm$_messagePrefix${_messageSeq++}';
}
