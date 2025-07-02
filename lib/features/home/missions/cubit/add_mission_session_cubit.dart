import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_session_dto.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/local_db_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_mission_session_cubit.freezed.dart';
part 'add_mission_session_state.dart';

class AddMissionSessionCubit extends Cubit<AddMissionSessionState> {
  AddMissionSessionCubit({
    required MissionSessionService missionSessionService,
    required LocalDBService localDBService,
  }) : super(const AddMissionSessionState.initial()) {
    _missionSessionService = missionSessionService;
    _localDBService = localDBService;
  }

  late MissionSessionService _missionSessionService;
  late LocalDBService _localDBService;

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
          startsAt: startsAt.toIso8601String(),
          endsAt: endsAt.toIso8601String(),
          notes: notes,
          speakerUlid: speakerUlid,
          classGroupUlid: classGroupUlid,
        ).toJson(),
        includes: [
          'facilitator',
          'speaker',
          'classGroup',
          'missionSessionTranscripts.media',
        ],
      );
      await _localDBService.persistMissionSessions(
        missionSessions: [missionSession],
        missionUlid: missionUlid,
      );
      emit(const AddMissionSessionState.loaded());
    } on Failure catch (e) {
      emit(AddMissionSessionState.error(e.message));
    } catch (e) {
      emit(AddMissionSessionState.error(e.toString()));
    }
  }
}
