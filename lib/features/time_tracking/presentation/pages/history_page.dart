import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../widgets/edit_session_dialog.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Session>> _sessions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session History'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showSessionsForDay(selectedDay);
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }

  void _showSessionsForDay(DateTime day) {
    final sessions = _sessions[day] ?? [];
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('EEEE, MMMM d').format(day),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (sessions.isEmpty)
              const Text('No sessions recorded for this day')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return ListTile(
                      title: Text(
                        '${DateFormat.jm().format(session.startTime)} - ${DateFormat.jm().format(session.endTime)}',
                      ),
                      subtitle: session.note != null
                          ? Text(session.note!)
                          : null,
                      onLongPress: () => _showEditSessionDialog(session),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showEditSessionDialog(Session session) {
    showDialog(
      context: context,
      builder: (context) => EditSessionDialog(
        session: session,
        onSave: (updatedSession) {
          // TODO: Implement session update logic
        },
        onDelete: () {
          // TODO: Implement session deletion logic
        },
      ),
    );
  }
}

class Session {
  final DateTime startTime;
  final DateTime endTime;
  final String? note;

  Session({
    required this.startTime,
    required this.endTime,
    this.note,
  });
} 