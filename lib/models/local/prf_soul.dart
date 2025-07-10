import 'package:app/enums/prf_soul_decision_type.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:isar/isar.dart';

part 'prf_soul.g.dart';

@collection
class PRFLocalSoul {
  PRFLocalSoul({
    required this.ulid,
    required this.fullName,
    required this.createdAt,
    required this.missionUlid,
    required this.classGroup,
    required this.decisionType,
    this.admissionNumber,
    this.notes,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String ulid;
  final String fullName;
  final DateTime createdAt;
  final String missionUlid;
  final PRFLocalClassGroup classGroup;
  @Enumerated(EnumType.ordinal32)
  final PRFSoulDecisionType decisionType;
  final String? admissionNumber;
  final String? notes;
  
}
