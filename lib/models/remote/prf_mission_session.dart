import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/models/remote/prf_member.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission_session.freezed.dart';
part 'prf_mission_session.g.dart';

@freezed
class PRFMissionSession with _$PRFMissionSession {
  factory PRFMissionSession(
    String entity,
    String ulid,
    @JsonKey(name: 'starts_at') DateTime startsAt,
    @JsonKey(name: 'ends_at') DateTime endsAt,
    String notes, {
    @Default(0) int order,
    PRFMember? facilitator,
    PRFMember? speaker,
    PRFMission? mission,
    @JsonKey(name: 'class_group') PRFClassGroup? classGroup,
  }) = _PRFMissionSession;

  factory PRFMissionSession.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionSessionFromJson(json);
}

@freezed
class PRFMissionSessionsResponse with _$PRFMissionSessionsResponse {
  factory PRFMissionSessionsResponse(List<PRFMissionSession> data) =
      _PRFMissionSessionsResponse;

  factory PRFMissionSessionsResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionSessionsResponseFromJson(json);
}
