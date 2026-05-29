import 'package:app/models/remote/event/prf_event_subscription.dart';
import 'package:app/models/remote/event/prf_event_subscription_dto.dart';
import 'package:app/services/api/event_subscription_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class EventSubscriptionResourceCubit
    extends ResourceCubit<PRFEventSubscription> {
  EventSubscriptionResourceCubit({
    required EventSubscriptionService eventSubscriptionService,
    required HiveService hiveService,
  }) : _hiveService = hiveService,
       super(
         service: eventSubscriptionService,
         dbService: hiveService.eventSubscriptions,
       );

  final HiveService _hiveService;

  @override
  List<String> get defaultIncludes => [
    'member',
    'prfEvent.posters',
    'prfEvent.loggedInMemberEventSubscription',
  ];

  /// Create an event subscription.
  Future<void> addSubscription({
    required String eventUlid,
    required int numberOfAttendees,
  }) async {
    final dto = PRFEventSubscriptionDTO(
      eventUlid: eventUlid,
      memberUlid: _hiveService.retrieveMember()!.ulid,
      numberOfAttendees: numberOfAttendees,
    );
    await create(data: dto.toJson());
  }

  /// Update an event subscription.
  Future<void> updateSubscription({
    required String ulid,
    required String eventUlid,
    required int numberOfAttendees,
  }) async {
    final dto = PRFEventSubscriptionDTO(
      eventUlid: eventUlid,
      memberUlid: _hiveService.retrieveMember()!.ulid,
      numberOfAttendees: numberOfAttendees,
    );
    await update(
      id: ulid,
      data: dto.toJson(),
      matchById: (s) => s.ulid == ulid,
    );
  }

  /// Delete an event subscription.
  Future<void> deleteSubscription(String ulid) async {
    await delete(ulid: ulid, matchById: (s) => s.ulid == ulid);
  }
}
