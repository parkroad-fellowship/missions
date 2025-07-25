import 'package:app/models/remote/failure.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_state.dart';
part 'get_mission_cubit.freezed.dart';

class GetMissionCubit extends Cubit<GetMissionState> {
  GetMissionCubit({
    required MissionService missionService,
    required IsarService isarService,
  }) : super(const GetMissionState.initial()) {
    _isarService = isarService;
    _missionService = missionService;
  }

  late IsarService _isarService;
  late MissionService _missionService;

  Future<void> getMission({
    required String missionUlid,
  }) async {
    emit(const GetMissionState.loading());
    try {
      final localMission = await _isarService.missions.get(missionUlid);
      if (localMission == null) {
        final mission = await _missionService.get(
          ulid: missionUlid,
          includes: [
            'school',
            'missionType',
            'school.schoolContacts.contactType',
            'loggedInMemberMissionSubscription',
            'weatherForecasts',
          ],
        );
        await _isarService.missions.persistEntity(mission);
      }

      await _isarService.missions.refreshItemStream(missionUlid);
      emit(const GetMissionState.loaded());
    } on Failure catch (e) {
      emit(GetMissionState.error(e.message));
    } catch (e) {
      emit(GetMissionState.error(e.toString()));
    }
  }
}
