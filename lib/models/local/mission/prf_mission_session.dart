import 'package:app/models/local/shared_embeds.dart';
import 'package:isar_community/isar.dart';

part 'prf_mission_session.g.dart';

@collection
class PRFLocalMissionSession {
  PRFLocalMissionSession({
    required this.ulid,
    required this.startsAt,
    required this.endsAt,
    required this.notes,
    required this.order,
    required this.facilitator,
    required this.missionUlid,
    required this.transcripts,
    this.classGroup,
    this.speaker,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String ulid;
  final DateTime startsAt;
  final DateTime endsAt;
  final String notes;
  final int order;
  final PRFLocalMember facilitator;
  final PRFLocalMember? speaker;
  final PRFLocalClassGroup? classGroup;
  @Index()
  final String missionUlid;
  final List<PRFLocalTranscript> transcripts;
}
