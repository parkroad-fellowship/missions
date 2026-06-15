import 'package:app/models/remote/event/prf_event_subscription.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/models/remote/media/prf_weather_forecast.dart';
import 'package:app/models/remote/mission/prf_transcript.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_event.freezed.dart';
part 'prf_event.g.dart';

@freezed
abstract class PRFEvent with _$PRFEvent {
  factory PRFEvent(
    String ulid,
    String name,
    String description,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'start_time') String startTime,
    @JsonKey(name: 'end_date') DateTime endDate,
    @JsonKey(name: 'end_time') String endTime,
    int capacity, {
    String? venue,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'dressing_recommendations') String? dressingRecommendations,
    @JsonKey(name: 'event_subscriptions_needed') int? subscriptionsNeeded,
    @JsonKey(name: 'logged_in_member_event_subscription')
    PRFEventSubscription? loggedInMemberEventSubscription,
    @JsonKey(name: 'weather_forecasts')
    @Default([])
    List<PRFWeatherForecast> weatherForecasts,
    @JsonKey(name: 'event_subscriptions')
    @Default([])
    List<PRFEventSubscription> eventSubscriptions,
    @Default([]) List<PRFMedia> posters,
    @Default([]) List<PRFTranscript> transcripts,
  }) = _PRFEvent;

  factory PRFEvent.fromJson(Map<String, dynamic> json) =>
      _$PRFEventFromJson(json);
}

@freezed
abstract class PRFEventResponse with _$PRFEventResponse {
  factory PRFEventResponse({@Default([]) List<PRFEvent> data}) =
      _PRFEventResponse;
  factory PRFEventResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFEventResponseFromJson(json);
}
