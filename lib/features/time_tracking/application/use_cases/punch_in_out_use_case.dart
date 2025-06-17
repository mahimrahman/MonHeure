import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/domain/repositories/punch_session_repository.dart';
import 'package:uuid/uuid.dart';

class PunchInOutUseCase {
  final PunchSessionRepository _repository;
  final _uuid = const Uuid();

  PunchInOutUseCase(this._repository);

  Future<PunchSession?> execute() async {
    final sessions = await _repository.fetchRange(
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 1)),
    );

    // Find any open session
    PunchSession? openSession;
    try {
      openSession = sessions.firstWhere(
        (session) => session.endTime == null,
      );
    } catch (e) {
      openSession = null;
    }

    if (openSession != null) {
      // Close the open session
      final closedSession = PunchSession(
        id: openSession.id,
        startTime: openSession.startTime,
        endTime: DateTime.now(),
        note: openSession.note,
        isEdited: openSession.isEdited,
      );
      await _repository.update(closedSession);
      return closedSession;
    } else {
      // Create a new session
      final newSession = PunchSession(
        id: _uuid.v4(),
        startTime: DateTime.now(),
      );
      await _repository.add(newSession);
      return newSession;
    }
  }
} 