import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dashboard_benchmark/screens/splash_screen.dart';
import 'package:flutter_dashboard_benchmark/screens/dashboard/dashboard_screen.dart' deferred as dashboard;
import 'package:flutter_dashboard_benchmark/screens/detailed_view/detailed_view_screen.dart' deferred as detailed_view;
import 'package:flutter_dashboard_benchmark/screens/settings/settings_screen.dart' deferred as settings;
import 'package:flutter_dashboard_benchmark/widgets/deferred_widget.dart';

// Define routes
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash screen route
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    
    // Dashboard route with deferred loading
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => DeferredWidget(
        dashboard.loadLibrary,
        () => dashboard.DashboardScreen(),
      ),
    ),
    
    // Detailed view route with deferred loading and parameter
    GoRoute(
      path: '/detailed/:chartId',
      builder: (context, state) {
        final chartId = state.pathParameters['chartId'] ?? '';
        return DeferredWidget(
          detailed_view.loadLibrary,
          () => detailed_view.DetailedViewScreen(chartId: chartId),
        );
      },
    ),
    
    // Settings route with deferred loading
    GoRoute(
      path: '/settings',
      builder: (context, state) => DeferredWidget(
        settings.loadLibrary,
        () => settings.SettingsScreen(),
      ),
    ),
  ],
);

