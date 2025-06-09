import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/presentation/providers/punch_session_provider.dart';
import 'package:mon_heure/features/time_tracking/presentation/providers/punch_state_provider.dart';
import 'package:intl/intl.dart';

/// The main page of the application.
class HomePage extends ConsumerWidget {
  /// Creates a new instance of [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final punchState = ref.watch(punchStateProvider);
    final sessionsStream = ref.watch(punchSessionRepoProvider).watchAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MonHeure'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          _buildPunchButton(context, ref, punchState),
          const SizedBox(height: 32),
          Expanded(
            child: sessionsStream.when(
              data: (sessions) => _buildTimeline(context, sessions),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPunchButton(BuildContext context, WidgetRef ref, PunchState state) {
    final isPunchedIn = state.isPunchedIn;
    final buttonText = isPunchedIn ? 'Punch OUT' : 'Punch IN';
    final buttonColor = isPunchedIn ? Colors.red : Colors.green;

    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            ref.read(punchStateProvider.notifier).togglePunch();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
          ),
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, List<PunchSession> sessions) {
    final today = DateTime.now();
    final todaySessions = sessions.where((session) {
      final sessionDate = session.punchIn;
      return sessionDate.year == today.year &&
          sessionDate.month == today.month &&
          sessionDate.day == today.day;
    }).toList();

    if (todaySessions.isEmpty) {
      return Center(
        child: Text(
          'No sessions today',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: todaySessions.length,
      itemBuilder: (context, index) {
        final session = todaySessions[index];
        return _TimelineItem(session: session);
      },
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final PunchSession session;

  const _TimelineItem({required this.session});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final duration = session.punchOut?.difference(session.punchIn) ?? Duration.zero;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${timeFormat.format(session.punchIn)} - ${session.punchOut != null ? timeFormat.format(session.punchOut!) : '...'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (session.note != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      session.note!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            if (session.punchOut != null)
              Text(
                '$hours:${minutes.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
          ],
        ),
      ),
    );
  }
} 