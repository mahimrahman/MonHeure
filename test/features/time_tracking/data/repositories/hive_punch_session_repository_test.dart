import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mon_heure/features/time_tracking/data/punch_session_entity.dart';
import 'package:mon_heure/features/time_tracking/data/repositories/hive_punch_session_repository.dart';
import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() {
  late HivePunchSessionRepository repository;
  late Box<PunchSessionEntity> box;

  setUp(() async {
    final directory = await path_provider.getTemporaryDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(PunchSessionEntityAdapter());
    box = await Hive.openBox<PunchSessionEntity>('punch_sessions');
    repository = HivePunchSessionRepository();
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  group('HivePunchSessionRepository', () {
    test('should add and retrieve a punch session', () async {
      final session = PunchSession(
        id: 'test-id',
        punchIn: DateTime.now(),
        punchOut: DateTime.now().add(const Duration(hours: 1)),
        note: 'Test note',
      );

      await repository.add(session);
      final sessions = await repository.fetchRange(
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now().add(const Duration(days: 1)),
      );

      expect(sessions.length, 1);
      expect(sessions.first.id, equals(session.id));
      expect(sessions.first.punchIn, equals(session.punchIn));
      expect(sessions.first.punchOut, equals(session.punchOut));
      expect(sessions.first.note, equals(session.note));
    });

    test('should update an existing punch session', () async {
      final session = PunchSession(
        id: 'test-id',
        punchIn: DateTime.now(),
        note: 'Original note',
      );

      await repository.add(session);

      final updatedSession = PunchSession(
        id: session.id,
        punchIn: session.punchIn,
        note: 'Updated note',
        isEdited: true,
      );

      await repository.update(updatedSession);
      final sessions = await repository.fetchRange(
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now().add(const Duration(days: 1)),
      );

      expect(sessions.length, 1);
      expect(sessions.first.note, equals('Updated note'));
      expect(sessions.first.isEdited, isTrue);
    });

    test('should stream updates to punch sessions', () async {
      final session = PunchSession(
        id: 'test-id',
        punchIn: DateTime.now(),
      );

      final stream = repository.watchAll();
      final futureSessions = stream.first;

      await repository.add(session);
      final sessions = await futureSessions;

      expect(sessions.length, 1);
      expect(sessions.first.id, equals(session.id));
    });

    test('should fetch sessions within date range', () async {
      final now = DateTime.now();
      final sessions = [
        PunchSession(
          id: '1',
          punchIn: now.subtract(const Duration(days: 2)),
        ),
        PunchSession(
          id: '2',
          punchIn: now,
        ),
        PunchSession(
          id: '3',
          punchIn: now.add(const Duration(days: 2)),
        ),
      ];

      for (final session in sessions) {
        await repository.add(session);
      }

      final fetchedSessions = await repository.fetchRange(
        now.subtract(const Duration(days: 1)),
        now.add(const Duration(days: 1)),
      );

      expect(fetchedSessions.length, 1);
      expect(fetchedSessions.first.id, equals('2'));
    });
  });
} 