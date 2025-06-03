import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The reports page of the application.
class ReportsPage extends HookConsumerWidget {
  /// Creates a new instance of [ReportsPage].
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: const Center(
        child: Text('Reports coming soon'),
      ),
    );
  }
} 