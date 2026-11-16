import 'package:flutter/material.dart';

import 'screens/contacts_screen.dart';
import 'state/game_controller.dart';
import 'theme/app_theme.dart';

class BaianaApp extends StatelessWidget {
  const BaianaApp({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mutação Constitucional',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: ContactsScreen(controller: controller),
    );
  }
}
