import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/event_subscription_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_event_subscription_state.dart';
part 'delete_event_subscription_cubit.freezed.dart';

class DeleteEventSubscriptionCubit extends Cubit<DeleteEventSubscriptionState> {
  DeleteEventSubscriptionCubit({
    required EventSubscriptionService eventSubscriptionService,
  }) : super(const DeleteEventSubscriptionState.initial()) {
    _eventSubscriptionService = eventSubscriptionService;
  }

  late EventSubscriptionService _eventSubscriptionService;

  Future<void> deleteSubscription({
    required String eventSubscriptionUlid,
  }) async {
    try {
      emit(const DeleteEventSubscriptionState.loading());
      await _eventSubscriptionService.delete(
        ulid: eventSubscriptionUlid,
      );
      emit(const DeleteEventSubscriptionState.loaded());
    } on Failure catch (e) {
      emit(DeleteEventSubscriptionState.error(e.message));
    } catch (e) {
      emit(DeleteEventSubscriptionState.error(e.toString()));
    }
  }
}
