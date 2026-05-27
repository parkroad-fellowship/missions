import 'package:app/enums/member/prf_institution_type.dart';
import 'package:app/enums/member/prf_responsible_desk.dart';
import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/models/local/mission/prf_mission_session.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/expense/prf_accounting_event.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/models/remote/mission/prf_mission_session_dto.dart';
import 'package:app/models/remote/mission/prf_transcript.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/local_storage/isar/mission_session_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionSessionResourceCubit
    extends ResourceCubit<PRFMissionSession, PRFLocalMissionSession> {
  MissionSessionResourceCubit({
    required MissionSessionService missionSessionService,
    super.dbService,
  }) : super(service: missionSessionService);

  @override
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    final parentKey = filters?['mission_ulid'] as String?;
    if (parentKey != null && dbService is MissionSessionDbService) {
      await (dbService! as MissionSessionDbService).refreshParentStream(
        parentKey,
      );
    }
    await dbService?.refreshStream();
  }

  @override
  Future<PRFMissionSession?> loadCachedItem(String id) async {
    if (dbService is! MissionSessionDbService) {
      return null;
    }

    final localSession = await (dbService! as MissionSessionDbService).get(id);
    if (localSession == null) {
      return null;
    }

    return _toRemoteSession(localSession);
  }

  @override
  List<String> get defaultIncludes => [
    'facilitator',
    'speaker',
    'classGroup',
    'transcripts.media',
    'mission',
  ];

  /// Create a mission session.
  Future<void> addSession({required PRFMissionSessionDTO data}) async {
    await create(data: data.toJson());
  }

  /// Update a mission session.
  Future<void> updateSession({
    required String ulid,
    required PRFMissionSessionDTO data,
  }) async {
    await update(
      id: ulid,
      data: data.toJson(),
      matchById: (s) => s.ulid == ulid,
    );
  }

  /// Delete a mission session.
  Future<void> deleteSession(String ulid) async {
    await delete(ulid: ulid, matchById: (s) => s.ulid == ulid);
  }

  PRFMissionSession _toRemoteSession(PRFLocalMissionSession local) {
    return PRFMissionSession(
      'mission_sessions',
      local.ulid,
      local.startsAt,
      local.endsAt,
      local.notes,
      order: local.order,
      facilitator: _toRemoteMember(local.facilitator),
      speaker: _toRemoteMember(local.speaker),
      classGroup: _toRemoteClassGroup(local.classGroup),
      mission: _placeholderMission(local),
      transcripts: local.transcripts
          .map(
            (transcript) => PRFTranscript(
              transcript.ulid ?? 'cached-transcript',
              content: transcript.content ?? '',
              media: _toRemoteMedia(transcript.media),
            ),
          )
          .toList(),
    );
  }

  PRFMember? _toRemoteMember(PRFLocalMember? local) {
    if (local == null || local.ulid == null) {
      return null;
    }

    final fullName = (local.fullName ?? 'Cached Member').trim();
    final parts = fullName.split(' ');
    final firstName = parts.isEmpty ? 'Cached' : parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : 'Member';

    return PRFMember(
      local.ulid!,
      firstName,
      lastName,
      fullName,
      '${local.ulid}@cached.local',
      churchVolunteer: false,
      acceptTerms: true,
      approved: true,
      phoneNumber: local.phoneNumber,
      bio: local.bio,
      profilePicture: _toRemoteMedia(
        PRFLocalMedia(
          temporaryURL: local.profilePictureUrl,
          size: 0,
          humanReadableSize: '0 B',
          mimeType: 'image/jpeg',
          name: 'profile',
          fileName: 'profile.jpg',
          collectionName: 'profile_picture',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  PRFClassGroup? _toRemoteClassGroup(PRFLocalClassGroup? local) {
    if (local == null || local.ulid == null) {
      return null;
    }

    final now = DateTime.now();
    return PRFClassGroup(
      local.ulid!,
      local.name ?? 'Cached Group',
      PRFInstitutionType.highSchool,
      1,
      now,
      now,
    );
  }

  PRFMedia? _toRemoteMedia(PRFLocalMedia? local) {
    if (local == null || local.temporaryURL == null) {
      return null;
    }

    return PRFMedia(
      local.fileName ?? 'cached-media',
      local.temporaryURL ?? '',
      local.size ?? 0,
      local.humanReadableSize ?? '0 B',
      local.mimeType ?? 'application/octet-stream',
      local.name ?? 'Cached Media',
      local.fileName ?? 'cached-media',
      local.collectionName ?? 'mission_session_transcripts',
      local.createdAt ?? DateTime.now(),
      local.updatedAt ?? DateTime.now(),
    );
  }

  PRFMission _placeholderMission(PRFLocalMissionSession local) {
    final now = DateTime.now();

    return PRFMission(
      local.missionUlid,
      local.startsAt,
      '',
      local.endsAt,
      '',
      0,
      PRFMissionStatus.pending,
      0,
      now,
      now,
      accountingEvent: PRFAccountingEvent(
        'cached-accounting-${local.missionUlid}',
        'Cached Accounting Event',
        local.endsAt,
        PRFResponsibleDesk.missions,
        0,
        0,
        0,
        0,
        0,
        now,
        now,
      ),
    );
  }
}
