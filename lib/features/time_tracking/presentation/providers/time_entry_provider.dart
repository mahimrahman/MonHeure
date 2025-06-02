import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mon_heure/features/time_tracking/domain/models/time_entry.dart';
import 'package:mon_heure/features/time_tracking/domain/repositories/time_entry_repository.dart';
import 'package:uuid/uuid.dart';

/// Provider for the time entry repository.
final timeEntryRepositoryProvider = Provider<TimeEntryRepository>((ref) {
  throw UnimplementedError('TimeEntryRepository not initialized');
});

/// State class for time entries.
class TimeEntryState {
  /// Creates a new instance of [TimeEntryState].
  const TimeEntryState({
    this.entries = const [],
    this.activeEntry,
    this.isLoading = false,
    this.error,
  });

  /// List of all time entries.
  final List<TimeEntry> entries;

  /// Currently active time entry, if any.
  final TimeEntry? activeEntry;

  /// Whether the state is currently loading.
  final bool isLoading;

  /// Error message, if any.
  final String? error;

  /// Creates a copy of this state with the given fields replaced.
  TimeEntryState copyWith({
    List<TimeEntry>? entries,
    TimeEntry? activeEntry,
    bool? isLoading,
    String? error,
  }) {
    return TimeEntryState(
      entries: entries ?? this.entries,
      activeEntry: activeEntry ?? this.activeEntry,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for managing time entries.
class TimeEntryNotifier extends StateNotifier<TimeEntryState> {
  /// Creates a new instance of [TimeEntryNotifier].
  TimeEntryNotifier(this._repository) : super(const TimeEntryState());

  final TimeEntryRepository _repository;
  final _uuid = const Uuid();

  /// Loads all time entries.
  Future<void> loadEntries() async {
    state = state.copyWith(isLoading: true);
    try {
      final entries = await _repository.getAllTimeEntries();
      final activeEntry = await _repository.getActiveTimeEntry();
      state = state.copyWith(
        entries: entries,
        activeEntry: activeEntry,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Toggles the timer (start/stop).
  Future<void> toggleTimer() async {
    if (state.activeEntry != null) {
      await _stopTimer();
    } else {
      await _startTimer();
    }
  }

  Future<void> _startTimer() async {
    final entry = TimeEntry(
      id: _uuid.v4(),
      startTime: DateTime.now(),
    );
    await _repository.saveTimeEntry(entry);
    state = state.copyWith(activeEntry: entry);
  }

  Future<void> _stopTimer() async {
    if (state.activeEntry == null) return;

    final updatedEntry = state.activeEntry!.copyWith(
      endTime: DateTime.now(),
    );
    await _repository.updateTimeEntry(updatedEntry);
    await loadEntries();
  }
}

/// Provider for the time entry state.
final timeEntryProvider =
    StateNotifierProvider<TimeEntryNotifier, TimeEntryState>((ref) {
  final repository = ref.watch(timeEntryRepositoryProvider);
  return TimeEntryNotifier(repository);
}); 