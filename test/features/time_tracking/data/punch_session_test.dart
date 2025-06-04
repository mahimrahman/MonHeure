import 'package:flutter_test/flutter_test.dart';
import 'package:mon_heure/features/time_tracking/data/punch_session.dart';
import 'package:mon_heure/features/time_tracking/data/punch_session_entity.dart';

void main() {
  group('PunchSession', () {
    test('should serialize and deserialize correctly', () {
      final now = DateTime.now();
      final session = PunchSession(
        id: 'test-id',
        punchIn: now,
        punchOut: now.add(const Duration(hours: 1)),
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
        punchIn: now,
      );

      final json = session.toJson();
      final fromJson = PunchSession.fromJson(json);

      expect(fromJson.id, equals(session.id));
      expect(fromJson.punchIn, equals(session.punchIn));
      expect(fromJson.punchOut, isNull);
      expect(fromJson.note, isNull);
      expect(fromJson.isEdited, isFalse);
    });

    test('should convert to and from entity', () {
      final now = DateTime.now();
      final session = PunchSession(
        id: 'test-id',
        punchIn: now,
        punchOut: now.add(const Duration(hours: 1)),
        note: 'Test note',
        isEdited: true,
      );
      final entity = session.toEntity();
      final fromEntity = PunchSession.fromEntity(entity);
      expect(fromEntity, equals(session));
    });
  });
} 