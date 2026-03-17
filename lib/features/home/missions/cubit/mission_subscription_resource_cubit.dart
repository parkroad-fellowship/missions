import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionSubscriptionResourceCubit
    extends ResourceCubit<PRFMissionSubscription> {
  MissionSubscriptionResourceCubit({
    required MissionSubscriptionService missionSubscriptionService,
    BaseLocalDBService<PRFMissionSubscription, dynamic>? dbService,
  }) : super(service: missionSubscriptionService, dbService: dbService);

  @override
  List<String> get defaultIncludes => ['member.profilePicture', 'mission'];
}
