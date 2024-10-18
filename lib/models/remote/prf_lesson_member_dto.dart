import 'package:app/enums/prf_completion_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_lesson_member_dto.freezed.dart';
part 'prf_lesson_member_dto.g.dart';

@freezed
class PRFLessonMemberDTO with _$PRFLessonMemberDTO {
  factory PRFLessonMemberDTO({
    @JsonKey(name: 'lesson_ulid') required String lessonUlid,
    @JsonKey(name: 'module_ulid') required String moduleUlid,
    @JsonKey(name: 'course_ulid') required String courseUlid,
    @JsonKey(name: 'member_ulid') required String memberUlid,
    @JsonKey(name: 'completion_status')
    required PRFCompletionStatus completionStatus,
  }) = _PRFLessonMemberDTO;

  factory PRFLessonMemberDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFLessonMemberDTOFromJson(json);
}
