import 'package:app/models/local/prf_course.dart';
import 'package:isar/isar.dart';

part 'prf_lesson_module.g.dart';

@collection
class PRFLocalLessonModule {
  PRFLocalLessonModule({
    required this.ulid,
    required this.order,
    required this.lessonUlid,
    required this.moduleUlid,
    required this.createdAt,
    required this.lesson,
    this.lessonMember,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String ulid;
  final int order;
  final String lessonUlid;
  final String moduleUlid;
  final DateTime createdAt;
  final PRFLocalLesson lesson;
  PRFLocalLessonMember? lessonMember;
}

@embedded
class PRFLocalLesson {
  PRFLocalLesson({
    this.ulid,
    this.name,
    this.description,
    this.type,
    this.createdAt,
    this.content,
    this.videoUrl,
    this.audioUrl,
    this.documentUrl,
    this.audios,
    this.documents,
    this.videos,
    this.thumbnail,
  });

  String? ulid;
  String? name;
  String? description;
  int? type;
  DateTime? createdAt;
  String? content;
  String? videoUrl;
  String? audioUrl;
  String? documentUrl;
  List<PRFLocalMedia>? audios;
  List<PRFLocalMedia>? documents;
  List<PRFLocalMedia>? videos;
  PRFLocalMedia? thumbnail;
}

@embedded
class PRFLocalLessonMember {
  PRFLocalLessonMember({
    this.ulid,
    this.completionStatus,
    this.createdAt,
    this.completedAt,
  });

  String? ulid;
  int? completionStatus;
  DateTime? createdAt;
  DateTime? completedAt;
}
