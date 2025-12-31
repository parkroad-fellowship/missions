import 'package:app/enums/prf_mission_status.dart';
import 'package:app/models/local/prf_member_mission.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:isar_community/isar.dart';

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
    required this.accountingEventUlid,
    required this.createdAt,
    required this.updatedAt,
    this.missionPrepNotes,
    this.theme,
    this.school,
    this.missionType,
    this.weatherForecasts,
    this.whatsAppLink,
    this.loggedInMemberMissionSubscription,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.hash)
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
  final PRFLocalSchool? school;
  final PRFLocalMissionType? missionType;
  final List<PRFLocalWeatherForecast>? weatherForecasts;
  final String? whatsAppLink;
  final PRFLocalMissionMemberSubscription? loggedInMemberMissionSubscription;
}
