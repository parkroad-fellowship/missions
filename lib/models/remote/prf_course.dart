import 'package:app/models/remote/prf_course_member.dart';
import 'package:app/models/remote/prf_media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_course.freezed.dart';
part 'prf_course.g.dart';

@freezed
class PRFCourse with _$PRFCourse {
  factory PRFCourse(
    String ulid,
    String name,
    String slug,
    String description,
    @JsonKey(name: 'is_active') int isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    PRFMedia? thumbnail,
    @JsonKey(name: 'course_member') PRFCourseMember? courseMember,
  }) = _PRFCourse;

  factory PRFCourse.fromJson(Map<String, dynamic> json) =>
      _$PRFCourseFromJson(json);
}

@freezed
class PRFCourseResponse with _$PRFCourseResponse {
  factory PRFCourseResponse(
    List<PRFCourse> data,
  ) = _PRFCourseResponse;

  factory PRFCourseResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFCourseResponseFromJson(json);
}
