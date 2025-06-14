import 'package:freezed_annotation/freezed_annotation.dart';

part 'punch_session.freezed.dart';
part 'punch_session.g.dart';

/// Represents a punch session in the domain layer.
@freezed
class PunchSession with _$PunchSession {
  const factory PunchSession({
    required String id,
    required DateTime startTime,
    DateTime? endTime,
    String? note,
    @Default(false) bool isEdited,
  }) = _PunchSession;

  factory PunchSession.fromJson(Map<String, dynamic> json) => _$PunchSessionFromJson(json);
} 