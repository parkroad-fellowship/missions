import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/mission_session_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_session_state.dart';
part 'get_mission_session_cubit.freezed.dart';

class GetMissionSessionCubit extends Cubit<GetMissionSessionState> {
  GetMissionSessionCubit({
    required MissionSessionService missionSessionService,
    required LocalDBService localDBService,
  }) : super(const GetMissionSessionState.initial()) {
    _missionSessionService = missionSessionService;
    _localDBService = localDBService;
  }

  late MissionSessionService _missionSessionService;
  late LocalDBService _localDBService;

  Future<void> getMissionSession({
    required String missionSessionUlid,
    required String missionUlid,
    bool refresh = false,
  }) async {
    try {
      emit(const GetMissionSessionState.loading());

      if (!refresh) {
        emit(const GetMissionSessionState.loaded());
        await _localDBService.getMissionSession(
          missionSessionUlid: missionSessionUlid,
        );
        return;
      }

      final missionSession = await _missionSessionService.get(
        id: missionSessionUlid,
        includes: [
          'facilitator',
          'speaker',
          'classGroup',
          'missionSessionTranscripts.media',
        ],
      );

      await _localDBService.persistMissionSessions(
        missionSessions: [missionSession],
        missionUlid: missionUlid,
      );
      await _localDBService.getMissionSession(
        missionSessionUlid: missionSessionUlid,
      );

      emit(const GetMissionSessionState.loaded());
    } on Failure catch (e) {
      emit(GetMissionSessionState.error(e.message));
    } catch (e) {
      emit(GetMissionSessionState.error(e.toString()));
    }
  }
}
