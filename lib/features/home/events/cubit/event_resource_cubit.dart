import 'package:app/enums/event/prf_event_type.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/services/api/event_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class EventResourceCubit extends ResourceCubit<PRFEvent> {
  EventResourceCubit({
    required EventService eventService,
    super.dbService,
  }) : super(service: eventService);

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
