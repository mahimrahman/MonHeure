import 'package:flutter_test/flutter_test.dart';
import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/domain/services/report_service.dart';

void main() {
  group('ReportService', () {
    late ReportService reportService;
    late List<PunchSession> testSessions;

    setUp(() {
      reportService = ReportService();
      testSessions = [
        PunchSession(
          id: '1',
          startTime: DateTime(2024, 1, 1, 9, 0),
          endTime: DateTime(2024, 1, 1, 17, 0),
        ),
        PunchSession(
          id: '2',
          startTime: DateTime(2024, 1, 2, 9, 0),
          endTime: DateTime(2024, 1, 2, 17, 0),
        ),
      ];
    });

    test('generatePdf returns non-empty bytes', () async {
      final pdfBytes = await reportService.generatePdf(testSessions);
      expect(pdfBytes.length, greaterThan(0));
    });

    test('generateCsv returns non-empty string', () {
      final csvContent = reportService.generateCsv(testSessions);
      expect(csvContent.length, greaterThan(0));
      expect(csvContent, contains('Date,Start Time,End Time,Duration'));
    });
  });
} 