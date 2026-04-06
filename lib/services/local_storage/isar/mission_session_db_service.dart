import 'dart:async';

import 'package:app/enums/member/prf_institution_type.dart';
import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/models/local/mission/prf_mission_session.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/models/remote/mission/prf_mission_session_transcript.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:collection/collection.dart' as col;
import 'package:isar_community/isar.dart';

class MissionSessionDbService
    extends BaseLocalDBService<PRFMissionSession, PRFLocalMissionSession> {
  MissionSessionDbService({required super.prfDBInstance});

  @override
  IsarCollection<PRFLocalMissionSession> get collection =>
      dbInstance.pRFLocalMissionSessions;

  @override
  PRFLocalMissionSession remoteToLocal(PRFMissionSession remote) {
    return PRFLocalMissionSession(
      missionUlid: remote.mission!.ulid,
      ulid: remote.ulid,
      startsAt: remote.startsAt,
      endsAt: remote.endsAt,
      notes: remote.notes,
      order: remote.order,
      facilitator: PRFLocalMember(
        ulid: remote.facilitator?.ulid,
        fullName: remote.facilitator?.fullName,
        phoneNumber: remote.facilitator?.phoneNumber,
      ),
      speaker: PRFLocalMember(
        ulid: remote.speaker?.ulid,
        fullName: remote.speaker?.fullName,
        phoneNumber: remote.speaker?.phoneNumber,
      ),

      classGroup: PRFLocalClassGroup(
        ulid: remote.classGroup?.ulid,
        name: remote.classGroup?.name,
      ),
      transcripts: remote.transcripts
          .map(
            (transcript) => PRFLocalMissionSessionTranscript(
              ulid: transcript.ulid,
              content: transcript.content,
              media: PRFLocalMedia(
                collectionName: transcript.media?.collectionName,
                fileName: transcript.media?.fileName,
                temporaryURL: transcript.media?.temporaryURL,
                size: transcript.media?.size,
                humanReadableSize: transcript.media?.humanReadableSize,
                mimeType: transcript.media?.mimeType,
                name: transcript.media?.name,
                createdAt: transcript.media?.createdAt,
                updatedAt: transcript.media?.updatedAt,
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  PRFMissionSession localToRemote(PRFLocalMissionSession local) {
    return PRFMissionSession(
      'mission_session',
      local.ulid,
      local.startsAt,
      local.endsAt,
      local.notes,
      order: local.order,
      facilitator: _localMemberToRemote(local.facilitator),
      speaker: local.speaker == null
          ? null
          : _localMemberToRemote(local.speaker!),
      classGroup: local.classGroup == null
          ? null
          : PRFClassGroup(
              local.classGroup!.ulid ?? '',
              local.classGroup!.name ?? '',
              PRFInstitutionType.highSchool,
              1,
              local.startsAt,
              local.endsAt,
            ),
      mission: PRFMission(
        local.missionUlid,
        local.startsAt,
        '',
        local.endsAt,
        '',
        0,
        _inferMissionStatusFromDate(local.startsAt),
        0,
        local.startsAt,
        local.endsAt,
      ),
      transcripts: local.transcripts
          .map(
            (transcript) => PRFMissionSessionTranscript(
              transcript.ulid ?? '',
              content: transcript.content ?? '',
            ),
          )
          .toList(),
    );
  }

  PRFMember _localMemberToRemote(PRFLocalMember localMember) {
    final fullName = localMember.fullName ?? '';
    final names = fullName.trim().split(RegExp(r'\s+'));
    final firstName = names.isNotEmpty ? names.first : '';
    final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

    return PRFMember(
      localMember.ulid ?? '',
      firstName,
      lastName,
      fullName,
      '',
      churchVolunteer: false,
      acceptTerms: false,
      approved: false,
      phoneNumber: localMember.phoneNumber,
      bio: localMember.bio,
    );
  }

  // Session cache does not hold full mission status; infer a safe value.
  PRFMissionStatus _inferMissionStatusFromDate(DateTime startsAt) {
    return startsAt.isAfter(DateTime.now())
        ? PRFMissionStatus.pending
        : PRFMissionStatus.serviced;
  }

  Future<List<PRFLocalMissionSession>> listParentMissionSessions(
    String parentKey,
  ) async {
    return collection
        .where()
        .missionUlidEqualTo(parentKey)
        .sortByStartsAt()
        .findAll();
  }

  StreamController<List<PRFLocalMissionSession>>? _parentStreamController;
  Stream<List<PRFLocalMissionSession>> get parentStream {
    _parentStreamController ??=
        StreamController<List<PRFLocalMissionSession>>.broadcast();
    return _parentStreamController!.stream;
  }

  Future<void> refreshParentStream(String parentKey) async {
    _parentStreamController ??=
        StreamController<List<PRFLocalMissionSession>>.broadcast();
    final entities = await listParentMissionSessions(parentKey);
    _parentStreamController!.add(entities);
  }

  Future<void> closeParentStream() async {
    await _parentStreamController?.close();
    _parentStreamController = null;
  }

  @override
  Future<PRFLocalMissionSession?> get(
    String key,
  ) async {
    return collection.where().ulidEqualTo(key).findFirst();
  }

  Stream<Map<K, List<PRFLocalMissionSession>>> getByParentKeyGrouped<K>(
    String missionUlid,
    K Function(PRFLocalMissionSession session) groupByField,
  ) {
    return parentStream.map(
      (sessions) => col.groupBy(sessions, groupByField),
    );
  }

  @override
  Future<void> deleteByKey(String key) async {
    await dbInstance.writeTxn(() async {
      await collection.where().ulidEqualTo(key).deleteFirst();
    });
    await refreshStream();
  }
}
