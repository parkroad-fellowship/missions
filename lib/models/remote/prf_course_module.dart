import 'package:app/models/remote/prf_course.dart';
import 'package:app/models/remote/prf_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_course_module.freezed.dart';
part 'prf_course_module.g.dart';

@freezed
class PRFCourseModule with _$PRFCourseModule {
  factory PRFCourseModule(
    String ulid,
    int order,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    PRFCourse? course,
    PRFModule? module,
  }) = _PRFCourseModule;

  factory PRFCourseModule.fromJson(Map<String, dynamic> json) =>
      _$PRFCourseModuleFromJson(json);
}

@freezed
class PRFCourseModuleResponse with _$PRFCourseModuleResponse {
  factory PRFCourseModuleResponse(
    List<PRFCourseModule> data,
  ) = _PRFCourseModuleResponse;

  factory PRFCourseModuleResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFCourseModuleResponseFromJson(json);
}
