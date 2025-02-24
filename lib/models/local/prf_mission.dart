import 'package:app/enums/prf_mission_role.dart';
import 'package:app/enums/prf_mission_status.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:isar/isar.dart';

part 'prf_mission.g.dart';

@collection
class PRFLocalMission {
  PRFLocalMission({
    required this.ulid,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.capacity,
    required this.status,
    required this.missionSubscriptionsNeeded,
    required this.createdAt,
    required this.updatedAt,
    this.missionPrepNotes,
    this.theme,
    this.loggedInMemberMissionSubscription,
    this.school,
    this.missionType,
    this.weatherForecasts,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String ulid;
  final DateTime startDate;
  final String startTime;
  final DateTime endDate;
  final String endTime;
  final int capacity;

  @Enumerated(EnumType.ordinal32)
  final PRFMissionStatus status;

  final int missionSubscriptionsNeeded;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? missionPrepNotes;
  final String? theme;
  final PRFLocalMissionSubscription? loggedInMemberMissionSubscription;
  final PRFLocalSchool? school;
  final PRFLocalMissionType? missionType;
  final List<PRFLocalWeatherForecast>? weatherForecasts;
}

@embedded
class PRFLocalMissionSubscription {
  PRFLocalMissionSubscription({
    this.ulid,
    this.status,
    this.missionRole,
    this.createdAt,
    this.updatedAt,
  });

  final String? ulid;

  @Enumerated(EnumType.ordinal32)
  final PRFMissionSubscriptionStatus? status;
  @Enumerated(EnumType.ordinal32)
  final PRFMissionRole? missionRole;

  final DateTime? createdAt;
  final DateTime? updatedAt;
}

@embedded
class PRFLocalSchool {
  PRFLocalSchool({
    this.ulid,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.description,
    this.directions,
    this.distance,
    this.staticDuration,
    this.totalStudents,
    this.address,
    this.latitude,
    this.longitude,
    this.contacts,
  });

  final String? ulid;
  final String? name;
  final String? description;
  final String? directions;
  final String? distance;
  final String? staticDuration;

  final int? totalStudents;
  final String? address;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PRFLocalContact>? contacts;
}

@embedded
class PRFLocalContact {
  PRFLocalContact({
    this.ulid,
    this.name,
    this.phone,
    this.contactType,
  });

  final String? ulid;
  final String? name;
  final String? phone;
  final PRFLocalContactType? contactType;
}

@embedded
class PRFLocalContactType {
  PRFLocalContactType({this.ulid, this.name});

  final String? ulid;
  final String? name;
}

@embedded
class PRFLocalSchoolTerm {
  PRFLocalSchoolTerm({
    this.ulid,
    this.name,
    this.year,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final String? ulid;
  final String? name;
  final int? year;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

@embedded
class PRFLocalMissionType {
  PRFLocalMissionType({
    this.ulid,
    this.name,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final String? ulid;
  final String? name;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

@embedded
class PRFLocalWeatherForecast {
  PRFLocalWeatherForecast({
    this.ulid,
    this.forecastDate,
    this.weatherCodeDescription,
    this.temperature,
    this.visibility,
    this.precipitationProbability,
    this.humidity,
    this.dressingRecommendations,
    this.activityRecommendations,
  });

  String? ulid;
  String? forecastDate;
  String? weatherCodeDescription;
  PRFLocalTemperature? temperature;
  PRFLocalVisibility? visibility;
  PRFLocalPrecipitationProbability? precipitationProbability;
  PRFLocalHumidity? humidity;
  String? dressingRecommendations;
  String? activityRecommendations;
}

@embedded
class PRFLocalTemperature {
  PRFLocalTemperature({
    this.apparentAvg,
    this.apparentMax,
    this.apparentMin,
    this.avg,
    this.max,
    this.min,
  });
  String? apparentAvg;
  String? apparentMax;
  String? apparentMin;
  String? avg;
  String? max;
  String? min;
}

@embedded
class PRFLocalVisibility {
  PRFLocalVisibility({this.avg, this.max, this.min});
  String? avg;
  String? max;
  String? min;
}

@embedded
class PRFLocalPrecipitationProbability {
  PRFLocalPrecipitationProbability({this.avg, this.max, this.min});
  String? avg;
  String? max;
  String? min;
}

@embedded
class PRFLocalHumidity {
  PRFLocalHumidity({this.avg, this.max, this.min});
  String? avg;
  String? max;
  String? min;
}
