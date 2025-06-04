import 'package:freezed_annotation/freezed_annotation.dart';
import 'punch_session_entity.dart';

part 'punch_session.freezed.dart';
part 'punch_session.g.dart';

/// Represents a single punch session in the application.
@freezed
class PunchSession with _$PunchSession {
  /// Creates a new instance of [PunchSession].
  const factory PunchSession({
    /// Unique identifier for the punch session.
    required String id,
    
    /// The time when the user punched in.
    required DateTime punchIn,
    
    /// The time when the user punched out, if the session is completed.
    DateTime? punchOut,
    
    /// Optional note for the punch session.
    String? note,
    
    /// Whether the session has been edited.
    @Default(false) bool isEdited,
  }) = _PunchSession;

  /// Creates a [PunchSession] from a JSON map.
  factory PunchSession.fromJson(Map<String, dynamic> json) =>
      _$PunchSessionFromJson(json);

  factory PunchSession.fromEntity(PunchSessionEntity entity) => PunchSession(
    id: entity.id,
    punchIn: entity.punchIn,
    punchOut: entity.punchOut,
    note: entity.note,
    isEdited: entity.isEdited,
  );

  PunchSessionEntity toEntity() => PunchSessionEntity(
    id: id,
    punchIn: punchIn,
    punchOut: punchOut,
    note: note,
    isEdited: isEdited,
  );
} 