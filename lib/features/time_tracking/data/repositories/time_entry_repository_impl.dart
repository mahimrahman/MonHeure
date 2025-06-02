import 'package:hive/hive.dart';
import 'package:mon_heure/features/time_tracking/domain/models/time_entry.dart';
import 'package:mon_heure/features/time_tracking/domain/repositories/time_entry_repository.dart';

/// Implementation of [TimeEntryRepository] using Hive for local storage.
class TimeEntryRepositoryImpl implements TimeEntryRepository {
  /// Creates a new instance of [TimeEntryRepositoryImpl].
  TimeEntryRepositoryImpl(this._box);

  final Box<TimeEntry> _box;

  @override
  Future<void> saveTimeEntry(TimeEntry entry) async {
    await _box.put(entry.id, entry);
  }

  @override
  Future<List<TimeEntry>> getAllTimeEntries() async {
    return _box.values.toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  @override
  Future<List<TimeEntry>> getTimeEntriesInRange(
    DateTime start,
    DateTime end,
  ) async {
    return _box.values
        .where((entry) =>
            entry.startTime.isAfter(start) && entry.startTime.isBefore(end))
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  @override
  Future<void> updateTimeEntry(TimeEntry entry) async {
    await _box.put(entry.id, entry);
  }

  @override
  Future<void> deleteTimeEntry(String id) async {
    await _box.delete(id);
  }

  @override
  Future<TimeEntry?> getActiveTimeEntry() async {
    return _box.values.firstWhere(
      (entry) => entry.endTime == null,
      orElse: () => null as TimeEntry,
    );
  }
} 