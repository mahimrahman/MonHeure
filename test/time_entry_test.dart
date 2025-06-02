import 'package:flutter_test/flutter_test.dart';
import 'package:mon_heure/features/time_tracking/domain/models/time_entry.dart';

void main() {
  group('TimeEntry', () {
    test('should create a valid time entry', () {
      final entry = TimeEntry(
        id: '1',
        startTime: DateTime(2024, 1, 1, 10, 0),
      );

      expect(entry.id, '1');
      expect(entry.startTime, DateTime(2024, 1, 1, 10, 0));
      expect(entry.endTime, null);
      expect(entry.note, null);
    });

    test('should create a completed time entry', () {
      final entry = TimeEntry(
        id: '1',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 12, 0),
        note: 'Test entry',
      );

      expect(entry.id, '1');
      expect(entry.startTime, DateTime(2024, 1, 1, 10, 0));
      expect(entry.endTime, DateTime(2024, 1, 1, 12, 0));
      expect(entry.note, 'Test entry');
    });

    test('should calculate duration correctly', () {
      final entry = TimeEntry(
        id: '1',
        startTime: DateTime(2024, 1, 1, 10, 0),
        endTime: DateTime(2024, 1, 1, 12, 0),
      );

      final duration = entry.endTime!.difference(entry.startTime);
      expect(duration.inHours, 2);
    });
  });
} 