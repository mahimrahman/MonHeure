import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mon_heure/features/time_tracking/application/use_cases/punch_in_out_use_case.dart';
import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/presentation/providers/punch_session_provider.dart';

class PunchState {
  final bool isPunchedIn;
  final PunchSession? currentSession;

  const PunchState({
    required this.isPunchedIn,
    this.currentSession,
  });
}

class PunchStateNotifier extends StateNotifier<PunchState> {
  final PunchInOutUseCase _punchInOutUseCase;

  PunchStateNotifier(this._punchInOutUseCase) : super(const PunchState(isPunchedIn: false));

  Future<void> togglePunch() async {
    try {
      final session = await _punchInOutUseCase.execute();
      state = PunchState(
        isPunchedIn: session?.punchOut == null,
        currentSession: session,
      );
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }
}

final punchStateProvider = StateNotifierProvider<PunchStateNotifier, PunchState>((ref) {
  final repository = ref.watch(punchSessionRepoProvider);
  return PunchStateNotifier(PunchInOutUseCase(repository));
}); 