import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/single_resource_cubit.dart';

/// Cubit dedicated to mission details screen state.
///
/// Keeping this separate from the upcoming list cubit prevents detail page
/// fetches from mutating the list tab state.
class MissionDetailsResourceCubit extends SingleResourceCubit<PRFMission> {
  MissionDetailsResourceCubit({
    required MissionService missionService,
    required HiveService hiveService,
  }) : super(service: missionService, dbService: hiveService.missions);

  @override
  List<String> get defaultIncludes => [
    'school',
    'schoolTerm',
    'missionType',
    'school.schoolContacts.contactType',
    'loggedInMemberMissionSubscription',
    'weatherForecasts',
    'accountingEvent',
  ];

  Future<void> loadMission({
    required String missionUlid,
    bool refresh = false,
  }) async {
    await loadOne(
      id: missionUlid,
      refresh: refresh,
      matchById: (mission) => mission.ulid == missionUlid,
    );
  }
}
