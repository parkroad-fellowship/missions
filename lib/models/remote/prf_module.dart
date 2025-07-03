import 'package:app/models/remote/prf_lesson_module.dart';
import 'package:app/models/remote/prf_media.dart';
import 'package:app/models/remote/prf_member_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_module.freezed.dart';
part 'prf_module.g.dart';

@freezed
abstract class PRFModule with _$PRFModule {
  factory PRFModule(
    String ulid,
    String name,
    String slug,
    String description,
    @JsonKey(name: 'is_active') int isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    PRFMedia? thumbnail,
    @JsonKey(name: 'member_module') PRFMemberModule? memberModule,
    @JsonKey(name: 'lesson_modules') List<PRFLessonModule>? lessonModules,
  }) = _PRFModule;

  factory PRFModule.fromJson(Map<String, dynamic> json) =>
      _$PRFModuleFromJson(json);
}
