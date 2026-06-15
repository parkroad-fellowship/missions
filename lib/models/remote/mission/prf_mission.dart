import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/models/remote/course/prf_school.dart';
import 'package:app/models/remote/course/prf_school_term.dart';
import 'package:app/models/remote/expense/prf_accounting_event.dart';
import 'package:app/models/remote/media/prf_weather_forecast.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/models/remote/mission/prf_mission_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_mission.freezed.dart';
part 'prf_mission.g.dart';

@freezed
abstract class PRFMission with _$PRFMission {
  factory PRFMission(
    String ulid,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'start_time') String startTime,
    @JsonKey(name: 'end_date') DateTime endDate,
    @JsonKey(name: 'end_time') String endTime,
    int capacity,
    PRFMissionStatus status,
    @JsonKey(name: 'mission_subscriptions_needed')
    int missionSubscriptionsNeeded,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'mission_prep_notes') String? missionPrepNotes,
    @JsonKey(name: 'logged_in_member_mission_subscription')
    PRFMissionSubscription? loggedInMemberMissionSubscription,
    @Default('Open Topic') String? theme,
    @JsonKey(name: 'whats_app_link') String? whatsAppLink,
    PRFSchool? school,
    @JsonKey(name: 'school_term') PRFSchoolTerm? schoolTerm,
    @JsonKey(name: 'mission_type') PRFMissionType? missionType,
    @JsonKey(name: 'accounting_event') PRFAccountingEvent? accountingEvent,
    @JsonKey(name: 'weather_forecasts')
    @Default([])
    List<PRFWeatherForecast> weatherForecasts,
  }) = _PRFMission;

  const PRFMission._();

  factory PRFMission.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionFromJson(json);

  bool get isPastMission => endDate.isBefore(DateTime.now());

  bool get isLoggedInMemberSubscribed =>
      loggedInMemberMissionSubscription != null &&
      loggedInMemberMissionSubscription!.status ==
          PRFMissionSubscriptionStatus.approved;

  bool get canEdit {
    if (!isLoggedInMemberSubscribed) {
      return false;
    }

    // Only missions that are still open for subscription or
    // already fully subscribed can be edited
    if (![
      PRFMissionStatus.approved,
      PRFMissionStatus.fullySubscribed,
    ].contains(status)) {
      return false;
    }
    return true;
  }
}

@freezed
abstract class PRFMissionsResponse with _$PRFMissionsResponse {
  factory PRFMissionsResponse(List<PRFMission> data) = _PRFMissionsResponse;

  factory PRFMissionsResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionsResponseFromJson(json);
}
