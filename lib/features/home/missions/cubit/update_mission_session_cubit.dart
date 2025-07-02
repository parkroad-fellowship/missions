import 'package:app/models/remote/prf_mission_session_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/mission_session_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_mission_session_state.dart';
part 'update_mission_session_cubit.freezed.dart';

class UpdateMissionSessionCubit extends Cubit<UpdateMissionSessionState> {
  UpdateMissionSessionCubit({
    required MissionSessionService missionSessionService,
    required LocalDBService localDBService,
  }) : super(const UpdateMissionSessionState.initial()) {
    _missionSessionService = missionSessionService;
    _localDBService = localDBService;
  }

  late MissionSessionService _missionSessionService;
  late LocalDBService _localDBService;

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
      final updatedMissionSession = await _missionSessionService.update(
        id: missionSessionUlid,
        data: PRFMissionSessionDTO(
          missionUlid: missionUlid,
          facilitatorUlid: facilitatorUlid,
          startsAt: startsAt.toIso8601String(),
          endsAt: endsAt.toIso8601String(),
          notes: notes,
          speakerUlid: speakerUlid,
          classGroupUlid: classGroupUlid,
        ).toJson(),
        includes:
            'facilitator,speaker,classGroup,missionSessionTranscripts.media',
      );
      await _localDBService.persistMissionSessions(
        missionSessions: [updatedMissionSession],
        missionUlid: missionUlid,
      );
      await _localDBService.getMissionSession(
        missionSessionUlid: missionSessionUlid,
      );
      emit(const UpdateMissionSessionState.loaded());
    } catch (e) {
      emit(UpdateMissionSessionState.error(e.toString()));
    }
  }
}
