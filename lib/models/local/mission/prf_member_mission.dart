import 'package:app/enums/mission/prf_mission_role.dart';
import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:isar_community/isar.dart';

part 'prf_member_mission.g.dart';

@collection
class PRFLocalMemberMission {
  PRFLocalMemberMission({
    required this.ulid,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.capacity,
    required this.status,
    required this.missionSubscriptionsNeeded,
    required this.accountingEventUlid,
    required this.createdAt,
    required this.updatedAt,
    required this.accountingEvent,
    this.missionPrepNotes,
    this.theme,
    this.whatsAppLink,
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
  final String accountingEventUlid;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? missionPrepNotes;
  final String? theme;
  final String? whatsAppLink;
  PRFLocalMissionMemberSubscription? loggedInMemberMissionSubscription;
  final PRFLocalSchool? school;
  final PRFLocalMissionType? missionType;
  final List<PRFLocalWeatherForecast>? weatherForecasts;
  final PRFLocalAccountingEvent accountingEvent;
}

@embedded
class PRFLocalMissionMemberSubscription {
  PRFLocalMissionMemberSubscription({
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
