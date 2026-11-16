import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grupo_da_baiana/models/chat_script.dart';
import 'package:grupo_da_baiana/widgets/card_challenge_panel.dart';

const CardChallenge _card = CardChallenge(
  situation: 'STF reconhece união homoafetiva sem alterar o art. 226 da CF.',
  timeoutLine: BotLine('Tempo esgotado', sender: 'Bruno'),
  index: 1,
  total: 3,
);

const List<ChatChoice> _choices = <ChatChoice>[
  ChatChoice(id: 'm', label: 'É mutação constitucional', isCorrect: true),
  ChatChoice(id: 'r', label: 'É reforma formal (PEC)', isCorrect: false),
  ChatChoice(id: 'i', label: 'É inconstitucionalidade', isCorrect: false),
];

Widget _wrap(CardChallengePanel panel) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: SingleChildScrollView(child: panel)),
    ),
  );
}

void main() {
  testWidgets('acerto brilha em verde e devolve a escolha', (
    WidgetTester tester,
  ) async {
    ChatChoice? picked;
    await tester.pumpWidget(
      _wrap(
        CardChallengePanel(
          card: _card,
          choices: _choices,
          enabled: true,
          onAnswer: (ChatChoice choice) => picked = choice,
          onTimeout: () {},
        ),
      ),
    );

    expect(find.text('10s'), findsOneWidget);
    expect(find.text('CARTA 01 DE 03'), findsOneWidget);

    await tester.tap(find.text('É mutação constitucional'));
    await tester.pump(const Duration(milliseconds: 700));

    expect(picked?.id, 'm');
    expect(find.textContaining('ACERTOU'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('tempo esgotado avisa o controlador', (
    WidgetTester tester,
  ) async {
    bool timedOut = false;
    await tester.pumpWidget(
      _wrap(
        CardChallengePanel(
          card: const CardChallenge(
            situation: 'Congresso aprova PEC mudando o texto.',
            timeoutLine: BotLine('Tempo esgotado', sender: 'Bruno'),
            index: 3,
            total: 3,
            seconds: 1,
          ),
          choices: _choices,
          enabled: true,
          onAnswer: (_) {},
          onTimeout: () => timedOut = true,
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pump(const Duration(milliseconds: 700));

    expect(timedOut, isTrue);
    expect(find.text('TEMPO ESGOTADO!'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets('sem cafés a carta fica travada e sem cronômetro', (
    WidgetTester tester,
  ) async {
    ChatChoice? picked;
    await tester.pumpWidget(
      _wrap(
        CardChallengePanel(
          card: _card,
          choices: _choices,
          enabled: false,
          onAnswer: (ChatChoice choice) => picked = choice,
          onTimeout: () {},
        ),
      ),
    );

    await tester.tap(find.text('É mutação constitucional'));
    await tester.pump(const Duration(milliseconds: 700));

    expect(picked, isNull);
    expect(find.textContaining('Sem cafés'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
