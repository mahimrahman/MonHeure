import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mon_heure/features/time_tracking/application/use_cases/punch_in_out_use_case.dart';
import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/domain/repositories/punch_session_repository.dart';

class MockPunchSessionRepository extends Mock implements PunchSessionRepository {}

void main() {
  late PunchInOutUseCase useCase;
  late MockPunchSessionRepository mockRepository;

  setUp(() {
    mockRepository = MockPunchSessionRepository();
    useCase = PunchInOutUseCase(mockRepository);
  });

  group('PunchInOutUseCase', () {
    test('should create new session when no open session exists', () async {
      when(mockRepository.fetchRange(any, any)).thenAnswer((_) async => []);

      final result = await useCase.execute();

      expect(result?.punchOut, isNull);
      verify(mockRepository.add(any)).called(1);
    });

    test('should close existing session when one is open', () async {
      final openSession = PunchSession(
        id: 'test-id',
        punchIn: DateTime.now().subtract(const Duration(hours: 1)),
      );

      when(mockRepository.fetchRange(any, any))
          .thenAnswer((_) async => [openSession]);

      final result = await useCase.execute();

      expect(result?.punchOut, isNotNull);
      verify(mockRepository.update(any)).called(1);
    });

    test('should handle midnight crossover correctly', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final openSession = PunchSession(
        id: 'test-id',
        punchIn: yesterday,
      );

      when(mockRepository.fetchRange(any, any))
          .thenAnswer((_) async => [openSession]);

      final result = await useCase.execute();

      expect(result?.punchOut, isNotNull);
      expect(result?.punchIn, equals(yesterday));
      verify(mockRepository.update(any)).called(1);
    });

    test('should prevent double-punch-in', () async {
      final openSession = PunchSession(
        id: 'test-id',
        punchIn: DateTime.now().subtract(const Duration(minutes: 1)),
      );

      when(mockRepository.fetchRange(any, any))
          .thenAnswer((_) async => [openSession]);

      final result = await useCase.execute();

      expect(result?.punchOut, isNotNull);
      verify(mockRepository.update(any)).called(1);
      verifyNever(mockRepository.add(any));
    });
  });
} 