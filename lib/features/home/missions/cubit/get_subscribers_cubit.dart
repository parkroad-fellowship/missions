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
  GetSubscribersCubit({
    required MissionService missionService,
    required LocalDBService localDBService,
  }) : super(const GetSubscribersState.initial()) {
    _missionService = missionService;
    _localDBService = localDBService;
  }

  late MissionService _missionService;
  late LocalDBService _localDBService;

  Future<void> getSubscriptions({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetSubscribersState.loading());
    try {
      if (!refresh) {
        emit(GetSubscribersState.loaded());
        return;
      }

      final missionSubscriptions = await _missionService.getSubscriptions(
        missionUlid: missionUlid,
        subscriptionStatus: PRFMissionSubscriptionStatus.approved,
        includes: 'member',
      );
      await _localDBService.persistMissionSubscriptions(
        missionSubscriptions: missionSubscriptions,
        missionUlid: missionUlid,
      );
      emit(GetSubscribersState.loaded());
    } on Failure catch (e) {
      emit(GetSubscribersState.error(e.message));
    } catch (e) {
      emit(GetSubscribersState.error(e.toString()));
    }
  }
}
