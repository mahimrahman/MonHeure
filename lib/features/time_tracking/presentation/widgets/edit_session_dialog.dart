import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/punch_session.dart';

class EditSessionDialog extends StatefulWidget {
  final PunchSession session;
  final Function(PunchSession) onSave;
  final VoidCallback onDelete;

  const EditSessionDialog({
    super.key,
    required this.session,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditSessionDialog> createState() => _EditSessionDialogState();
}

class _EditSessionDialogState extends State<EditSessionDialog> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _startTime = TimeOfDay.fromDateTime(widget.session.startTime);
    _endTime = TimeOfDay.fromDateTime(widget.session.endTime ?? DateTime.now());
    _noteController = TextEditingController(text: widget.session.note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Session'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Start Time'),
              trailing: TextButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _startTime,
                  );
                  if (picked != null) {
                    setState(() => _startTime = picked);
                  }
                },
                child: Text(_startTime.format(context)),
              ),
            ),
            ListTile(
              title: const Text('End Time'),
              trailing: TextButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _endTime,
                  );
                  if (picked != null) {
                    setState(() => _endTime = picked);
                  }
                },
                child: Text(_endTime.format(context)),
              ),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                hintText: 'Add a note about this session',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onDelete,
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final now = DateTime.now();
            final startDateTime = DateTime(
              now.year,
              now.month,
              now.day,
              _startTime.hour,
              _startTime.minute,
            );
            final endDateTime = DateTime(
              now.year,
              now.month,
              now.day,
              _endTime.hour,
              _endTime.minute,
            );

            widget.onSave(
              PunchSession(
                id: widget.session.id,
                startTime: startDateTime,
                endTime: endDateTime,
                note: _noteController.text.isEmpty ? null : _noteController.text,
                isEdited: true,
              ),
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
} 