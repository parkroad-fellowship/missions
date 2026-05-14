import 'package:app/models/local/shared_embeds.dart';
import 'package:isar_community/isar.dart';

part 'prf_mission_question.g.dart';

@collection
class PRFLocalMissionQuestion {
  PRFLocalMissionQuestion({
    required this.ulid,
    required this.question,
    required this.createdAt,
    required this.missionUlid,
    required this.transcripts,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String ulid;
  final String question;
  final DateTime createdAt;
  @Index()
  final String missionUlid;
  final List<PRFLocalTranscript> transcripts;
}
