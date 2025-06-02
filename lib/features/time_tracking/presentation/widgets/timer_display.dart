import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mon_heure/features/time_tracking/presentation/providers/time_entry_provider.dart';

/// A widget that displays the current timer state.
class TimerDisplay extends HookConsumerWidget {
  /// Creates a new instance of [TimerDisplay].
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timeEntryProvider);
    final activeEntry = state.activeEntry;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              activeEntry != null ? 'Timer Running' : 'Timer Stopped',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (activeEntry != null)
              _buildDuration(context, activeEntry.startTime)
            else
              Text(
                '00:00:00',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuration(BuildContext context, DateTime startTime) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final duration = DateTime.now().difference(startTime);
        final hours = duration.inHours.toString().padLeft(2, '0');
        final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

        return Text(
          '$hours:$minutes:$seconds',
          style: Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }
} 