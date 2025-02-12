import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_session_state.dart';
part 'get_mission_session_cubit.freezed.dart';

class GetMissionSessionCubit extends Cubit<GetMissionSessionState> {
  GetMissionSessionCubit({
    required MissionService missionService,
  }) : super(const GetMissionSessionState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

  Future<void> getMissionSession({
    required String missionSessionUlid,
  }) async {
    try {
      emit(const GetMissionSessionState.loading());

      final missionSession = await _missionService.getMissionSession(
        missionSessionUlid: missionSessionUlid,
      );

      emit(GetMissionSessionState.loaded(missionSession: missionSession));
    } on Failure catch (e) {
      emit(GetMissionSessionState.error(e.message));
    } catch (e) {
      emit(GetMissionSessionState.error(e.toString()));
    }
  }
}
