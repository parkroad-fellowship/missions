import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_session_state.dart';
part 'get_mission_session_cubit.freezed.dart';

class GetMissionSessionCubit extends Cubit<GetMissionSessionState> {
  GetMissionSessionCubit({
    required MissionService missionService,
    required LocalDBService localDBService,
  }) : super(const GetMissionSessionState.initial()) {
    _missionService = missionService;
    _localDBService = localDBService;
  }

  late MissionService _missionService;
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
        return;
      }

      final missionSession = await _missionService.getMissionSession(
        missionSessionUlid: missionSessionUlid,
      );

      await _localDBService.persistMissionSessions(
        missionSessions: [missionSession],
        missionUlid: missionUlid,
      );

      emit(const GetMissionSessionState.loaded());
    } on Failure catch (e) {
      emit(GetMissionSessionState.error(e.message));
    } catch (e) {
      emit(GetMissionSessionState.error(e.toString()));
    }
  }
}
