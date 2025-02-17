import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/mission_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_subscribers_state.dart';
part 'get_subscribers_cubit.freezed.dart';

class GetSubscribersCubit extends Cubit<GetSubscribersState> {
  GetSubscribersCubit({required MissionService missionService})
    : super(const GetSubscribersState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

  Future<void> getSubscriptions({required String missionUlid}) async {
    emit(const GetSubscribersState.loading());
    try {
      final missionSubscriptions = await _missionService.getSubscriptions(
        missionUlid: missionUlid,
        subscriptionStatus: PRFMissionSubscriptionStatus.approved,
        includes: 'member',
      );
      emit(GetSubscribersState.loaded(subscriptions: missionSubscriptions));
    } on Failure catch (e) {
      emit(GetSubscribersState.error(e.message));
    } catch (e) {
      emit(GetSubscribersState.error(e.toString()));
    }
  }
}
