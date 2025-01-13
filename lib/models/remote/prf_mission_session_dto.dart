import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission_session_dto.freezed.dart';
part 'prf_mission_session_dto.g.dart';

@freezed
class PRFMissionSessionDTO with _$PRFMissionSessionDTO {
  factory PRFMissionSessionDTO({
    @JsonKey(name: 'mission_ulid') required String missionUlid,
    @JsonKey(name: 'facilitator_ulid') required String facilitatorUlid,
    @JsonKey(name: 'speaker_ulid', includeIfNull: false) String? speakerUlid,
    @JsonKey(name: 'class_group_ulid', includeIfNull: false)
    String? classGroupUlid,
    @JsonKey(name: 'starts_at') required String startsAt,
    @JsonKey(name: 'ends_at') required String endsAt,
    required String notes,
    @Default(0) int order,
  }) = _PRFMissionSessionDTO;

  factory PRFMissionSessionDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionSessionDTOFromJson(json);
}
