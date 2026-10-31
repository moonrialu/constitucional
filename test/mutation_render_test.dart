import 'package:assessora_stf_cards/data/mutation_content.dart';
import 'package:assessora_stf_cards/engine/mutation_controller.dart';
import 'package:assessora_stf_cards/models/mutation.dart';
import 'package:assessora_stf_cards/screens/mutation_journey_screen.dart';
import 'package:assessora_stf_cards/services/mutation_store.dart';
import 'package:assessora_stf_cards/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MutationController controller;

  setUp(() async {
    controller = MutationController(InMemoryMutationStorage());
    await controller.load();
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
}
