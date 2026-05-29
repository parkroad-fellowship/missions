import 'dart:async';

import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';

class MissionSubscriptionHiveDbService
    extends BaseHiveDbService<PRFMissionSubscription> {
  @override
  String get boxName => 'prf_mission_subscriptions';

  @override
  String getKey(PRFMissionSubscription entity) => entity.ulid;

  @override
  PRFMissionSubscription fromJson(Map<String, dynamic> json) =>
      PRFMissionSubscription.fromJson(json);

  @override
  Map<String, dynamic> toJson(PRFMissionSubscription entity) => entity.toJson();

  // ----- Parent (mission) stream -----

  StreamController<List<PRFMissionSubscription>>? _parentStreamController;

  Stream<List<PRFMissionSubscription>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFMissionSubscription>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<List<PRFMissionSubscription>> listByMission(String missionUlid) =>
      filterBy((s) => s.mission?.ulid == missionUlid);

  Future<void> refreshParentStream(String missionUlid) async {
    _parentStreamController ??=
        StreamController<List<PRFMissionSubscription>>.broadcast();
    _parentStreamController!.add(await listByMission(missionUlid));
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }
}
