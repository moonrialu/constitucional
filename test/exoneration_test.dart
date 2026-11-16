import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grupo_da_baiana/screens/exoneration_screen.dart';

void main() {
  testWidgets('o decreto de exoneração oferece refazer o treinamento', (
    WidgetTester tester,
  ) async {
    bool restarted = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ExonerationScreen(
          onRestart: () async {
            restarted = true;
          },
        ),
      ),
    );

    expect(find.textContaining('DECRETO DE'), findsOneWidget);
    expect(find.textContaining('EXONERAÇÃO'), findsOneWidget);
    expect(find.textContaining('PRESTÍGIO NO GABINETE'), findsOneWidget);

    await tester.tap(find.text('Refazer Treinamento (Voltar ao Grupo 1)'));
    await tester.pump();

    expect(restarted, isTrue);
  });
}
