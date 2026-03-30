import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/local_storage/isar/mission_subscription_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionSubscriptionResourceCubit
    extends ResourceCubit<PRFMissionSubscription> {
  MissionSubscriptionResourceCubit({
    required MissionSubscriptionService missionSubscriptionService,
    super.dbService,
  }) : super(service: missionSubscriptionService);

  @override
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    final parentKey = filters?['mission_ulid'] as String?;
    if (parentKey != null && dbService is MissionSubscriptionDbService) {
      await (dbService! as MissionSubscriptionDbService).refreshParentStream(
        parentKey,
      );
    }
    await dbService?.refreshStream();
  }

  @override
  List<String> get defaultIncludes => [
    'member.profilePicture',
    'mission.school',
    'mission.schoolTerm',
    'mission.missionType',
    'mission.school.schoolContacts.contactType',
    'mission.loggedInMemberMissionSubscription',
    'mission.weatherForecasts',
    'mission.accountingEvent',
  ];

  @override
  Map<String, dynamic> get defaultFilters => {
    'status_keys': [
      PRFMissionSubscriptionStatus.approved.apiKey,
    ].join(','),
  };

  @override
  String? get defaultOrderDirection => 'desc';

  @override
  String? get defaultOrderBy => 'created_at';
}
