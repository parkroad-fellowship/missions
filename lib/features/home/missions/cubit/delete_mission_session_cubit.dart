import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_mission_session_cubit.freezed.dart';
part 'delete_mission_session_state.dart';

class DeleteMissionSessionCubit extends Cubit<DeleteMissionSessionState> {
  DeleteMissionSessionCubit({required MissionService missionService})
    : super(const DeleteMissionSessionState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

  Future<void> deleteMissionSession({
    required String missionSessionUlid,
  }) async {
    emit(const DeleteMissionSessionState.loading());
    try {
      await _missionService.deleteSession(
        missionSessionUlid: missionSessionUlid,
      );
      emit(const DeleteMissionSessionState.loaded());
    } on Failure catch (e) {
      emit(DeleteMissionSessionState.error(e.message));
    } catch (e) {
      emit(DeleteMissionSessionState.error(e.toString()));
    }
  }
}
