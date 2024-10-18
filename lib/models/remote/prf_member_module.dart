import 'package:app/enums/prf_completion_status.dart';
import 'package:app/models/remote/prf_course.dart';
import 'package:app/models/remote/prf_member.dart';
import 'package:app/models/remote/prf_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_member_module.freezed.dart';
part 'prf_member_module.g.dart';

@freezed
class PRFMemberModule with _$PRFMemberModule {
  factory PRFMemberModule(
    String ulid,
    @JsonKey(name: 'percent_complete') double percentComplete,
    @JsonKey(name: 'completion_status') PRFCompletionStatus completionStatus,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    PRFCourse? course,
    PRFMember? member,
    PRFModule? module,
  }) = _PRFMemberModule;

  factory PRFMemberModule.fromJson(Map<String, dynamic> json) =>
      _$PRFMemberModuleFromJson(json);
}
