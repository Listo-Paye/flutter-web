import 'package:flutter/material.dart';
import 'package:flutter_dashboard_benchmark/routes/app_router.dart';
import 'package:flutter_dashboard_benchmark/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart' show usePathUrlStrategy;

void main() async {
  usePathUrlStrategy();
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app with ProviderScope for Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme mode from our theme provider
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Flutter Dashboard Benchmark',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
