import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mon_heure/core/di/service_locator.dart';
import 'package:mon_heure/core/routing/app_router.dart';
import 'package:mon_heure/core/theme/app_theme.dart';
import 'package:mon_heure/features/time_tracking/data/punch_session.dart';
import 'package:mon_heure/features/time_tracking/data/punch_session_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// The main entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(PunchSessionAdapter());
  Hive.registerAdapter(PunchSessionEntityAdapter());

  final container = ProviderContainer();
  setupProviders(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MonHeureApp(),
    ),
  );
}

/// The root widget of the application.
class MonHeureApp extends StatelessWidget {
  /// Creates a new instance of [MonHeureApp].
  const MonHeureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MonHeure',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
} 