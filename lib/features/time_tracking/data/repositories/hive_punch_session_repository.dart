import 'package:hive/hive.dart';
import 'package:mon_heure/features/time_tracking/data/punch_session_entity.dart';
import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/domain/repositories/punch_session_repository.dart';

/// Hive implementation of [PunchSessionRepository].
class HivePunchSessionRepository implements PunchSessionRepository {
  static const String _boxName = 'punch_sessions';

  Future<Box<PunchSessionEntity>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<PunchSessionEntity>(_boxName);
    }
    return Hive.box<PunchSessionEntity>(_boxName);
  }

  @override
  Future<void> add(PunchSession session) async {
    final box = await _getBox();
    final entity = PunchSessionEntity(
      id: session.id,
      punchIn: session.punchIn,
      punchOut: session.punchOut,
      note: session.note,
      isEdited: session.isEdited,
    );
    await box.put(session.id, entity);
  }

  @override
  Future<void> update(PunchSession session) async {
    await add(session); // Hive's put method updates if key exists
  }

  @override
  Stream<List<PunchSession>> watchAll() async* {
    final box = await _getBox();
    yield* box.watch().map((_) {
      return box.values.map((entity) => PunchSession(
        id: entity.id,
        punchIn: entity.punchIn,
        punchOut: entity.punchOut,
        note: entity.note,
        isEdited: entity.isEdited,
      )).toList();
    });
  }

  @override
  Future<List<PunchSession>> fetchRange(DateTime from, DateTime to) async {
    final box = await _getBox();
    return box.values
        .where((entity) => 
            entity.punchIn.isAfter(from.subtract(const Duration(days: 1))) &&
            entity.punchIn.isBefore(to.add(const Duration(days: 1))))
        .map((entity) => PunchSession(
          id: entity.id,
          punchIn: entity.punchIn,
          punchOut: entity.punchOut,
          note: entity.note,
          isEdited: entity.isEdited,
        ))
        .toList();
  }
} 