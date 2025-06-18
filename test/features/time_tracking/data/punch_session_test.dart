import 'package:flutter_test/flutter_test.dart';
import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/data/punch_session_entity.dart';

void main() {
  group('PunchSession', () {
    test('should serialize and deserialize correctly', () {
      final now = DateTime.now();
      final session = PunchSession(
        id: 'test-id',
        startTime: now,
        endTime: now.add(const Duration(hours: 1)),
        note: 'Test note',
        isEdited: true,
      );

      final json = session.toJson();
      final fromJson = PunchSession.fromJson(json);

      expect(fromJson, equals(session));
    });

    test('should handle null values and default isEdited', () {
      final now = DateTime.now();
      final session = PunchSession(
        id: 'test-id',
        startTime: now,
      );

      final json = session.toJson();
      final fromJson = PunchSession.fromJson(json);

      expect(fromJson.id, equals(session.id));
      expect(fromJson.startTime, equals(session.startTime));
      expect(fromJson.endTime, isNull);
      expect(fromJson.note, isNull);
      expect(fromJson.isEdited, isFalse);
    });

    test('should convert to and from entity', () {
      final now = DateTime.now();
      final session = PunchSession(
        id: 'test-id',
        startTime: now,
        endTime: now.add(const Duration(hours: 1)),
        note: 'Test note',
        isEdited: true,
      );
      final entity = session.toEntity();
      final fromEntity = PunchSession.fromEntity(entity);
      expect(fromEntity, equals(session));
    });
  });
} 