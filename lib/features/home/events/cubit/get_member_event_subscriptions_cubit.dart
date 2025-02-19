import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_member_event_subscriptions_state.dart';
part 'get_member_event_subscriptions_cubit.freezed.dart';

class GetMemberEventSubscriptionsCubit
    extends Cubit<GetMemberEventSubscriptionsState> {
  GetMemberEventSubscriptionsCubit({
    required HiveService hiveService,
    required EventService eventService,
  }) : super(const GetMemberEventSubscriptionsState.initial()) {
    _hiveService = hiveService;
    _eventService = eventService;
  }

  late HiveService _hiveService;
  late EventService _eventService;

  Future<void> getMemberEventSubscriptions() async {
    emit(const GetMemberEventSubscriptionsState.loading());
    try {
      final member = _hiveService.retrieveMember()!;
      final subscriptions = await _eventService.getSubscriptions(
        memberUlid: member.ulid,
        includes: 'member,prfEvent.posters',
      );
      if (subscriptions.isEmpty) {
        emit(const GetMemberEventSubscriptionsState.empty());
      } else {
        emit(
          GetMemberEventSubscriptionsState.loaded(subscriptions: subscriptions),
        );
      }
    } on Failure catch (f) {
      emit(GetMemberEventSubscriptionsState.error(f.message));
    } catch (e) {
      emit(GetMemberEventSubscriptionsState.error(e.toString()));
    }
  }
}
