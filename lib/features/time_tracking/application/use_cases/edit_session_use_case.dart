import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/domain/repositories/punch_session_repository.dart';

class EditSessionUseCase {
  final PunchSessionRepository _repository;

  EditSessionUseCase(this._repository);

  Future<PunchSession> execute({
    required String id,
    required DateTime punchIn,
    DateTime? punchOut,
    String? note,
  }) async {
    final updatedSession = PunchSession(
      id: id,
      punchIn: punchIn,
      punchOut: punchOut,
      note: note,
      isEdited: true,
    );

    await _repository.update(updatedSession);
    return updatedSession;
  }
} 