import 'package:app/models/local/prf_course.dart';
import 'package:isar/isar.dart';

part 'prf_course_module.g.dart';

@collection
class PRFLocalCourseModule {
  PRFLocalCourseModule({
    required this.ulid,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    required this.courseUlid,
    required this.module,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String ulid;
  late String courseUlid;
  late int order;
  late DateTime createdAt;
  late DateTime updatedAt;
  late PRFLocalModule module;
}

//     @JsonKey(name: 'lesson_modules') List<PRFLessonModule>? lessonModules,

@embedded
class PRFLocalModule {
  PRFLocalModule({
    this.ulid,
    this.name,
    this.slug,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.thumbnail,
    this.memberModule,
    // this.lessonModules,
  });

  String? ulid;
  String? name;
  String? slug;
  String? description;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  PRFLocalMedia? thumbnail;
  PRFLocalMemberModule? memberModule;
  // List<PRFLocalLessonModule>? lessonModules;
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
  int? completionStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? completedAt;
}
