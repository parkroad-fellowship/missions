import 'package:app/enums/payment/prf_completion_status.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_course_member.freezed.dart';
part 'prf_course_member.g.dart';

@freezed
abstract class PRFCourseMember with _$PRFCourseMember {
  factory PRFCourseMember(
    String ulid,
    @JsonKey(name: 'percent_complete') double percentComplete,
    @JsonKey(name: 'completion_status') PRFCompletionStatus completionStatus,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    PRFCourse? course,
    PRFMember? member,
  }) = _PRFCourseMember;

  factory PRFCourseMember.fromJson(Map<String, dynamic> json) =>
      _$PRFCourseMemberFromJson(json);
}
