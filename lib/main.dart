import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'engine/game_controller.dart';
import 'engine/mutation_controller.dart';
import 'services/mutation_store.dart';
import 'services/progress_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // A jornada acontece inteira em paisagem: a mesa de cartas precisa da
  // largura, não da altura.
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final controller = GameController(SharedPrefsProgressStorage());
  final mutation = MutationController(SharedPrefsMutationStorage());
  await Future.wait([controller.load(), mutation.load()]);

  runApp(OvaApp(controller: controller, mutation: mutation));
}
