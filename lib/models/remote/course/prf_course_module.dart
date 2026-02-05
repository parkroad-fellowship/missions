import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/models/remote/course/prf_member_module.dart';
import 'package:app/models/remote/course/prf_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_course_module.freezed.dart';
part 'prf_course_module.g.dart';

@freezed
abstract class PRFCourseModule with _$PRFCourseModule {
  factory PRFCourseModule(
    String ulid,
    int order,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    PRFCourse? course,
    PRFModule? module,
    @JsonKey(name: 'member_module') PRFMemberModule? memberModule,
  }) = _PRFCourseModule;

  factory PRFCourseModule.fromJson(Map<String, dynamic> json) =>
      _$PRFCourseModuleFromJson(json);
}

@freezed
abstract class PRFCourseModuleResponse with _$PRFCourseModuleResponse {
  factory PRFCourseModuleResponse(List<PRFCourseModule> data) =
      _PRFCourseModuleResponse;

  factory PRFCourseModuleResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFCourseModuleResponseFromJson(json);
}
