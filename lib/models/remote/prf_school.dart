import 'package:app/models/remote/prf_contact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_school.freezed.dart';
part 'prf_school.g.dart';

@freezed
class PRFSchool with _$PRFSchool {
  factory PRFSchool(
    String ulid,
    String name,
    @JsonKey(name: 'total_students') int totalStudents,
    String address,
    double latitude,
    double longitude,
    @JsonKey(name: 'is_active') int isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @Default('N/A') String description,
    @Default('N/A') String directions,
    @Default('N/A') String distance,
    @Default('N/A') @JsonKey(name: 'static_duration') String staticDuration,
    @JsonKey(name: 'school_contacts') List<PRFContact>? contacts,
  }) = _PRFSchool;

  factory PRFSchool.fromJson(Map<String, dynamic> json) =>
      _$PRFSchoolFromJson(json);
}
