import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/models/remote/prf_event_subscription_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/event_subscription_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_event_subscription_state.dart';
part 'add_event_subscription_cubit.freezed.dart';

class AddEventSubscriptionCubit extends Cubit<AddEventSubscriptionState> {
  AddEventSubscriptionCubit({
    required HiveService hiveService,
    required EventSubscriptionService eventSubscriptionService,
  }) : super(const AddEventSubscriptionState.initial()) {
    _hiveService = hiveService;
    _eventSubscriptionService = eventSubscriptionService;
  }

  late HiveService _hiveService;
  late EventSubscriptionService _eventSubscriptionService;

  Future<void> addEventSubscription({
    required PRFEvent event,
    required String tickets,
  }) async {
    try {
      emit(const AddEventSubscriptionState.loading());
      final member = _hiveService.retrieveMember()!;
      final subscription = await _eventSubscriptionService.create(
        data: PRFEventSubscriptionDTO(
          eventUlid: event.ulid,
          memberUlid: member.ulid,
          numberOfAttendees: int.parse(tickets),
        ).toJson(),
      );
      emit(AddEventSubscriptionState.loaded(subscription: subscription));
    } on Failure catch (e) {
      emit(AddEventSubscriptionState.error(e.message));
    } catch (e) {
      emit(AddEventSubscriptionState.error(e.toString()));
    }
  }
}
