import 'package:app/models/local/prf_mission_session.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:isar/isar.dart';

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

  /// Stream all sessions for a mission
  @override
  Stream<List<PRFLocalMissionSession>> getByParentKey(String missionUlid) {
    return collection
        .where()
        .missionUlidEqualTo(missionUlid)
        .sortByStartsAt()
        .watch(fireImmediately: true);
  }
}
