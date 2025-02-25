import 'package:app/enums/prf_mission_role.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:isar/isar.dart';

part 'prf_local_member_mission_subscription.g.dart';

@collection
class PRFLocalMemberMissionSubscription {
  PRFLocalMemberMissionSubscription({
    required this.ulid,
    required this.missionRole,
    required this.status,
    required this.missionUlid,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String ulid;
  @Enumerated(EnumType.ordinal32)
  final PRFMissionRole missionRole;
  @Enumerated(EnumType.ordinal32)
  final PRFMissionSubscriptionStatus status;
  final String missionUlid;
}
