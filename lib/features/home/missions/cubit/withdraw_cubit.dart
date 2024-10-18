import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/models/remote/prf_mission_subscription_update_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_state.dart';
part 'withdraw_cubit.freezed.dart';

class WithdrawCubit extends Cubit<WithdrawState> {
  WithdrawCubit({
    required MissionService missionService,
    required HiveService hiveService,
  }) : super(const WithdrawState.initial()) {
    _missionService = missionService;
    _hiveService = hiveService;
  }

  late MissionService _missionService;
  late HiveService _hiveService;

  Future<void> withdraw({
    required String missionSubscriptionUlid,
    required String missionUlid,
  }) async {
    emit(const WithdrawState.loading());
    try {
      final member = _hiveService.retrieveMember()!;

      final missionSubscription = await _missionService.updateSubscription(
        missionSubscriptionUlid: missionSubscriptionUlid,
        subscriptionDTO: PRFMissionSubscriptionUpdateDTO(
          missionUlid: missionUlid,
          memberUlid: member.ulid,
          status: PRFMissionSubscriptionStatus.withdrawn,
        ),
      );
      emit(WithdrawState.loaded(subscription: missionSubscription));
    } on Failure catch (e) {
      emit(WithdrawState.error(e.message));
    } catch (e) {
      emit(WithdrawState.error(e.toString()));
    }
  }
}
