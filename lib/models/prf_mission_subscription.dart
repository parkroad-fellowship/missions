import 'package:app/models/prf_member.dart';
import 'package:app/models/prf_mission.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission_subscription.freezed.dart';
part 'prf_mission_subscription.g.dart';

@freezed
class PRFMissionSubscription with _$PRFMissionSubscription {
  factory PRFMissionSubscription(
    String ulid,
    int status,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt, {
    PRFMission? mission,
    PRFMember? member,
  }) = _PRFMissionSubscription;

  factory PRFMissionSubscription.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionSubscriptionFromJson(json);
}

@freezed
class PRFMissionSubscriptionsResponse with _$PRFMissionSubscriptionsResponse {
  factory PRFMissionSubscriptionsResponse(
    List<PRFMissionSubscription> data,
  ) = _PRFMissionSubscriptionsResponse;

  factory PRFMissionSubscriptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionSubscriptionsResponseFromJson(json);
}
