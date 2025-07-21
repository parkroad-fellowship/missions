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
    required String missionUlid,
    bool refresh = false,
  }) async {
    try {
      emit(const GetMissionSessionState.loading());

      if (!refresh) {
        emit(const GetMissionSessionState.loaded());
        // await _isarService.getMissionSession(
        //   missionSessionUlid: missionSessionUlid,
        // );
        return;
      }

      final missionSession = await _missionSessionService.get(
        id: missionSessionUlid,
        includes: [
          'facilitator',
          'speaker',
          'classGroup',
          'missionSessionTranscripts.media',
          'mission',
        ],
      );

      await _isarService.missionSessions.persistEntity(missionSession);

      // await _localDBService.getMissionSession(
      //   missionSessionUlid: missionSessionUlid,
      // );

      emit(const GetMissionSessionState.loaded());
    } on Failure catch (e) {
      emit(GetMissionSessionState.error(e.message));
    } catch (e) {
      emit(GetMissionSessionState.error(e.toString()));
    }
  }
}
