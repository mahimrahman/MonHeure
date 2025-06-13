import 'package:flutter/material.dart';
import 'package:mon_heure/features/time_tracking/domain/entities/punch_session.dart';
import 'package:mon_heure/features/time_tracking/domain/services/report_service.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReportView extends StatelessWidget {
  final List<PunchSession> sessions;
  final _reportService = ReportService();

  ReportView({super.key, required this.sessions});

  Future<void> _exportPdf(BuildContext context) async {
    try {
      final pdfBytes = await _reportService.generatePdf(sessions);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/report.pdf');
      await file.writeAsBytes(pdfBytes);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved to: ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }
  }

  Future<void> _exportCsv(BuildContext context) async {
    try {
      final csvContent = _reportService.generateCsv(sessions);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/report.csv');
      await file.writeAsString(csvContent);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV saved to: ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating CSV: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Time Tracking Report',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf),
                      onPressed: () => _exportPdf(context),
                      tooltip: 'Export as PDF',
                    ),
                    IconButton(
                      icon: const Icon(Icons.table_chart),
                      onPressed: () => _exportCsv(context),
                      tooltip: 'Export as CSV',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Start Time')),
                    DataColumn(label: Text('End Time')),
                    DataColumn(label: Text('Duration')),
                  ],
                  rows: sessions.map((session) {
                    final startTime = DateFormat('HH:mm').format(session.startTime);
                    final endTime = session.endTime != null
                        ? DateFormat('HH:mm').format(session.endTime!)
                        : 'Ongoing';
                    final duration = session.duration?.toString() ?? 'N/A';
                    
                    return DataRow(
                      cells: [
                        DataCell(Text(DateFormat('yyyy-MM-dd').format(session.startTime))),
                        DataCell(Text(startTime)),
                        DataCell(Text(endTime)),
                        DataCell(Text(duration)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 