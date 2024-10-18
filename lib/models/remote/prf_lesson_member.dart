import 'package:app/enums/prf_completion_status.dart';
import 'package:app/models/remote/prf_course.dart';
import 'package:app/models/remote/prf_lesson.dart';
import 'package:app/models/remote/prf_member.dart';
import 'package:app/models/remote/prf_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_lesson_member.freezed.dart';
part 'prf_lesson_member.g.dart';

@freezed
class PRFLessonMember with _$PRFLessonMember {
  factory PRFLessonMember(
    String ulid,
    @JsonKey(name: 'completion_status') PRFCompletionStatus completionStatus,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    PRFModule? module,
    PRFCourse? course,
    PRFMember? member,
    PRFLesson? lesson,
  }) = _PRFLessonMember;

  factory PRFLessonMember.fromJson(Map<String, dynamic> json) =>
      _$PRFLessonMemberFromJson(json);
}
