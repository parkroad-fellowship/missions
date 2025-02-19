import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/models/remote/prf_event_subscription_dto.dart';
import 'package:app/services/event_service.dart';
import 'package:app/services/hive_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_event_subscription_state.dart';
part 'update_event_subscription_cubit.freezed.dart';

class UpdateEventSubscriptionCubit extends Cubit<UpdateEventSubscriptionState> {
  UpdateEventSubscriptionCubit({
    required EventService eventService,
    required HiveService hiveService,
  }) : super(const UpdateEventSubscriptionState.initial()) {
    _eventService = eventService;
    _hiveService = hiveService;
  }

  late EventService _eventService;
  late HiveService _hiveService;

  Future<void> updateEventSubscription({
    required String tickets,
    required PRFEventSubscription eventSubscription,
    required PRFEvent event,
  }) async {
    try {
      emit(const UpdateEventSubscriptionState.loading());
      final member = _hiveService.retrieveMember()!;
      final subscription = await _eventService.updateSubscription(
        eventSubscriptionUlid: eventSubscription.ulid,
        subscriptionDTO: PRFEventSubscriptionDTO(
          eventUlid: event.ulid,
          memberUlid: member.ulid,
          numberOfAttendees: int.parse(tickets),
        ),
      );
      emit(UpdateEventSubscriptionState.loaded(subscription: subscription));
    } on Failure catch (e) {
      emit(UpdateEventSubscriptionState.error(e.message));
    } catch (e) {
      emit(UpdateEventSubscriptionState.error(e.toString()));
    }
  }
}
