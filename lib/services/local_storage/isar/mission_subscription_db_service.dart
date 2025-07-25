import 'dart:async';

import 'package:app/models/local/prf_local_mission_subscription.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

class MissionSubscriptionDbService
    extends
        BaseLocalDBService<
          PRFMissionSubscription,
          PRFLocalMissionSubscription
        > {
  MissionSubscriptionDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalMissionSubscription> get collection =>
      dbInstance.pRFLocalMissionSubscriptions;

  @override
  PRFLocalMissionSubscription remoteToLocal(PRFMissionSubscription remote) {
    return PRFLocalMissionSubscription(
      ulid: remote.ulid,
      missionRole: remote.missionRole,
      status: remote.status,
      member: PRFLocalMember(
        ulid: remote.member!.ulid,
        fullName: remote.member!.fullName,
        phoneNumber: remote.member!.phoneNumber,
        profilePictureUrl: remote.member!.profilePicture?.temporaryURL,
        bio: remote.member!.bio,
      ),
      missionUlid: remote.mission!.ulid,
    );
  }

  Future<List<PRFLocalMissionSubscription>> listParentMissionSubscriptions(
    String parentKey,
  ) async {
    return collection.where().missionUlidEqualTo(parentKey).findAll();
  }

  StreamController<List<PRFLocalMissionSubscription>>? _parentStreamController;
  Stream<List<PRFLocalMissionSubscription>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFLocalMissionSubscription>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<void> refreshParentStream(String parentKey) async {
    _parentStreamController ??=
        StreamController<List<PRFLocalMissionSubscription>>.broadcast();
    final entities = await listParentMissionSubscriptions(parentKey);
    _parentStreamController!.add(entities);
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }
}
