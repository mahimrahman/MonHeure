import 'package:mon_heure/features/time_tracking/domain/models/time_entry.dart';

/// Repository interface for managing time entries.
abstract class TimeEntryRepository {
  /// Saves a time entry to the local storage.
  Future<void> saveTimeEntry(TimeEntry entry);

  /// Retrieves all time entries.
  Future<List<TimeEntry>> getAllTimeEntries();

  /// Retrieves time entries within a date range.
  Future<List<TimeEntry>> getTimeEntriesInRange(
    DateTime start,
    DateTime end,
  );

  /// Updates an existing time entry.
  Future<void> updateTimeEntry(TimeEntry entry);

  /// Deletes a time entry by its ID.
  Future<void> deleteTimeEntry(String id);

  /// Gets the current active time entry, if any.
  Future<TimeEntry?> getActiveTimeEntry();
} 