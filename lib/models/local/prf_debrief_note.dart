import 'package:isar/isar.dart';

part 'prf_debrief_note.g.dart';

@collection
class PRFLocalDebriefNote {
  PRFLocalDebriefNote({
    required this.ulid,
    required this.note,
    required this.createdAt,
    required this.missionUlid,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String ulid;
  final String note;
  final DateTime createdAt;
  final String missionUlid;
}
