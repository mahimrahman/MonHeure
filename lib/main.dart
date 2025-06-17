import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mon_heure/core/di/service_locator.dart';
import 'package:mon_heure/core/routing/app_router.dart';
import 'package:mon_heure/core/theme/app_theme.dart';
import 'package:mon_heure/features/time_tracking/data/punch_session_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mon_heure/features/time_tracking/presentation/pages/dashboard_page.dart';
import 'package:mon_heure/features/time_tracking/presentation/pages/home_page.dart';

/// The main entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
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
class MonHeureApp extends ConsumerStatefulWidget {
  /// Creates a new instance of [MonHeureApp].
  const MonHeureApp({super.key});

  @override
  ConsumerState<MonHeureApp> createState() => _MonHeureAppState();
}

class _MonHeureAppState extends ConsumerState<MonHeureApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MonHeure',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
      home: const MainPage(),
    );
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final PageController _pageController;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final _pages = const [
    HomePage(),
    DashboardPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onDestinationSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        animationDuration: const Duration(milliseconds: 300),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.access_time),
            label: 'Time',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
} 