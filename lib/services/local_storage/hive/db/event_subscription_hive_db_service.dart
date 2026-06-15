import 'package:app/models/remote/event/prf_event_subscription.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class EventSubscriptionHiveDbService
    extends BaseHiveDbService<PRFEventSubscription> {
  @override
  String get boxName => 'prf_event_subscriptions';

  @override
  String getKey(PRFEventSubscription entity) => entity.ulid;

  @override
  PRFEventSubscription fromJson(Map<String, dynamic> json) =>
      PRFEventSubscription.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFEventSubscription entity) => entity.toJson();
}
