import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message.dart';
import '../models/game_stats.dart';

/// Retrato de uma conversa em andamento, pronto para ir ao disco.
class StoredSession {
  const StoredSession({
    required this.messages,
    required this.currentNodeId,
    required this.started,
    required this.finished,
    required this.freeTextCount,
    required this.correctAnswers,
    required this.answeredQuestions,
    this.exonerated = false,
  });

  final List<ChatMessage> messages;
  final String? currentNodeId;
  final bool started;
  final bool finished;
  final int freeTextCount;
  final int correctAnswers;
  final int answeredQuestions;
  final bool exonerated;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'messages': <Map<String, dynamic>>[
        for (final ChatMessage message in messages)
          <String, dynamic>{
            'i': message.id,
            'a': message.author.index,
            't': message.text,
            if (message.senderName != null) 's': message.senderName,
            if (message.reactions.isNotEmpty)
              'r': <Map<String, dynamic>>[
                for (final MessageReaction reaction in message.reactions)
                  reaction.toJson(),
              ],
            if (message.statementId != null) 'sid': message.statementId,
            if (message.statementIsFalse != null)
              'sf': message.statementIsFalse,
            if (message.statementMark != StatementMark.none)
              'sm': message.statementMark.index,
          },
      ],
      if (currentNodeId != null) 'nodeId': currentNodeId,
      'started': started,
      'finished': finished,
      'freeTextCount': freeTextCount,
      'correct': correctAnswers,
      'answered': answeredQuestions,
      if (exonerated) 'exonerated': true,
    };
  }

  static StoredSession? fromJson(Map<String, dynamic> json) {
    if (json['started'] != true) return null;

    final Object? rawMessages = json['messages'];
    if (rawMessages is! List) return null;

    final List<ChatMessage> messages = <ChatMessage>[];
    for (final Object? raw in rawMessages) {
      if (raw is! Map) continue;
      final Object? author = raw['a'];
      final Object? text = raw['t'];
      if (author is! int || text is! String) continue;
      if (author < 0 || author >= MessageAuthor.values.length) continue;

      final Object? id = raw['i'];
      final Object? sender = raw['s'];
      final List<MessageReaction> reactions = _reactionsFromJson(raw['r']);
      final Object? statementId = raw['sid'];
      final Object? statementIsFalse = raw['sf'];
      final Object? rawMark = raw['sm'];
      final StatementMark mark =
          rawMark is int &&
              rawMark >= 0 &&
              rawMark < StatementMark.values.length
          ? StatementMark.values[rawMark]
          : StatementMark.none;
      messages.add(
        ChatMessage(
          id: id is String ? id : 'm${messages.length}',
          author: MessageAuthor.values[author],
          text: text,
          senderName: sender is String ? sender : null,
          reactions: reactions,
          statementId: statementId is String ? statementId : null,
          statementIsFalse: statementIsFalse is bool ? statementIsFalse : null,
          statementMark: mark,
        ),
      );
    }

    final Object? nodeId = json['nodeId'];
    return StoredSession(
      messages: messages,
      currentNodeId: nodeId is String ? nodeId : null,
      started: true,
      finished: json['finished'] == true,
      freeTextCount: _asCount(json['freeTextCount']),
      correctAnswers: _asCount(json['correct']),
      answeredQuestions: _asCount(json['answered']),
      exonerated: json['exonerated'] == true,
    );
  }

  static int _asCount(Object? value) => value is int && value > 0 ? value : 0;

  static List<MessageReaction> _reactionsFromJson(Object? raw) {
    if (raw is! List) return const <MessageReaction>[];
    final List<MessageReaction> reactions = <MessageReaction>[];
    for (final Object? item in raw) {
      if (item is! Map) continue;
      final MessageReaction? reaction = MessageReaction.fromJson(
        item.cast<String, dynamic>(),
      );
      if (reaction != null) reactions.add(reaction);
    }
    return reactions;
  }
}

/// Guarda o progresso entre execuções: fases concluídas e conversas em
/// andamento (nó atual, mensagens e placar do teste).
class ProgressStore {
  ProgressStore(this._prefs);

  static const String _completedKey = 'mutacao_constitucional.completed.v1';
  static const String _sessionsKey = 'mutacao_constitucional.sessions.v1';
  static const String _statsKey = 'mutacao_constitucional.stats.v1';
  static const String _finishedKey = 'mutacao_constitucional.finished.v1';

  final SharedPreferences _prefs;

  Set<String> loadCompleted() {
    final List<String> saved =
        _prefs.getStringList(_completedKey) ?? <String>[];
    return saved.toSet();
  }

  Future<void> saveCompleted(Set<String> ids) {
    final List<String> sorted = ids.toList()..sort();
    return _prefs.setStringList(_completedKey, sorted);
  }

  Map<String, StoredSession> loadSessions() {
    final String? raw = _prefs.getString(_sessionsKey);
    if (raw == null || raw.isEmpty) return <String, StoredSession>{};

    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return <String, StoredSession>{};

      final Map<String, StoredSession> sessions = <String, StoredSession>{};
      decoded.forEach((String id, Object? value) {
        if (value is! Map<String, dynamic>) return;
        final StoredSession? session = StoredSession.fromJson(value);
        if (session != null) sessions[id] = session;
      });
      return sessions;
    } on FormatException {
      return <String, StoredSession>{};
    }
  }

  Future<void> saveSessions(Map<String, StoredSession> sessions) {
    if (sessions.isEmpty) return _prefs.remove(_sessionsKey);

    final Map<String, dynamic> payload = <String, dynamic>{
      for (final MapEntry<String, StoredSession> entry in sessions.entries)
        entry.key: entry.value.toJson(),
    };
    return _prefs.setString(_sessionsKey, jsonEncode(payload));
  }

  GameStats loadStats() {
    final String? raw = _prefs.getString(_statsKey);
    if (raw == null || raw.isEmpty) return const GameStats();
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return const GameStats();
      return GameStats.fromJson(decoded) ?? const GameStats();
    } on FormatException {
      return const GameStats();
    }
  }

  Future<void> saveStats(GameStats stats) =>
      _prefs.setString(_statsKey, jsonEncode(stats.toJson()));

  bool loadGameFinished() => _prefs.getBool(_finishedKey) ?? false;

  Future<void> saveGameFinished(bool finished) =>
      _prefs.setBool(_finishedKey, finished);

  Future<void> clear() async {
    await _prefs.remove(_completedKey);
    await _prefs.remove(_sessionsKey);
    await _prefs.remove(_statsKey);
    await _prefs.remove(_finishedKey);
  }
}
