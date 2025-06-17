import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:intl/intl.dart';

class ReportService {
  Future<Uint8List> generatePdf(List<PunchSession> sessions) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Time Tracking Report'),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Date', 'Start Time', 'End Time', 'Duration'],
                data: sessions.map((session) {
                  final startTime = DateFormat('HH:mm').format(session.startTime);
                  final endTime = session.endTime != null
                      ? DateFormat('HH:mm').format(session.endTime!)
                      : 'Ongoing';
                  final duration = session.endTime != null
                      ? _formatDuration(session.endTime!.difference(session.startTime))
                      : 'N/A';
                  
                  return [
                    DateFormat('yyyy-MM-dd').format(session.startTime),
                    startTime,
                    endTime,
                    duration,
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  String generateCsv(List<PunchSession> sessions) {
    final buffer = StringBuffer();
    
    // Add headers
    buffer.writeln('Date,Start Time,End Time,Duration');
    
    // Add data rows
    for (final session in sessions) {
      final startTime = DateFormat('HH:mm').format(session.startTime);
      final endTime = session.endTime != null
          ? DateFormat('HH:mm').format(session.endTime!)
          : 'Ongoing';
      final duration = session.endTime != null
          ? _formatDuration(session.endTime!.difference(session.startTime))
          : 'N/A';
      
      buffer.writeln(
        '${DateFormat('yyyy-MM-dd').format(session.startTime)},'
        '$startTime,'
        '$endTime,'
        '$duration',
      );
    }
    
    return buffer.toString();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
} 