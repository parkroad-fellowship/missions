import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_sessions_cubit.freezed.dart';
part 'get_mission_sessions_state.dart';

class GetMissionSessionsCubit extends Cubit<GetMissionSessionsState> {
  GetMissionSessionsCubit({
    required MissionSessionService missionSessionService,
    required IsarService isarService,
  }) : super(const GetMissionSessionsState.initial()) {
    _missionSessionService = missionSessionService;
    _isarService = isarService;
  }

  late MissionSessionService _missionSessionService;
  late IsarService _isarService;

  Future<void> getMissionSessions({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetMissionSessionsState.loading());
    try {
      // if (!refresh) {
      //   await _isarService.missionSessions.refreshParentStream(missionUlid);
      //   emit(const GetMissionSessionsState.loaded());
      //   return;
      // }
      final missionSessions = await _missionSessionService.list(
        filters: {
          'mission_ulid': missionUlid,
        },
        includes: [
          'facilitator',
          'speaker',
          'classGroup',
          'missionSessionTranscripts.media',
          'mission',
        ],
      );

      await _isarService.missionSessions.persistEntities(
        missionSessions,
      );
      await _isarService.missionSessions.refreshParentStream(missionUlid);

      emit(const GetMissionSessionsState.loaded());
    } catch (e) {
      emit(GetMissionSessionsState.error(e.toString()));
    }
  }
}
