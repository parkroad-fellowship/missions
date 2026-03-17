import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionResourceCubit extends ResourceCubit<PRFMission> {
  MissionResourceCubit({
    required MissionService missionService,
    super.dbService,
  }) : super(service: missionService);

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
