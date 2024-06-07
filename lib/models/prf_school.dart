import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_school.freezed.dart';
part 'prf_school.g.dart';

@freezed
class PRFSchool with _$PRFSchool {
  factory PRFSchool(
    String ulid,
    @JsonKey(name: 'total_students') int totalStudents,
    String address,
    double latitude,
    double longitude,
    @JsonKey(name: 'is_active') int isActive,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt, {
    String? description,
    String? directions,
  }) = _PRFSchool;

  factory PRFSchool.fromJson(Map<String, dynamic> json) =>
      _$PRFSchoolFromJson(json);
}
