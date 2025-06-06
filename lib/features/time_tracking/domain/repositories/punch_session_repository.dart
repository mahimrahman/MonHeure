import '../entities/punch_session.dart';

/// Repository interface for managing punch sessions.
abstract class PunchSessionRepository {
  /// Adds a new punch session.
  Future<void> add(PunchSession session);

  /// Updates an existing punch session.
  Future<void> update(PunchSession session);

  /// Streams all punch sessions.
  Stream<List<PunchSession>> watchAll();

  /// Fetches punch sessions within a date range.
  Future<List<PunchSession>> fetchRange(DateTime from, DateTime to);
} 