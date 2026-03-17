import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/local_storage/isar/mission_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionResourceCubit extends ResourceCubit<PRFMission> {
  MissionResourceCubit({
    required MissionService missionService,
    super.dbService,
  }) : super(service: missionService);

  @override
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    if (dbService is MissionDbService) {
      await (dbService! as MissionDbService).refreshStream();
    }
    await dbService?.refreshStream();
  }

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
