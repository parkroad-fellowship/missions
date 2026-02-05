import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/mission/prf_mission_session_dto.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_mission_session_cubit.freezed.dart';
part 'add_mission_session_state.dart';

class AddMissionSessionCubit extends Cubit<AddMissionSessionState> {
  AddMissionSessionCubit({
    required MissionSessionService missionSessionService,
    required IsarService isarService,
  }) : super(const AddMissionSessionState.initial()) {
    _missionSessionService = missionSessionService;
    _isarService = isarService;
  }

  late MissionSessionService _missionSessionService;
  late IsarService _isarService;

  Future<void> addSession({
    required String missionUlid,
    required String facilitatorUlid,
    required DateTime startsAt,
    required DateTime endsAt,
    required String notes,
    String? speakerUlid,
    String? classGroupUlid,
  }) async {
    emit(const AddMissionSessionState.loading());
    try {
      final missionSession = await _missionSessionService.create(
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
      await _isarService.missionSessions.persistEntity(missionSession);

      emit(const AddMissionSessionState.loaded());
    } on Failure catch (e) {
      emit(AddMissionSessionState.error(e.message));
    } catch (e) {
      emit(AddMissionSessionState.error(e.toString()));
    }
  }
}
