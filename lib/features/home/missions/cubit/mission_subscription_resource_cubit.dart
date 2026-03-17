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
      await (dbService as MissionSubscriptionDbService)
          .refreshParentStream(parentKey);
    }
    await dbService?.refreshStream();
  }

  @override
  List<String> get defaultIncludes => ['member.profilePicture', 'mission'];
}
