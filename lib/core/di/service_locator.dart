import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mon_heure/features/time_tracking/data/repositories/time_entry_repository_impl.dart';
import 'package:mon_heure/features/time_tracking/domain/models/time_entry.dart';
import 'package:mon_heure/features/time_tracking/domain/repositories/time_entry_repository.dart';
import 'package:mon_heure/features/time_tracking/presentation/providers/time_entry_provider.dart';

/// Initializes all dependencies and services.
Future<void> initializeDependencies() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TimeEntryAdapter());
  await Hive.openBox<TimeEntry>('time_entries');
}

/// Sets up all providers.
void setupProviders(ProviderContainer container) {
  container.updateOverrides([
    timeEntryRepositoryProvider.overrideWithValue(
      TimeEntryRepositoryImpl(
        Hive.box<TimeEntry>('time_entries'),
      ),
    ),
  ]);
} 