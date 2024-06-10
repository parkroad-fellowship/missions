import 'package:app/models/prf_class_group.dart';
import 'package:app/models/prf_mission.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_soul.freezed.dart';
part 'prf_soul.g.dart';

@freezed
class PRFSoul with _$PRFSoul {
  factory PRFSoul(
    String ulid,
    @JsonKey(name: 'full_name') String fullName,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    PRFMission? mission,
    @JsonKey(name: 'class_group') PRFClassGroup? classGroup,
  }) = _PRFSoul;

  factory PRFSoul.fromJson(Map<String, dynamic> json) =>
      _$PRFSoulFromJson(json);
}

@freezed
class PRFSoulResponse with _$PRFSoulResponse {
  const factory PRFSoulResponse({
    required List<PRFSoul> data,
  }) = _PRFSoulResponse;

  factory PRFSoulResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFSoulResponseFromJson(json);
}
