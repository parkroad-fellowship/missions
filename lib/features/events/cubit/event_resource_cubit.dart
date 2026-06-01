import 'package:app/enums/event/prf_event_type.dart';
import 'package:app/models/remote/event/prf_event.dart';
import 'package:app/services/api/event_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class EventResourceCubit extends ResourceCubit<PRFEvent> {
  EventResourceCubit({
    required EventService eventService,
    required HiveService hiveService,
  }) : super(service: eventService, dbService: hiveService.events);

  @override
  List<String> get defaultIncludes => [
    'weatherForecasts',
    'eventSubscriptions',
    'loggedInMemberEventSubscription',
    'posters',
    'transcripts.media',
  ];

  @override
  String? get defaultSortBy => '-start_date';

  @override
  Map<String, dynamic> get defaultFilters => {
    'unsubscribed': true,
    'event_type': PRFEventType.member.apiKey,
  };

  @override
  Future<List<PRFEvent>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    return dbService.list();
  }
}
