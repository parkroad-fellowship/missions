import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionResourceCubit extends ResourceCubit<PRFMission> {
  MissionResourceCubit({
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

  @override
  Map<String, dynamic> get defaultFilters => {
    'upcoming': true,
    'status_keys': [
      PRFMissionStatus.approved.apiKey,
      PRFMissionStatus.fullySubscribed.apiKey,
    ].join(','),
  };

  @override
  String? get defaultSortBy => 'start_date';

  @override
  Future<List<PRFMission>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    return dbService.filterBy(
      (mission) => [
        filters?['upcoming'] == null || mission.endDate.isAfter(DateTime.now()),
        filters?['status_keys'] == null ||
            (filters!['status_keys'] as String)
                .split(',')
                .contains(mission.status.apiKey.toString()),
        filters?['search'] == null ||
            (mission.school?.name.toLowerCase().contains(
                  (filters!['search'] as String).toLowerCase(),
                ) ??
                false),
      ],
    );
  }
}
