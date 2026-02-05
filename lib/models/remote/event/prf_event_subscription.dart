import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_event_subscription.freezed.dart';
part 'prf_event_subscription.g.dart';

@freezed
abstract class PRFEventSubscription with _$PRFEventSubscription {
  factory PRFEventSubscription(
    String ulid,
    @JsonKey(name: 'number_of_attendees') int numberOfAttendees,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'prf_event') PRFEvent? event,
    PRFMember? member,
  }) = _PRFEventSubscription;

  factory PRFEventSubscription.fromJson(Map<String, dynamic> json) =>
      _$PRFEventSubscriptionFromJson(json);
}

@freezed
abstract class PRFEventSubscriptionResponse
    with _$PRFEventSubscriptionResponse {
  factory PRFEventSubscriptionResponse({
    @Default([]) List<PRFEventSubscription> data,
  }) = _PRFEventSubscriptionResponse;
  factory PRFEventSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFEventSubscriptionResponseFromJson(json);
}
