import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/models/remote/prf_event_subscription_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_event_subscription_state.dart';
part 'add_event_subscription_cubit.freezed.dart';

class AddEventSubscriptionCubit extends Cubit<AddEventSubscriptionState> {
  AddEventSubscriptionCubit({
    required HiveService hiveService,
    required EventService eventService,
  }) : super(AddEventSubscriptionState.initial()) {
    _hiveService = hiveService;
    _eventService = eventService;
  }

  late HiveService _hiveService;
  late EventService _eventService;

  Future<void> addEventSubscription({
    required PRFEvent event,
    required String tickets,
  }) async {
    try {
      emit(AddEventSubscriptionState.loading());
      final member = _hiveService.retrieveMember()!;
      final subscription = await _eventService.subscribe(
        subscriptionDTO: PRFEventSubscriptionDTO(
          eventUlid: event.ulid,
          memberUlid: member.ulid,
          numberOfAttendees: int.parse(tickets),
        ),
      );
      emit(AddEventSubscriptionState.loaded(subscription: subscription));
    } on Failure catch (e) {
      emit(AddEventSubscriptionState.error(e.message));
    } catch (e) {
      emit(AddEventSubscriptionState.error(e.toString()));
    }
  }
}
