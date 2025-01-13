import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/models/remote/prf_mission_session_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_mission_session_state.dart';
part 'update_mission_session_cubit.freezed.dart';

class UpdateMissionSessionCubit extends Cubit<UpdateMissionSessionState> {
  UpdateMissionSessionCubit({
    required MissionService missionService,
  }) : super(const UpdateMissionSessionState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

  Future<void> updateMissionSession({
    required String missionSessionUlid,
    required String missionUlid,
    required String facilitatorUlid,
    required DateTime startsAt,
    required DateTime endsAt,
    required String notes,
    String? speakerUlid,
    String? classGroupUlid,
  }) async {
    emit(const UpdateMissionSessionState.loading());
    try {
      final updatedMissionSession = await _missionService.updateSession(
        missionSessionUlid: missionSessionUlid,
        sessionDTO: PRFMissionSessionDTO(
          missionUlid: missionUlid,
          facilitatorUlid: facilitatorUlid,
          startsAt: startsAt.toIso8601String(),
          endsAt: endsAt.toIso8601String(),
          notes: notes,
          speakerUlid: speakerUlid,
          classGroupUlid: classGroupUlid,
        ),
      );
      emit(UpdateMissionSessionState.loaded(
        missionSession: updatedMissionSession,
      ));
    } catch (e) {
      emit(UpdateMissionSessionState.error(e.toString()));
    }
  }
}
