import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_class_group.freezed.dart';
part 'prf_class_group.g.dart';

@freezed
class PRFClassGroup with _$PRFClassGroup {
  factory PRFClassGroup(
    String ulid,
    String name,
    @JsonKey(name: 'is_active') int isActive,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
  ) = _PRFClassGroup;

  factory PRFClassGroup.fromJson(Map<String, dynamic> json) =>
      _$PRFClassGroupFromJson(json);
}

@freezed
class PRFClassGroupResponse with _$PRFClassGroupResponse {
  factory PRFClassGroupResponse(
    List<PRFClassGroup> data,
  ) = _PRFClassGroupResponse;

  factory PRFClassGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFClassGroupResponseFromJson(json);
}
