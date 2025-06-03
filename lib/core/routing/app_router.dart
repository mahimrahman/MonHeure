import 'package:flutter/material.dart';
import 'package:mon_heure/features/reports/presentation/pages/reports_page.dart';
import 'package:mon_heure/features/settings/presentation/pages/settings_page.dart';
import 'package:mon_heure/features/time_tracking/presentation/pages/home_page.dart';

/// Routes for the application.
class AppRouter {
  /// Private constructor to prevent instantiation.
  AppRouter._();

  /// The home route.
  static const String home = '/';

  /// The reports route.
  static const String reports = '/reports';

  /// The settings route.
  static const String settings = '/settings';

  /// Generates routes for the application.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case reports:
        return MaterialPageRoute(
          builder: (_) => const ReportsPage(),
        );
      case settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 