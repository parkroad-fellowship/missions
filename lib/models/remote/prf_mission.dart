import 'package:app/enums/prf_mission_status.dart';
import 'package:app/models/remote/prf_mission_expense.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/models/remote/prf_mission_type.dart';
import 'package:app/models/remote/prf_school.dart';
import 'package:app/models/remote/prf_school_term.dart';
import 'package:app/models/remote/prf_weather_forecast.dart';
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
    PRFMissionStatus status,
    @JsonKey(name: 'mission_subscriptions_needed')
    int missionSubscriptionsNeeded,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'mission_prep_notes') String? missionPrepNotes,
    @JsonKey(name: 'logged_in_member_mission_subscription')
    PRFMissionSubscription? loggedInMemberMissionSubscription,
    @Default('Open Topic') String? theme,
    PRFSchool? school,
    @JsonKey(name: 'school_term') PRFSchoolTerm? schoolTerm,
    @JsonKey(name: 'mission_type') PRFMissionType? missionType,
    @JsonKey(name: 'mission_expense') PRFMissionExpense? missionExpense,
    @JsonKey(name: 'weather_forecasts')
    @Default([])
    List<PRFWeatherForecast> weatherForecasts,
  }) = _PRFMission;

  factory PRFMission.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionFromJson(json);
}

@freezed
class PRFMissionsResponse with _$PRFMissionsResponse {
  factory PRFMissionsResponse(List<PRFMission> data) = _PRFMissionsResponse;

  factory PRFMissionsResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFMissionsResponseFromJson(json);
}
