import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_sessions_cubit.freezed.dart';
part 'get_mission_sessions_state.dart';

class GetMissionSessionsCubit extends Cubit<GetMissionSessionsState> {
  GetMissionSessionsCubit({
    required MissionService missionService,
    required LocalDBService localDBService,
  }) : super(const GetMissionSessionsState.initial()) {
    _missionService = missionService;
    _localDBService = localDBService;
  }

  late MissionService _missionService;
  late LocalDBService _localDBService;

  Future<void> getMissionSessions({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetMissionSessionsState.loading());
    try {
      if (!refresh) {
        emit(const GetMissionSessionsState.loaded());
        return;
      }
      final missionSessions = await _missionService.getMissionSessions(
        missionUlid: missionUlid,
      );
      await _localDBService.persistMissionSessions(
        missionSessions: missionSessions,
        missionUlid: missionUlid,
      );

      emit(const GetMissionSessionsState.loaded());
    } catch (e) {
      emit(GetMissionSessionsState.error(e.toString()));
    }
  }
}
