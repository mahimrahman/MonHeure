import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mon_heure/features/time_tracking/presentation/widgets/report_view.dart';
import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/domain/repositories/punch_session_repository.dart';

final selectedDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);

class ReportPage extends HookConsumerWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRange = ref.watch(selectedDateRangeProvider);
    final sessions = ref.watch(punchSessionRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final now = DateTime.now();
                      final twoWeeksAgo = now.subtract(const Duration(days: 14));
                      
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: now,
                        initialDateRange: DateTimeRange(
                          start: twoWeeksAgo,
                          end: now,
                        ),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              datePickerTheme: DatePickerThemeData(
                                constraints: const BoxConstraints(
                                  maxWidth: 400,
                                  maxHeight: 400,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (range != null) {
                        // Enforce two weeks
                        final duration = range.end.difference(range.start);
                        if (duration.inDays > 14) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a range of 14 days or less'),
                            ),
                          );
                          return;
                        }
                        ref.read(selectedDateRangeProvider.notifier).state = range;
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      selectedRange != null
                          ? '${selectedRange.start.toString().split(' ')[0]} - ${selectedRange.end.toString().split(' ')[0]}'
                          : 'Select Date Range',
                    ),
                  ),
                ),
                if (selectedRange != null)
                  ElevatedButton(
                    onPressed: () {
                      final filteredSessions = sessions.where((session) {
                        return session.startTime.isAfter(selectedRange.start) &&
                               session.startTime.isBefore(selectedRange.end);
                      }).toList();
                      
                      showDialog(
                        context: context,
                        builder: (context) => ReportView(sessions: filteredSessions),
                      );
                    },
                    child: const Text('Generate'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 