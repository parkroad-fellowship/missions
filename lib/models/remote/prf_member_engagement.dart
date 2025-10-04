import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_member_engagement.freezed.dart';
part 'prf_member_engagement.g.dart';

@freezed
abstract class PRFMemberEngagement with _$PRFMemberEngagement {
  factory PRFMemberEngagement({
    required String entity,
    @JsonKey(name: 'member_ulid') required String memberUlid,
    @JsonKey(name: 'member_name') required String memberName,
    @JsonKey(name: 'generated_at') required String generatedAt,
    @JsonKey(name: 'mission_stats') required MissionStats missionStats,
    @JsonKey(name: 'impact_stats') required ImpactStats impactStats,
    @JsonKey(name: 'learning_stats') required LearningStats learningStats,
    @JsonKey(name: 'prayer_stats') required PrayerStats prayerStats,
    @JsonKey(name: 'event_stats') required EventStats eventStats,
    List<Badge>? badges,
    @JsonKey(name: 'comparative_stats') ComparativeStats? comparativeStats,
  }) = _PRFMemberEngagement;

  factory PRFMemberEngagement.fromJson(Map<String, dynamic> json) =>
      _$PRFMemberEngagementFromJson(json);
}

@freezed
abstract class MissionStats with _$MissionStats {
  factory MissionStats({
    @JsonKey(name: 'total_missions') required int totalMissions,
    @JsonKey(name: 'approved_missions') required int approvedMissions,
    @JsonKey(name: 'mission_streak') required int missionStreak,
    @JsonKey(name: 'schools_reached') required int schoolsReached,
    @JsonKey(name: 'mission_roles') required List<MissionRole> missionRoles,
    @JsonKey(name: 'completion_rate') required double completionRate,
    @JsonKey(name: 'favorite_mission_type')
    FavoriteMissionType? favoriteMissionType,
  }) = _MissionStats;

  factory MissionStats.fromJson(Map<String, dynamic> json) =>
      _$MissionStatsFromJson(json);
}

@freezed
abstract class FavoriteMissionType with _$FavoriteMissionType {
  factory FavoriteMissionType({
    required String ulid,
    required String name,
  }) = _FavoriteMissionType;

  factory FavoriteMissionType.fromJson(Map<String, dynamic> json) =>
      _$FavoriteMissionTypeFromJson(json);
}

@freezed
abstract class MissionRole with _$MissionRole {
  factory MissionRole({
    required String role,
    required int count,
  }) = _MissionRole;

  factory MissionRole.fromJson(Map<String, dynamic> json) =>
      _$MissionRoleFromJson(json);
}

@freezed
abstract class ImpactStats with _$ImpactStats {
  factory ImpactStats({
    @JsonKey(name: 'souls_touched') required int soulsTouched,
    @JsonKey(name: 'decision_types') required List<DecisionType> decisionTypes,
    @JsonKey(name: 'most_impactful_mission')
    MostImpactfulMission? mostImpactfulMission,
  }) = _ImpactStats;

  factory ImpactStats.fromJson(Map<String, dynamic> json) =>
      _$ImpactStatsFromJson(json);
}

@freezed
abstract class DecisionType with _$DecisionType {
  factory DecisionType({
    required String type,
    required int count,
  }) = _DecisionType;

  factory DecisionType.fromJson(Map<String, dynamic> json) =>
      _$DecisionTypeFromJson(json);
}

@freezed
abstract class MostImpactfulMission with _$MostImpactfulMission {
  factory MostImpactfulMission({
    required String ulid,
    required String name,
    @JsonKey(name: 'souls_count') required int soulsCount,
  }) = _MostImpactfulMission;

  factory MostImpactfulMission.fromJson(Map<String, dynamic> json) =>
      _$MostImpactfulMissionFromJson(json);
}

@freezed
abstract class LearningStats with _$LearningStats {
  factory LearningStats({
    @JsonKey(name: 'courses_completed') required int coursesCompleted,
    @JsonKey(name: 'total_courses_enrolled') required int totalCoursesEnrolled,
    @JsonKey(name: 'lessons_completed') required int lessonsCompleted,
    @JsonKey(name: 'learning_progress_percentage')
    required double learningProgressPercentage,
    @JsonKey(name: 'learning_streak') required int learningStreak,
    @JsonKey(name: 'favorite_course') FavoriteCourse? favoriteCourse,
  }) = _LearningStats;

  factory LearningStats.fromJson(Map<String, dynamic> json) =>
      _$LearningStatsFromJson(json);
}

@freezed
abstract class FavoriteCourse with _$FavoriteCourse {
  factory FavoriteCourse({
    required String ulid,
    required String name,
    @JsonKey(name: 'progress_percentage') required double progressPercentage,
  }) = _FavoriteCourse;

  factory FavoriteCourse.fromJson(Map<String, dynamic> json) =>
      _$FavoriteCourseFromJson(json);
}

@freezed
abstract class PrayerStats with _$PrayerStats {
  factory PrayerStats({
    @JsonKey(name: 'prayer_responses') required int prayerResponses,
    @JsonKey(name: 'prayer_consistency_days')
    required int prayerConsistencyDays,
  }) = _PrayerStats;

  factory PrayerStats.fromJson(Map<String, dynamic> json) =>
      _$PrayerStatsFromJson(json);
}

@freezed
abstract class EventStats with _$EventStats {
  factory EventStats({
    @JsonKey(name: 'events_attended') required int eventsAttended,
    @JsonKey(name: 'upcoming_events') required int upcomingEvents,
  }) = _EventStats;

  factory EventStats.fromJson(Map<String, dynamic> json) =>
      _$EventStatsFromJson(json);
}

@freezed
abstract class Badge with _$Badge {
  factory Badge({
    required String name,
    required String description,
    required String icon,
    @JsonKey(name: 'earned_at') required String earnedAt,
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}

@freezed
abstract class ComparativeStats with _$ComparativeStats {
  factory ComparativeStats({
    @JsonKey(name: 'avg_missions_per_member')
    required double avgMissionsPerMember,
    @JsonKey(name: 'avg_courses_per_member')
    required double avgCoursesPerMember,
    @JsonKey(name: 'above_average') required List<String> aboveAverage,
  }) = _ComparativeStats;

  factory ComparativeStats.fromJson(Map<String, dynamic> json) =>
      _$ComparativeStatsFromJson(json);
}

@freezed
abstract class PRFMemberEngagementResponse with _$PRFMemberEngagementResponse {
  factory PRFMemberEngagementResponse({
    required PRFMemberEngagement data,
  }) = _PRFMemberEngagementResponse;

  factory PRFMemberEngagementResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFMemberEngagementResponseFromJson(json);
}
