import 'package:app/models/local/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/utils/crud/single_resource_cubit.dart';

/// Cubit dedicated to mission details screen state.
///
/// Keeping this separate from the upcoming list cubit prevents detail page
/// fetches from mutating the list tab state.
class MissionDetailsResourceCubit
    extends SingleResourceCubit<PRFMission, PRFLocalMission> {
  MissionDetailsResourceCubit({
    required MissionService missionService,
    super.dbService,
  }) : super(service: missionService);

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
