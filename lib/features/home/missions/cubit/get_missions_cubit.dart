import 'package:app/enums/prf_mission_status.dart';
import 'package:app/models/remote/failure.dart';
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

  Future<void> getMissions({bool refresh = false}) async {
    emit(const GetMissionsState.loading());
    try {
      if (!refresh) {
        await _localDbService.refreshMissions();
        emit(const GetMissionsState.loaded());
        return;
      }
      final missions = await _missionService.list(
        includes: [
          'school',
          'missionType',
          'school.schoolContacts.contactType',
          'loggedInMemberMissionSubscription',
          'weatherForecasts',
        ],
        filters: {
          'filter[status_keys]': [
            PRFMissionStatus.approved.apiKey,
            PRFMissionStatus.fullySubscribed.apiKey,
          ].join(','),
          'filter[unsubscribed]': true,
        },
        orderBy: 'start_date',
        orderDirection: 'asc',
      );

      await _localDbService.persistMissions(missions: missions);
      await _localDbService.refreshMissions();
      emit(const GetMissionsState.loaded());
    } on Failure catch (e) {
      emit(GetMissionsState.error(e.message));
    } catch (e) {
      emit(GetMissionsState.error(e.toString()));
    }
  }
}
