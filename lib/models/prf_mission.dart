import 'package:app/models/prf_mission_type.dart';
import 'package:app/models/prf_school.dart';
import 'package:app/models/prf_school_term.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission.freezed.dart';
part 'prf_mission.g.dart';

@freezed
class PRFMission with _$PRFMission {
  factory PRFMission(
    String ulid,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'start_time') String startTime,
    @JsonKey(name: 'end_date') DateTime endDate,
    @JsonKey(name: 'end_time') String endTime,
    int capacity,
    @JsonKey(name: 'mission_prep_notes') String missionPrepNotes,
    int status,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'logged_in_member_has_subscribed')
    required bool loggedInMemberHasSubscribed,
    @Default('Open Topic') String? theme,
    PRFSchool? school,
    @JsonKey(name: 'school_term') PRFSchoolTerm? schoolTerm,
    @JsonKey(name: 'mission_type') PRFMissionType? missionType,
  }) = _PRFMission;

  factory PRFMission.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionFromJson(json);
}

@freezed
class PRFMissionsResponse with _$PRFMissionsResponse {
  factory PRFMissionsResponse(
    List<PRFMission> data,
  ) = _PRFMissionsResponse;

  factory PRFMissionsResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionsResponseFromJson(json);
}
