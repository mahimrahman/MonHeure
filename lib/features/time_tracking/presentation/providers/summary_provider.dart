import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mon_heure/features/time_tracking/application/use_cases/get_summary_use_case.dart';
import 'package:mon_heure/features/time_tracking/presentation/providers/punch_session_provider.dart';

final summaryProvider = FutureProvider<TimeSummary>((ref) async {
  final repository = ref.watch(punchSessionRepoProvider);
  final useCase = GetSummaryUseCase(repository);
  return useCase.execute();
}); 