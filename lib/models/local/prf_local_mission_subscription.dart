import 'package:app/enums/prf_mission_role.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:isar_community/isar.dart';

part 'prf_local_mission_subscription.g.dart';

@collection
class PRFLocalMissionSubscription {
  PRFLocalMissionSubscription({
    required this.ulid,
    required this.missionRole,
    required this.status,
    required this.member,
    required this.missionUlid,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String ulid;

  @Enumerated(EnumType.ordinal32)
  final PRFMissionRole missionRole;

  @Enumerated(EnumType.ordinal32)
  final PRFMissionSubscriptionStatus status;

  final PRFLocalMember member;

  @Index()
  final String missionUlid;
}
