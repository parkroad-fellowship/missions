import 'package:app/models/remote/failure.dart';
import 'package:app/services/event_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_event_subscription_state.dart';
part 'delete_event_subscription_cubit.freezed.dart';

class DeleteEventSubscriptionCubit extends Cubit<DeleteEventSubscriptionState> {
  DeleteEventSubscriptionCubit({required EventService eventService})
    : super(DeleteEventSubscriptionState.initial()) {
    _eventService = eventService;
  }

  late EventService _eventService;

  Future<void> deleteSubscription({
    required String eventSubscriptionUlid,
  }) async {
    try {
      emit(DeleteEventSubscriptionState.loading());
      await _eventService.unsubscribe(
        eventSubscriptionUlid: eventSubscriptionUlid,
      );
      emit(DeleteEventSubscriptionState.loaded());
    } on Failure catch (e) {
      emit(DeleteEventSubscriptionState.error(e.message));
    } catch (e) {
      emit(DeleteEventSubscriptionState.error(e.toString()));
    }
  }
}
