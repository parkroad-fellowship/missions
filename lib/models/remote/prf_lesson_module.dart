import 'package:app/models/remote/prf_lesson.dart';
import 'package:app/models/remote/prf_lesson_member.dart';
import 'package:app/models/remote/prf_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_lesson_module.freezed.dart';
part 'prf_lesson_module.g.dart';

@freezed
abstract class PRFLessonModule with _$PRFLessonModule {
  factory PRFLessonModule(
    String ulid,
    int order,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'lesson_member') PRFLessonMember? lessonMember,
    PRFLesson? lesson,
    PRFModule? module,
  }) = _PRFLessonModule;

  factory PRFLessonModule.fromJson(Map<String, dynamic> json) =>
      _$PRFLessonModuleFromJson(json);
}

@freezed
abstract class PRFLessonModuleResponse with _$PRFLessonModuleResponse {
  factory PRFLessonModuleResponse(List<PRFLessonModule> data) =
      _PRFLessonModuleResponse;

  factory PRFLessonModuleResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFLessonModuleResponseFromJson(json);
}
