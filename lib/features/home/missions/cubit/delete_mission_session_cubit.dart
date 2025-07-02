import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_mission_session_cubit.freezed.dart';
part 'delete_mission_session_state.dart';

class DeleteMissionSessionCubit extends Cubit<DeleteMissionSessionState> {
  DeleteMissionSessionCubit({
    required MissionSessionService missionSessionService,
    required LocalDBService localDBService,
  }) : super(const DeleteMissionSessionState.initial()) {
    _missionSessionService = missionSessionService;
    _localDBService = localDBService;
  }

  late MissionSessionService _missionSessionService;
  late LocalDBService _localDBService;

  Future<void> deleteMissionSession({
    required String missionSessionUlid,
  }) async {
    emit(const DeleteMissionSessionState.loading());
    try {
      await _missionSessionService.delete(id: missionSessionUlid);
      await _localDBService.deleteMissionSession(
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
