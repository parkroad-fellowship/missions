import 'package:app/enums/prf_completion_status.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:isar_community/isar.dart';

part 'prf_course.g.dart';

@collection
class PRFLocalCourse {
  PRFLocalCourse({
    required this.ulid,
    required this.name,
    required this.description,
    required this.createdAt,
    this.thumbnail,
    this.courseMember,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String ulid;
  late String name;
  late String description;
  late DateTime createdAt;
  PRFLocalMedia? thumbnail;
  PRFLocalCourseMember? courseMember;
}

@embedded
class PRFLocalCourseMember {
  PRFLocalCourseMember({
    this.ulid,
    this.percentComplete,
    this.completionStatus,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  String? ulid;
  double? percentComplete;
  @Enumerated(EnumType.name)
  PRFCompletionStatus? completionStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? completedAt;
}
