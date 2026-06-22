import 'package:app/enums/member/prf_institution_type.dart';
import 'package:app/models/remote/member/prf_contact.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_school.freezed.dart';
part 'prf_school.g.dart';

@freezed
abstract class PRFSchool with _$PRFSchool {
  factory PRFSchool(
    String ulid,
    String name,
    @JsonKey(name: 'total_students') int totalStudents,
    @JsonKey(name: 'institution_type') PRFInstitutionType institutionType,
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
    @Default([]) @JsonKey(name: 'school_contacts') List<PRFContact> contacts,
    @Default([]) List<PRFMission> missions,
  }) = _PRFSchool;

  factory PRFSchool.fromJson(Map<String, dynamic> json) =>
      _$PRFSchoolFromJson(json);
}

@freezed
abstract class PRFSchoolsResponse with _$PRFSchoolsResponse {
  factory PRFSchoolsResponse(List<PRFSchool> data) = _PRFSchoolsResponse;

  factory PRFSchoolsResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFSchoolsResponseFromJson(json);
}
