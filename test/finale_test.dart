import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grupo_da_baiana/data/game_script.dart';
import 'package:grupo_da_baiana/models/chat_script.dart';
import 'package:grupo_da_baiana/models/contact.dart';
import 'package:grupo_da_baiana/models/game_stats.dart';
import 'package:grupo_da_baiana/services/progress_store.dart';
import 'package:grupo_da_baiana/state/game_controller.dart';
import 'package:grupo_da_baiana/widgets/finale_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<T> _pump<T>(WidgetTester tester, Future<T> future) async {
  for (int i = 0; i < 80; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  return future;
}

void main() {
  testWidgets('a efetivação acontece ao fim da banca, não na Lúcia', (
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

    final Contact lucia = gameContacts.firstWhere(
      (Contact c) => c.id == 'lucia',
    );
    final Contact banca = gameContacts.firstWhere(
      (Contact c) => c.id == 'banca',
    );

    await _pump(tester, controller.openChat(lucia));

    await _pump(
      tester,
      controller.choose(
        lucia,
        controller
            .choicesFor(lucia)
            .firstWhere((c) => c.id == 'inconstitucional'),
      ),
    );
    await _pump(
      tester,
      controller.choose(
        lucia,
        controller.choicesFor(lucia).firstWhere((c) => c.id == 'inseguranca'),
      ),
    );

    final StageCompletion? luciaCompletion = await _pump(
      tester,
      controller.choose(
        lucia,
        controller.choicesFor(lucia).firstWhere((c) => c.id == 'banca'),
      ),
    );

    // O caso da Lúcia termina normalmente e libera a banca.
    expect(luciaCompletion, isNotNull);
    expect(luciaCompletion!.isCareerFinale, isFalse);
    expect(controller.isGameFinished, isFalse);
    expect(controller.isCompleted(lucia), isTrue);
    expect(controller.isUnlocked(banca), isTrue);
    expect(controller.stats.prestige, 45);

    // Joga a banca inteira: cinco acertos e o encerramento do expediente.
    await _pump(tester, controller.openChat(banca));

    StageCompletion? bancaCompletion;
    for (int i = 0; i < 5; i++) {
      final ChatChoice correct = controller
          .choicesFor(banca)
          .firstWhere((ChatChoice c) => c.isCorrect == true);
      bancaCompletion = await _pump(tester, controller.choose(banca, correct));
    }

    bancaCompletion = await _pump(
      tester,
      controller.choose(
        banca,
        controller.choicesFor(banca).firstWhere((c) => c.id == 'fechar'),
      ),
    );

    expect(bancaCompletion, isNotNull);
    expect(bancaCompletion!.isCareerFinale, isTrue);
    expect(bancaCompletion.isFinale, isTrue);
    expect(bancaCompletion.correctAnswers, 5);
    expect(bancaCompletion.answeredQuestions, 5);
    expect(controller.isGameFinished, isTrue);
    expect(controller.isCompleted(banca), isTrue);
    expect(controller.sessionFor(banca).finished, isTrue);
    expect(controller.stats.prestige, 100);
    expect(ProgressStore(prefs).loadGameFinished(), isTrue);
    expect(
      controller.choicesFor(banca),
      isEmpty,
      reason: 'Depois do fim não deve haver nova pergunta',
    );
  });

  testWidgets('o card de efetivação mostra o resumo e permite reiniciar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return TextButton(
                onPressed: () => showFinaleSheet(
                  context,
                  stats: const GameStats(coffees: 2, prestige: 80),
                  correctAnswers: 4,
                  answeredQuestions: 5,
                ),
                child: const Text('abrir'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    expect(find.textContaining('EFETIVADO'), findsOneWidget);
    expect(
      find.textContaining('O Ministro e a Banca aprovaram'),
      findsOneWidget,
    );
    expect(find.text('BANCA FINAL · 4 DE 5 ACERTOS'), findsOneWidget);
    expect(find.text('80'), findsOneWidget);
    expect(find.text('Reiniciar jogo'), findsOneWidget);
    expect(find.text('Voltar para as conversas'), findsOneWidget);

    await tester.tap(find.text('Reiniciar jogo'));
    await tester.pumpAndSettle();

    expect(find.text('Reiniciar jogo'), findsNothing);
  });
}
