import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_session_dto.dart';
import 'package:app/services/mission_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_mission_session_cubit.freezed.dart';
part 'add_mission_session_state.dart';

class AddMissionSessionCubit extends Cubit<AddMissionSessionState> {
  AddMissionSessionCubit({required MissionService missionService})
    : super(const AddMissionSessionState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

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
      await _missionService.addSession(
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
      emit(const AddMissionSessionState.loaded());
    } on Failure catch (e) {
      emit(AddMissionSessionState.error(e.message));
    } catch (e) {
      emit(AddMissionSessionState.error(e.toString()));
    }
  }
}
