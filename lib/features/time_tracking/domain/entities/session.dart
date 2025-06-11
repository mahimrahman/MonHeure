class Session {
  final DateTime startTime;
  final DateTime endTime;
  final String? note;

  const Session({
    required this.startTime,
    required this.endTime,
    this.note,
  });

  Duration get duration => endTime.difference(startTime);

  Session copyWith({
    DateTime? startTime,
    DateTime? endTime,
    String? note,
  }) {
    return Session(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      note: note ?? this.note,
    );
  }
} 