import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/domain/repositories/punch_session_repository.dart';

class TimeSummary {
  final Duration last7Days;
  final Duration last14Days;
  final Duration last30Days;
  final Duration last365Days;

  const TimeSummary({
    required this.last7Days,
    required this.last14Days,
    required this.last30Days,
    required this.last365Days,
  });
}

class GetSummaryUseCase {
  final PunchSessionRepository _repository;

  GetSummaryUseCase(this._repository);

  Future<TimeSummary> execute() async {
    final now = DateTime.now();
    final sessions = await _repository.fetchRange(
      now.subtract(const Duration(days: 365)),
      now,
    );

    return TimeSummary(
      last7Days: _calculateTotalTime(sessions, now.subtract(const Duration(days: 7))),
      last14Days: _calculateTotalTime(sessions, now.subtract(const Duration(days: 14))),
      last30Days: _calculateTotalTime(sessions, now.subtract(const Duration(days: 30))),
      last365Days: _calculateTotalTime(sessions, now.subtract(const Duration(days: 365))),
    );
  }

  Duration _calculateTotalTime(List<PunchSession> sessions, DateTime startDate) {
    return sessions
        .where((session) => session.startTime.isAfter(startDate))
        .fold<Duration>(
          Duration.zero,
          (total, session) {
            if (session.endTime == null) return total;
            return total + session.endTime!.difference(session.startTime);
          },
        );
  }
} 