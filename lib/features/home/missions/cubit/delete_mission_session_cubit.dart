import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app/models/remote/failure.dart';


part 'delete_mission_session_state.dart';
part 'delete_mission_session_cubit.freezed.dart';

class DeleteMissionSessionCubit extends Cubit<DeleteMissionSessionState> {
  DeleteMissionSessionCubit({
    required MissionService missionService,
  }) : super(DeleteMissionSessionState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

  Future<void> deleteMissionSession({
    required String missionSessionUlid,
  }) async {
    emit(DeleteMissionSessionState.loading());
    try {
      await _missionService.deleteSession(missionSessionUlid: missionSessionUlid);
      emit(DeleteMissionSessionState.loaded());
    } on Failure catch (e) {
      emit(DeleteMissionSessionState.error(e.message));
    }
    catch (e) {
      emit(DeleteMissionSessionState.error(e.toString()));
    }
  }
}
