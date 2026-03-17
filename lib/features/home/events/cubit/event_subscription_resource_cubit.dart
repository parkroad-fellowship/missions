import 'package:app/models/remote/event/prf_event_subscription.dart';
import 'package:app/services/api/event_subscription_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class EventSubscriptionResourceCubit
    extends ResourceCubit<PRFEventSubscription> {
  EventSubscriptionResourceCubit({
    required EventSubscriptionService eventSubscriptionService,
    super.dbService,
  }) : super(service: eventSubscriptionService);

  @override
  List<String> get defaultIncludes => [
    'member',
    'prfEvent.posters',
    'prfEvent.loggedInMemberEventSubscription',
  ];

  /// Create an event subscription.
  Future<void> addSubscription({required Map<String, dynamic> data}) async {
    await create(data: data);
  }

  /// Update an event subscription.
  Future<void> updateSubscription({
    required String ulid,
    required Map<String, dynamic> data,
  }) async {
    await update(
      id: ulid,
      data: data,
      matchById: (s) => s.ulid == ulid,
    );
  }

  /// Delete an event subscription.
  Future<void> deleteSubscription(String ulid) async {
    await delete(ulid: ulid, matchById: (s) => s.ulid == ulid);
  }
}
