import 'package:freezed_annotation/freezed_annotation.dart';

part 'punch_session.freezed.dart';

/// Represents a punch session in the domain layer.
@freezed
class PunchSession with _$PunchSession {
  const factory PunchSession({
    required String id,
    required DateTime punchIn,
    DateTime? punchOut,
    String? note,
    @Default(false) bool isEdited,
  }) = _PunchSession;
} 