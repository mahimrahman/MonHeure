import 'package:hive/hive.dart';

part 'punch_session_entity.g.dart';

@HiveType(typeId: 0)
class PunchSessionEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime punchIn;

  @HiveField(2)
  final DateTime? punchOut;

  @HiveField(3)
  final String? note;

  @HiveField(4)
  final bool isEdited;

  PunchSessionEntity({
    required this.id,
    required this.punchIn,
    this.punchOut,
    this.note,
    this.isEdited = false,
  });
} 