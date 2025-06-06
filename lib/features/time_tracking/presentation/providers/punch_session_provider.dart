import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mon_heure/features/time_tracking/data/repositories/hive_punch_session_repository.dart';
import 'package:mon_heure/features/time_tracking/domain/repositories/punch_session_repository.dart';

/// Provider for the [PunchSessionRepository].
final punchSessionRepoProvider = Provider<PunchSessionRepository>((ref) {
  return HivePunchSessionRepository();
}); 