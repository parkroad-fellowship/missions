import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionResourceCubit extends ResourceCubit<PRFMission> {
  MissionResourceCubit({
    required MissionService missionService,
    BaseLocalDBService<PRFMission, dynamic>? dbService,
  }) : super(service: missionService, dbService: dbService);

  @override
  List<String> get defaultIncludes => [
    'school',
    'missionType',
    'school.schoolContacts.contactType',
    'loggedInMemberMissionSubscription',
    'weatherForecasts',
    'accountingEvent',
    'accountingEvent.refunds',
    'accountingEvent.latestRefund',
  ];

  @override
  String? get defaultOrderBy => 'start_date';

  @override
  String? get defaultOrderDirection => 'asc';
}
