import 'package:app/enums/prf_mission_role.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/remote/prf_member.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission_subscription.freezed.dart';
part 'prf_mission_subscription.g.dart';

@freezed
class PRFMissionSubscription with _$PRFMissionSubscription {
  factory PRFMissionSubscription(
    String ulid,
    PRFMissionSubscriptionStatus status,
    @JsonKey(name: 'mission_role') PRFMissionRole missionRole,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    PRFMission? mission,
    PRFMember? member,
  }) = _PRFMissionSubscription;

  factory PRFMissionSubscription.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionSubscriptionFromJson(json);
}

@freezed
class PRFMissionSubscriptionsResponse with _$PRFMissionSubscriptionsResponse {
  factory PRFMissionSubscriptionsResponse(List<PRFMissionSubscription> data) =
      _PRFMissionSubscriptionsResponse;

  factory PRFMissionSubscriptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionSubscriptionsResponseFromJson(json);
}
