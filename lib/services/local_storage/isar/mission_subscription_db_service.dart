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

  @override
  Stream<List<PRFLocalMissionSubscription>> getByParentKey(String parentKey) {
    return collection
        .where()
        .missionUlidEqualTo(parentKey)
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }
}
