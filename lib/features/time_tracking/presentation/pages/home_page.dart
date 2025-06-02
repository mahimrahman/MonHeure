import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mon_heure/features/time_tracking/presentation/providers/time_entry_provider.dart';
import 'package:mon_heure/features/time_tracking/presentation/widgets/time_entry_list.dart';
import 'package:mon_heure/features/time_tracking/presentation/widgets/timer_display.dart';

/// The main page of the application.
class HomePage extends HookConsumerWidget {
  /// Creates a new instance of [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MonHeure'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              // TODO: Navigate to statistics page
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // TODO: Export time entries
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          TimerDisplay(),
          Expanded(
            child: TimeEntryList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(timeEntryProvider.notifier).toggleTimer();
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
} 