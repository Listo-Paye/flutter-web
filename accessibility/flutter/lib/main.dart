import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/task_provider.dart';
import 'screens/home_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les tâches depuis le stockage local
  final prefs = await SharedPreferences.getInstance();
  final taskProvider = TaskProvider();
  await taskProvider.loadTasks(prefs);

  runApp(
    ChangeNotifierProvider(
      create: (context) => taskProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Tâches Collaboratives',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
      // Configuration pour l'accessibilité
      shortcuts: {
        ...WidgetsApp.defaultShortcuts,
        const SingleActivator(LogicalKeyboardKey.escape): const DismissIntent(),
      },
      actions: {
        ...WidgetsApp.defaultActions,
        DismissIntent: DismissAction(context),
      },
    );
  }
}

// Action pour fermer les dialogues avec la touche Escape
class DismissAction extends Action<DismissIntent> {
  DismissAction(this.context);

  final BuildContext context;

  @override
  void invoke(DismissIntent intent) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
