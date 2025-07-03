import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/models/remote/prf_event_subscription_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/event_subscription_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_event_subscription_cubit.freezed.dart';
part 'update_event_subscription_state.dart';

class UpdateEventSubscriptionCubit extends Cubit<UpdateEventSubscriptionState> {
  UpdateEventSubscriptionCubit({
    required EventSubscriptionService eventSubscriptionService,
    required HiveService hiveService,
  }) : super(const UpdateEventSubscriptionState.initial()) {
    _eventSubscriptionService = eventSubscriptionService;
    _hiveService = hiveService;
  }

  late EventSubscriptionService _eventSubscriptionService;
  late HiveService _hiveService;

  Future<void> updateEventSubscription({
    required String tickets,
    required PRFEventSubscription eventSubscription,
    required PRFEvent event,
  }) async {
    try {
      emit(const UpdateEventSubscriptionState.loading());
      final member = _hiveService.retrieveMember()!;
      final subscription = await _eventSubscriptionService.update(
        id: eventSubscription.ulid,
        data: PRFEventSubscriptionDTO(
          eventUlid: event.ulid,
          memberUlid: member.ulid,
          numberOfAttendees: int.parse(tickets),
        ).toJson(),
      );
      emit(UpdateEventSubscriptionState.loaded(subscription: subscription));
    } on Failure catch (e) {
      emit(UpdateEventSubscriptionState.error(e.message));
    } catch (e) {
      emit(UpdateEventSubscriptionState.error(e.toString()));
    }
  }
}
