import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';
import 'package:logger/logger.dart';

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
  List<String> get defaultIncludes => [
    'member.profilePicture',
    'mission.school',
  ];

  @override
  Map<String, dynamic> get defaultFilters => {
    'status_keys': [
      PRFMissionSubscriptionStatus.approved.apiKey,
    ].join(','),
  };

  @override
  String? get defaultSortBy => '-created_at';

  @override
  Future<List<PRFMissionSubscription>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    Logger().f('MissionSubscriptionResourceCubit.loadCachedList: filters=$filters');
    return dbService.filterBy(
      (subscription) => [
        if (filters?['mission_ulid'] != null)
          subscription.mission?.ulid == filters!['mission_ulid'],
      ],
    );
  }
}
