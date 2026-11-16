import 'package:flutter_test/flutter_test.dart';
import 'package:grupo_da_baiana/models/chat_message.dart';
import 'package:grupo_da_baiana/models/game_stats.dart';
import 'package:grupo_da_baiana/services/progress_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  StoredSession buildSession({bool finished = false}) {
    return StoredSession(
      messages: <ChatMessage>[
        const ChatMessage(
          id: 'm1',
          author: MessageAuthor.contact,
          text: 'O texto nunca mudou.',
          senderName: 'Dra. Helena',
        ),
        const ChatMessage(
          id: 'm2',
          author: MessageAuthor.player,
          text: 'Então houve mutação.',
          reactions: <MessageReaction>[
            MessageReaction(emoji: '❤️', reactorName: 'Helena'),
            MessageReaction(emoji: '👏', reactorName: 'Ministro'),
          ],
        ),
      ],
      currentNodeId: finished ? null : 'historia',
      started: true,
      finished: finished,
      freeTextCount: 1,
      correctAnswers: 2,
      answeredQuestions: 3,
    );
  }

  test('salva e recupera uma conversa em andamento', () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressStore store = ProgressStore(prefs);

    await store.saveSessions(<String, StoredSession>{'helena': buildSession()});

    final Map<String, StoredSession> loaded = store.loadSessions();
    expect(loaded.keys, <String>['helena']);

    final StoredSession session = loaded['helena']!;
    expect(session.currentNodeId, 'historia');
    expect(session.started, isTrue);
    expect(session.finished, isFalse);
    expect(session.freeTextCount, 1);
    expect(session.correctAnswers, 2);
    expect(session.answeredQuestions, 3);
    expect(session.messages.length, 2);
    expect(session.messages.first.senderName, 'Dra. Helena');
    expect(session.messages.last.author, MessageAuthor.player);
    expect(session.messages.last.reactions, hasLength(2));
    expect(session.messages.last.reactions.first.emoji, '❤️');
    expect(session.messages.last.reactions.last.reactorName, 'Ministro');
  });

  test('conversas vazias são removidas do disco', () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressStore store = ProgressStore(prefs);

    await store.saveSessions(<String, StoredSession>{'helena': buildSession()});
    await store.saveSessions(<String, StoredSession>{});

    expect(store.loadSessions(), isEmpty);
  });

  test('clear apaga fases concluídas e conversas salvas', () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressStore store = ProgressStore(prefs);

    await store.saveCompleted(<String>{'gabinete'});
    await store.saveSessions(<String, StoredSession>{'helena': buildSession()});
    await store.saveStats(const GameStats(coffees: 1, prestige: 45, combo: 2));
    await store.saveGameFinished(true);
    await store.clear();

    expect(store.loadCompleted(), isEmpty);
    expect(store.loadSessions(), isEmpty);
    expect(store.loadStats(), const GameStats());
    expect(store.loadGameFinished(), isFalse);
  });

  test('a efetivação ao fim da banca é persistida', () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressStore store = ProgressStore(prefs);

    expect(store.loadGameFinished(), isFalse);
    await store.saveGameFinished(true);
    expect(store.loadGameFinished(), isTrue);
  });

  test('salva e recupera café, prestígio e combo', () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressStore store = ProgressStore(prefs);

    expect(store.loadStats(), const GameStats());

    const GameStats stats = GameStats(coffees: 2, prestige: 65, combo: 3);
    await store.saveStats(stats);

    expect(store.loadStats(), stats);
  });

  test('stats fora da faixa são normalizados ao carregar', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'flutter.mutacao_constitucional.stats.v1':
          '{"coffees":-4,"prestige":180,"combo":2}',
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressStore store = ProgressStore(prefs);

    expect(
      store.loadStats(),
      const GameStats(coffees: 0, prestige: 100, combo: 2),
    );
  });

  test('conteúdo corrompido não quebra o carregamento', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'flutter.mutacao_constitucional.sessions.v1': 'isto não é json',
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressStore store = ProgressStore(prefs);

    expect(store.loadSessions(), isEmpty);
  });

  test('marcas do rascunho da Dra. Helena sobrevivem ao disco', () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressStore store = ProgressStore(prefs);

    await store.saveSessions(<String, StoredSession>{
      'helena': StoredSession(
        messages: const <ChatMessage>[
          ChatMessage(
            id: 'm1',
            author: MessageAuthor.contact,
            text: 'A mutação altera a letra da Constituição.',
            senderName: 'Dra. Helena',
            statementId: 's1',
            statementIsFalse: true,
            statementMark: StatementMark.falseMarked,
          ),
          ChatMessage(
            id: 'm2',
            author: MessageAuthor.contact,
            text: 'A mutação muda o sentido sem alterar o texto.',
            senderName: 'Dra. Helena',
            statementId: 's5',
            statementIsFalse: false,
            statementMark: StatementMark.trueConfirmed,
          ),
        ],
        currentNodeId: 'rascunho',
        started: true,
        finished: false,
        freeTextCount: 0,
        correctAnswers: 0,
        answeredQuestions: 0,
      ),
    });

    final StoredSession session = store.loadSessions()['helena']!;
    expect(session.messages[0].statementMark, StatementMark.falseMarked);
    expect(session.messages[0].statementIsFalse, isTrue);
    expect(session.messages[1].statementMark, StatementMark.trueConfirmed);
    expect(session.messages[1].statementIsFalse, isFalse);
  });

  test('a exoneração do Ministro é preservada ao reabrir o app', () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressStore store = ProgressStore(prefs);

    await store.saveSessions(<String, StoredSession>{
      'ministro': StoredSession(
        messages: const <ChatMessage>[
          ChatMessage(
            id: 'm1',
            author: MessageAuthor.player,
            text: 'Negar: só emenda muda isso.',
          ),
        ],
        currentNodeId: 'caso1',
        started: true,
        finished: false,
        freeTextCount: 0,
        correctAnswers: 0,
        answeredQuestions: 1,
        exonerated: true,
      ),
    });

    final StoredSession session = store.loadSessions()['ministro']!;
    expect(session.exonerated, isTrue);
    expect(session.currentNodeId, 'caso1');
  });
}
