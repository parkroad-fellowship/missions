import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_event_subscription_dto.freezed.dart';
part 'prf_event_subscription_dto.g.dart';

@freezed
class PRFEventSubscriptionDTO with _$PRFEventSubscriptionDTO {
  factory PRFEventSubscriptionDTO({
    @JsonKey(name: 'event_ulid') required String eventUlid,
    @JsonKey(name: 'member_ulid') required String memberUlid,
    @JsonKey(name: 'number_of_attendees') required int numberOfAttendees,
  }) = _PRFEventSubscriptionDTO;

  factory PRFEventSubscriptionDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFEventSubscriptionDTOFromJson(json);
}
