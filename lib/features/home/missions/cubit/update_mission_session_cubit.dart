import 'package:app/models/remote/prf_mission_session_dto.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_mission_session_state.dart';
part 'update_mission_session_cubit.freezed.dart';

class UpdateMissionSessionCubit extends Cubit<UpdateMissionSessionState> {
  UpdateMissionSessionCubit({
    required MissionSessionService missionSessionService,
    required IsarService isarService,
  }) : super(const UpdateMissionSessionState.initial()) {
    _missionSessionService = missionSessionService;
    _isarService = isarService;
  }

  late MissionSessionService _missionSessionService;
  late IsarService _isarService;

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
          startsAt: startsAt.toUtc().toIso8601String(),
          endsAt: endsAt.toUtc().toIso8601String(),
          notes: notes,
          speakerUlid: speakerUlid,
          classGroupUlid: classGroupUlid,
        ).toJson(),
        includes: [
          'facilitator',
          'speaker',
          'classGroup',
          'missionSessionTranscripts.media',
          'mission',
        ],
      );

      await _isarService.missionSessions.persistEntity(updatedMissionSession);

      emit(const UpdateMissionSessionState.loaded());
    } catch (e) {
      emit(UpdateMissionSessionState.error(e.toString()));
    }
  }
}
