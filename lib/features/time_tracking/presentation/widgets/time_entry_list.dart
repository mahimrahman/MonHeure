import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mon_heure/features/time_tracking/domain/models/time_entry.dart';
import 'package:mon_heure/features/time_tracking/presentation/providers/time_entry_provider.dart';

/// A widget that displays a list of time entries.
class TimeEntryList extends HookConsumerWidget {
  /// Creates a new instance of [TimeEntryList].
  const TimeEntryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timeEntryProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text(state.error!));
    }

    if (state.entries.isEmpty) {
      return const Center(
        child: Text('No time entries yet'),
      );
    }

    return ListView.builder(
      itemCount: state.entries.length,
      itemBuilder: (context, index) {
        final entry = state.entries[index];
        return _TimeEntryTile(entry: entry);
      },
    );
  }
}

/// A widget that displays a single time entry.
class _TimeEntryTile extends StatelessWidget {
  /// Creates a new instance of [_TimeEntryTile].
  const _TimeEntryTile({
    required this.entry,
  });

  /// The time entry to display.
  final TimeEntry entry;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        title: Text(
          dateFormat.format(entry.startTime),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '${timeFormat.format(entry.startTime)} - ${entry.endTime != null ? timeFormat.format(entry.endTime!) : 'Running'}',
        ),
        trailing: entry.endTime != null
            ? Text(
                _formatDuration(entry.endTime!.difference(entry.startTime)),
                style: Theme.of(context).textTheme.bodyLarge,
              )
            : null,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }
} 