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
    this.admissionNumber,
  });

  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  final String ulid;
  final String fullName;
  final String? admissionNumber;
  final DateTime createdAt;
  final String missionUlid;
  final PRFLocalClassGroup classGroup;
}
