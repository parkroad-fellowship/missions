import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/mission_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_missions_state.dart';
part 'get_missions_cubit.freezed.dart';

class GetMissionsCubit extends Cubit<GetMissionsState> {
  GetMissionsCubit({
    required MissionService missionService,
    required LocalDBService localDBService,
  }) : super(const GetMissionsState.initial()) {
    _missionService = missionService;
    _localDbService = localDBService;
  }

  late MissionService _missionService;
  late LocalDBService _localDbService;

  Future<void> getMissions() async {
    emit(const GetMissionsState.loading());
    try {
      final missions = await _missionService.getMissions();

      await _localDbService.persistMissions(missions: missions);

      emit(GetMissionsState.loaded(missions: missions));
    } on Failure catch (e) {
      emit(GetMissionsState.error(e.message));
    } catch (e) {
      emit(GetMissionsState.error(e.toString()));
    }
  }
}
