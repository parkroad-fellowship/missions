import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission_subscription_update_dto.freezed.dart';
part 'prf_mission_subscription_update_dto.g.dart';

@freezed
class PRFMissionSubscriptionUpdateDTO with _$PRFMissionSubscriptionUpdateDTO {
  factory PRFMissionSubscriptionUpdateDTO({
    @JsonKey(name: 'mission_ulid') required String missionUlid,
    @JsonKey(name: 'member_ulid') required String memberUlid,
    required int status,
  }) = _PRFMissionSubscriptionUpdateDTO;

  factory PRFMissionSubscriptionUpdateDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionSubscriptionUpdateDTOFromJson(json);
}
