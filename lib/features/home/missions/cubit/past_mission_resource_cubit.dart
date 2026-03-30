import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/features/home/missions/cubit/mission_resource_cubit.dart'
    show MissionResourceCubit;
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

/// Cubit for loading past/completed missions.
/// Separate from [MissionResourceCubit] so the "All" and "Past" tabs
/// maintain independent state without overwriting each other.
class PastMissionResourceCubit extends ResourceCubit<PRFMission> {
  PastMissionResourceCubit({
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

  @override
  Map<String, dynamic> get defaultFilters => {
    'past': true,
    'status_keys': [
      PRFMissionStatus.approved.apiKey,
      PRFMissionStatus.fullySubscribed.apiKey,
      PRFMissionStatus.serviced.apiKey,
    ].join(','),
  };

  @override
  String? get defaultSortBy => '-start_date';
}
