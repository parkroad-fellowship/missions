import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/event_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_events_state.dart';
part 'get_events_cubit.freezed.dart';

class GetEventsCubit extends Cubit<GetEventsState> {
  GetEventsCubit({required EventService eventService})
    : super(const GetEventsState.initial()) {
    _eventService = eventService;
  }

  late EventService _eventService;

  Future<void> getEvents() async {
    emit(const GetEventsState.loading());
    try {
      final events = await _eventService.list(
        includes: [
          'weatherForecasts',
          'eventSubscriptions',
          'loggedInMemberEventSubscription,posters',
        ],
        orderBy: 'start_date',
        orderDirection: 'asc',
        filters: {
          'filter[unsubscribed]': true,
        },
      );
      if (events.isEmpty) {
        emit(const GetEventsState.empty());
      } else {
        emit(GetEventsState.loaded(events: events));
      }
    } on Failure catch (e) {
      emit(GetEventsState.error(e.message));
    } catch (e) {
      emit(GetEventsState.error(e.toString()));
    }
  }
}
