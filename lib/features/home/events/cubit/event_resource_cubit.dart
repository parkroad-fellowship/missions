import 'package:app/enums/event/prf_event_type.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/services/api/event_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class EventResourceCubit extends ResourceCubit<PRFEvent> {
  EventResourceCubit({
    required EventService eventService,
    BaseLocalDBService<PRFEvent, dynamic>? dbService,
  }) : super(service: eventService, dbService: dbService);

  @override
  List<String> get defaultIncludes => [
    'weatherForecasts',
    'eventSubscriptions',
    'loggedInMemberEventSubscription',
    'posters',
  ];

  @override
  String? get defaultOrderBy => 'start_date';

  @override
  String? get defaultOrderDirection => 'asc';

  @override
  Map<String, dynamic> get defaultFilters => {
    'unsubscribed': true,
    'event_type': PRFEventType.member.apiKey,
  };
}
