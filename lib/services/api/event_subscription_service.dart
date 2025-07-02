import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/services/api/_base_api_service.dart';

class EventSubscriptionService extends BaseAPIService<PRFEventSubscription> {
  @override
  String get endpoint => '/event-subscriptions';

  @override
  PRFEventSubscription createFromJson(Map<String, dynamic> json) {
    return PRFEventSubscription.fromJson(json);
  }

  @override
  List<PRFEventSubscription> createListFromResponse(
    Map<String, dynamic> response,
  ) {
    return PRFEventSubscriptionResponse.fromJson(response).data;
  }
}
