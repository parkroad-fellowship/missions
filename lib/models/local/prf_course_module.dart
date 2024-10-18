import 'package:app/enums/prf_completion_status.dart';
import 'package:app/models/local/prf_course.dart';
import 'package:isar/isar.dart';

part 'prf_course_module.g.dart';

@collection
class PRFLocalCourseModule {
  PRFLocalCourseModule({
    required this.ulid,
    required this.order,
    required this.courseUlid,
    required this.moduleUlid,
    required this.createdAt,
    required this.updatedAt,
    required this.module,
    this.memberModule,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String ulid;
  late String courseUlid;
  late String moduleUlid;
  late int order;
  late DateTime createdAt;
  late DateTime updatedAt;
  late PRFLocalModule module;
  PRFLocalMemberModule? memberModule;
}

@embedded
class PRFLocalModule {
  PRFLocalModule({
    this.ulid,
    this.name,
    this.description,
    this.createdAt,
    this.thumbnail,
  });

  String? ulid;
  String? name;
  String? description;
  DateTime? createdAt;
  PRFLocalMedia? thumbnail;
}

@embedded
class PRFLocalMemberModule {
  PRFLocalMemberModule({
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
