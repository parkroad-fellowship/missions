import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/models/local/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionResourceCubit extends ResourceCubit<PRFMission, PRFLocalMission> {
  MissionResourceCubit({
    required MissionService missionService,
    super.dbService,
  }) : super(service: missionService);

  @override
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    await dbService?.refreshStream();
  }

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
}
