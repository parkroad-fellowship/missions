import 'package:app/enums/prf_mission_status.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_missions_state.dart';
part 'get_missions_cubit.freezed.dart';

class GetMissionsCubit extends Cubit<GetMissionsState> {
  GetMissionsCubit({
    required MissionService missionService,
    required IsarService isarService,
  }) : super(const GetMissionsState.initial()) {
    _missionService = missionService;
    _isarService = isarService;
  }

  late MissionService _missionService;
  late IsarService _isarService;

  Future<void> getMissions({bool refresh = false}) async {
    emit(const GetMissionsState.loading());
    try {
      if (!refresh) {
        await _isarService.missions.refreshStream();
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
          'status_keys': [
            PRFMissionStatus.approved.apiKey,
            PRFMissionStatus.fullySubscribed.apiKey,
          ].join(','),
          'unsubscribed': true,
          'upcoming': true,
        },
        orderBy: 'start_date',
        orderDirection: 'asc',
      );

      await _isarService.missions.persistEntities(missions);
      await _isarService.missions.refreshStream();
      emit(const GetMissionsState.loaded());
    } on Failure catch (e) {
      emit(GetMissionsState.error(e.message));
    } catch (e) {
      emit(GetMissionsState.error(e.toString()));
    }
  }
}
