import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/event_subscription_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_member_event_subscriptions_state.dart';
part 'get_member_event_subscriptions_cubit.freezed.dart';

class GetMemberEventSubscriptionsCubit
    extends Cubit<GetMemberEventSubscriptionsState> {
  GetMemberEventSubscriptionsCubit({
    required HiveService hiveService,
    required EventSubscriptionService eventSubscriptionService,
  }) : super(const GetMemberEventSubscriptionsState.initial()) {
    _hiveService = hiveService;
    _eventSubscriptionService = eventSubscriptionService;
  }

  late HiveService _hiveService;
  late EventSubscriptionService _eventSubscriptionService;

  Future<void> getMemberEventSubscriptions() async {
    emit(const GetMemberEventSubscriptionsState.loading());
    try {
      final member = _hiveService.retrieveMember()!;
      final subscriptions = await _eventSubscriptionService.list(
        filters: {
          'member_ulid': member.ulid,
        },
        includes: [
          'member',
          'prfEvent.posters',
          'prfEvent.loggedInMemberEventSubscription',
        ],
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
