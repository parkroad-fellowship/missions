import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class MissionSubscriptionResourceCubit
    extends ResourceCubit<PRFMissionSubscription> {
  MissionSubscriptionResourceCubit({
    required MissionSubscriptionService missionSubscriptionService,
    super.dbService,
  }) : super(service: missionSubscriptionService);

  @override
  List<String> get defaultIncludes => ['member.profilePicture', 'mission'];
}
