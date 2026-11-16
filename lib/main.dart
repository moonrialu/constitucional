import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/game_script.dart';
import 'services/progress_store.dart';
import 'state/game_controller.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.sand,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final GameController controller = GameController(
    store: ProgressStore(prefs),
    contacts: gameContacts,
    scripts: gameScripts,
  );
  await controller.load();

  runApp(BaianaApp(controller: controller));
}
