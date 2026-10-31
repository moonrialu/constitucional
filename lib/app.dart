import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'engine/game_controller.dart';
import 'engine/mutation_controller.dart';
import 'screens/root_router.dart';
import 'theme/app_theme.dart';

class OvaApp extends StatelessWidget {
  const OvaApp({super.key, required this.controller, required this.mutation});

  final GameController controller;
  final MutationController mutation;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GameController>.value(value: controller),
        ChangeNotifierProvider<MutationController>.value(value: mutation),
      ],
      child: MaterialApp(
        title: 'Assessora do STF — Mutação constitucional',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const RootRouter(),
      ),
    );
  }
}
