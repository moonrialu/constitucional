import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grupo_da_baiana/models/chat_message.dart';
import 'package:grupo_da_baiana/widgets/message_bubble.dart';

void main() {
  testWidgets('o balão do jogador mostra as reações dos personagens', (
    WidgetTester tester,
  ) async {
    const ChatMessage message = ChatMessage(
      id: 'm1',
      author: MessageAuthor.player,
      text: 'Na mutação, o texto permanece.',
      reactions: <MessageReaction>[
        MessageReaction(emoji: '❤️', reactorName: 'Amanda'),
        MessageReaction(emoji: '👏', reactorName: 'Ian'),
      ],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: MessageBubble(message: message)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('❤️'), findsOneWidget);
    expect(find.text('👏'), findsOneWidget);
    expect(find.text('Na mutação, o texto permanece.'), findsOneWidget);
  });

  testWidgets('sem reações o balão não ganha o selo', (
    WidgetTester tester,
  ) async {
    const ChatMessage message = ChatMessage(
      id: 'm2',
      author: MessageAuthor.player,
      text: 'Ainda sem reações.',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: MessageBubble(message: message)),
      ),
    );

    expect(find.text('❤️'), findsNothing);
    expect(find.text('👏'), findsNothing);
  });

  testWidgets('balão do rascunho pode ser marcado como falso', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    const ChatMessage message = ChatMessage(
      id: 'm3',
      author: MessageAuthor.contact,
      text: 'A mutação constitucional altera a letra da Constituição.',
      senderName: 'Dra. Helena',
      statementId: 's1',
      statementIsFalse: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageBubble(
            message: message,
            onStatementTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(
      find.text('A mutação constitucional altera a letra da Constituição.'),
    );
    expect(tapped, isTrue);
    expect(find.textContaining('FALSO'), findsNothing);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageBubble(
            message: message.copyWith(statementMark: StatementMark.falseMarked),
          ),
        ),
      ),
    );

    expect(find.textContaining('FALSO'), findsOneWidget);
    expect(find.textContaining('APAGAR'), findsOneWidget);
  });
}
