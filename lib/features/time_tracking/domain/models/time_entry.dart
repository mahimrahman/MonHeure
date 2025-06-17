import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'time_entry.freezed.dart';
part 'time_entry.g.dart';

/// Represents a single time entry in the application.
@freezed
@HiveType(typeId: 1)
class TimeEntry with _$TimeEntry {
  /// Creates a new instance of [TimeEntry].
  const factory TimeEntry({
    /// Unique identifier for the time entry.
    @HiveField(0) required String id,
    
    /// The start time of the entry.
    @HiveField(1) required DateTime startTime,
    
    /// The end time of the entry, if the entry is completed.
    @HiveField(2) DateTime? endTime,
    
    /// Optional note for the time entry.
    @HiveField(3) String? note,
  }) = _TimeEntry;

  /// Creates a [TimeEntry] from a JSON map.
  factory TimeEntry.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryFromJson(json);
} 