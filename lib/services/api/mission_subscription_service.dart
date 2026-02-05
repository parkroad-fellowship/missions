import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/services/api/_base_api_service.dart';

class MissionSubscriptionService
    extends BaseAPIService<PRFMissionSubscription> {
  @override
  String get endpoint => '/mission-subscriptions';

  @override
  PRFMissionSubscription createFromJson(Map<String, dynamic> json) {
    return PRFMissionSubscription.fromJson(json);
  }

  @override
  List<PRFMissionSubscription> createListFromResponse(
    Map<String, dynamic> response,
  ) {
    return PRFMissionSubscriptionsResponse.fromJson(response).data;
  }
}
