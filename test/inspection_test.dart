import 'package:flutter_test/flutter_test.dart';
import 'package:grupo_da_baiana/data/game_script.dart';
import 'package:grupo_da_baiana/models/chat_message.dart';
import 'package:grupo_da_baiana/models/contact.dart';
import 'package:grupo_da_baiana/state/game_controller.dart';
import 'package:grupo_da_baiana/services/progress_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<T> _pump<T>(WidgetTester tester, Future<T> future) async {
  for (int i = 0; i < 60; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  return future;
}

void main() {
  testWidgets('revisar o rascunho: verdadeiro custa café, falso dá prestígio', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final GameController controller = GameController(
      store: ProgressStore(prefs),
      contacts: gameContacts,
      scripts: gameScripts,
    );
    await controller.load();

    final Contact helena = gameContacts.firstWhere(
      (Contact c) => c.id == 'helena',
    );
    await _pump(tester, controller.openChat(helena));

    final ChatSession session = controller.sessionFor(helena);
    final List<ChatMessage> statements = session.messages
        .where((ChatMessage m) => m.isStatement)
        .toList();
    expect(statements, hasLength(6));
    expect(
      statements.where((ChatMessage m) => m.statementIsFalse == true),
      hasLength(4),
    );

    final ChatMessage trueStatement = statements.firstWhere(
      (ChatMessage m) => m.statementIsFalse == false,
    );
    await _pump(tester, controller.inspectStatement(helena, trueStatement.id));

    expect(controller.stats.coffees, 2);
    expect(controller.stats.prestige, 0);
    expect(
      session.messages.any((ChatMessage m) => m.text.contains('tava certa')),
      isTrue,
    );
    expect(
      session.messages
          .firstWhere((ChatMessage m) => m.id == trueStatement.id)
          .statementMark,
      StatementMark.trueConfirmed,
    );

    final List<ChatMessage> falseStatements = statements
        .where((ChatMessage m) => m.statementIsFalse == true)
        .toList();

    StageCompletion? completion;
    for (final ChatMessage statement in falseStatements) {
      completion = await _pump(
        tester,
        controller.inspectStatement(helena, statement.id),
      );
    }

    expect(completion, isNotNull);
    expect(controller.stats.prestige, 40);
    expect(controller.isCompleted(helena), isTrue);
    expect(session.finished, isTrue);
    expect(
      controller.isUnlocked(
        gameContacts.firstWhere((Contact c) => c.id == 'lucia'),
      ),
      isTrue,
    );
  });
}
