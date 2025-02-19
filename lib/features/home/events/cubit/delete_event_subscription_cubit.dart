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
}
