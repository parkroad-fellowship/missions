import 'package:app/models/remote/failure.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_session_state.dart';
part 'get_mission_session_cubit.freezed.dart';

class GetMissionSessionCubit extends Cubit<GetMissionSessionState> {
  GetMissionSessionCubit({
    required MissionSessionService missionSessionService,
    required IsarService isarService,
  }) : super(const GetMissionSessionState.initial()) {
    _missionSessionService = missionSessionService;
    _isarService = isarService;
  }

  late MissionSessionService _missionSessionService;
  late IsarService _isarService;

  Future<void> getMissionSession({
    required String missionSessionUlid,
    bool refresh = false,
  }) async {
    try {
      emit(const GetMissionSessionState.loading());

      final localMissionSession = await _isarService.missionSessions.get(
        missionSessionUlid,
      );
      if (localMissionSession == null || refresh) {
        final missionSession = await _missionSessionService.get(
          ulid: missionSessionUlid,
          includes: [
            'facilitator',
            'speaker',
            'classGroup',
            'missionSessionTranscripts.media',
            'mission',
          ],
        );
        await _isarService.missionSessions.persistEntity(missionSession);
      }

      await _isarService.missionSessions.refreshItemStream(missionSessionUlid);

      emit(const GetMissionSessionState.loaded());
    } on Failure catch (e) {
      emit(GetMissionSessionState.error(e.message));
    } catch (e) {
      emit(GetMissionSessionState.error(e.toString()));
    }
  }
}
