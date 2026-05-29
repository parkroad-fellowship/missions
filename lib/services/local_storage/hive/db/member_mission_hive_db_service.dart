import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';
import 'package:app/services/local_storage/hive/db/mission_subscription_hive_db_service.dart'
    show MissionSubscriptionHiveDbService;

/// Stores the logged-in member's own mission subscriptions.
/// Separate box from [MissionSubscriptionHiveDbService] which stores
/// subscriptions for a given mission (all members).
class MemberMissionHiveDbService
    extends BaseHiveDbService<PRFMissionSubscription> {
  @override
  String get boxName => 'prf_member_missions';

  @override
  String getKey(PRFMissionSubscription entity) => entity.ulid;

  @override
  PRFMissionSubscription fromJson(Map<String, dynamic> json) =>
      PRFMissionSubscription.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFMissionSubscription entity) => entity.toJson();
}
