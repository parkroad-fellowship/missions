import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/local_storage/hive/db/mission_subscription_hive_db_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionSubscriptionResourceCubit
    extends ResourceCubit<PRFMissionSubscription> {
  MissionSubscriptionResourceCubit({
    required MissionSubscriptionService missionSubscriptionService,
    required HiveService hiveService,
  }) : super(
         service: missionSubscriptionService,
         dbService: hiveService.missionSubscriptions,
       );

  @override
  Future<void> refreshIsarStreams({Map<String, dynamic>? filters}) async {
    final parentKey = filters?['mission_ulid'] as String?;
    if (parentKey != null && dbService is MissionSubscriptionHiveDbService) {
      await (dbService as MissionSubscriptionHiveDbService).refreshParentStream(
        parentKey,
      );
    }
    await dbService.refreshStream();
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
      PRFMissionSubscriptionStatus.fullySubscribed.apiKey,
    ].join(','),
  };

  @override
  String? get defaultSortBy => '-created_at';
}
