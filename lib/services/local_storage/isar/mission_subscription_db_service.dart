import 'dart:async';

import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/models/local/mission/prf_local_mission_subscription.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar_community/isar.dart';

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
  PRFMissionSubscription localToRemote(PRFLocalMissionSubscription local) {
    final fullName = local.member.fullName ?? '';
    final names = fullName.trim().split(RegExp(r'\s+'));
    final firstName = names.isNotEmpty ? names.first : '';
    final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

    return PRFMissionSubscription(
      local.ulid,
      local.status,
      local.missionRole,
      DateTime.fromMillisecondsSinceEpoch(0),
      DateTime.fromMillisecondsSinceEpoch(0),
      member: PRFMember(
        local.member.ulid ?? '',
        firstName,
        lastName,
        fullName,
        '',
        churchVolunteer: false,
        acceptTerms: false,
        approved: false,
        phoneNumber: local.member.phoneNumber,
        bio: local.member.bio,
      ),
      mission: PRFMission(
        local.missionUlid,
        DateTime.fromMillisecondsSinceEpoch(0),
        '',
        DateTime.fromMillisecondsSinceEpoch(0),
        '',
        0,
        PRFMissionStatus.pending,
        0,
        DateTime.fromMillisecondsSinceEpoch(0),
        DateTime.fromMillisecondsSinceEpoch(0),
      ),
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
