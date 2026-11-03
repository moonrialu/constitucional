import 'package:assessora_stf_cards/data/mutation_content.dart';
import 'package:assessora_stf_cards/data/training_dialogue.dart';
import 'package:assessora_stf_cards/engine/mutation_controller.dart';
import 'package:assessora_stf_cards/models/mutation.dart';
import 'package:assessora_stf_cards/screens/mutation_journey_screen.dart';
import 'package:assessora_stf_cards/screens/onboarding_screen.dart';
import 'package:assessora_stf_cards/screens/training_step.dart';
import 'package:assessora_stf_cards/services/mutation_store.dart';
import 'package:assessora_stf_cards/theme/app_theme.dart';
import 'package:assessora_stf_cards/utils/personalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MutationController controller;

  setUp(() async {
    controller = MutationController(InMemoryMutationStorage());
    await controller.load();
    await controller.setUserName('Ana');
    await controller.startJourney();
    await controller.answerCase(caseId: 'case1', choiceId: 'B');
    await controller.answerCase(caseId: 'case3', choiceId: 'B');
    await controller.answerCase(caseId: 'case4', choiceId: 'C');
    for (final item in mutationCheck.items) {
      await controller.answerCheck(
        checkId: mutationCheck.id,
        itemId: item.id,
        optionId: item.correct,
      );
    }
    for (final question in mutationQuiz) {
      await controller.answerQuiz(
        questionId: question.id,
        choiceId: question.correct,
      );
    }
  });

  Future<void> pumpStep(WidgetTester tester, String stepId) async {
    await controller.goToStep(stepId);
    await tester.pumpWidget(
      ChangeNotifierProvider<MutationController>.value(
        value: controller,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const MutationJourneyScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  }

  testWidgets('as 16 telas montam em paisagem sem estourar layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final step in mutationFlow) {
      await pumpStep(tester, step.id);
    }
  });

  testWidgets('as telas também montam em paisagem compacta', (tester) async {
    tester.view.physicalSize = const Size(760, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final step in mutationFlow) {
      await pumpStep(tester, step.id);
    }
  });

  testWidgets('o onboarding valida e salva o nome do usuário', (tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final local = MutationController(InMemoryMutationStorage());
    await local.load();
    var completed = false;

    await tester.pumpWidget(
      ChangeNotifierProvider<MutationController>.value(
        value: local,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: OnboardingScreen(onComplete: () => completed = true),
        ),
      ),
    );
    // O campo com autofocus pisca o cursor; por isso usamos pump, não settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Sem nome, o botão não libera a jornada.
    await tester.tap(find.text('Entrar no treinamento'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(completed, isFalse);
    expect(local.hasName, isFalse);
    expect(
      find.text('Digite um nome para o gabinete te chamar.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), '  Ana Luiza  ');
    await tester.tap(find.text('Entrar no treinamento'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(local.userName, 'Ana Luiza');
    expect(completed, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('o treinamento avança as falas ao tocar na cena', (tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final act = mutationTraining.first;
    var continued = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Scaffold(
          body: TrainingStepView(
            act: act,
            userName: 'Ana',
            actNumber: 1,
            actTotal: mutationTraining.length,
            onContinue: () => continued = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Fala 1 de'), findsOneWidget);
    await tester.tap(find.text(personalizeText(act.lines.first.text, 'Ana')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Fala 2 de'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Avança até o resumo do ato.
    while (find.text('Próxima fala').evaluate().isNotEmpty) {
      await tester.tap(find.text('Próxima fala'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Ver resumo'), findsOneWidget);
    await tester.tap(find.text('Ver resumo'));
    await tester.pumpAndSettle();

    expect(find.text(act.summaryTitle), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text(act.nextLabel));
    await tester.pumpAndSettle();
    expect(continued, isTrue);
  });

  test('a personalização troca {nome} pelo nome do onboarding', () {
    expect(personalizeText('Olá, {nome}!', 'Ana'), 'Olá, Ana!');
    expect(personalizeText('Olá, {nome}!', '   '), 'Olá, assessor(a)!');
    expect(personalizeText('Sem marcador', 'Ana'), 'Sem marcador');
  });
}
