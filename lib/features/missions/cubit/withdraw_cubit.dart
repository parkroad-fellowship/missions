import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/models/remote/mission/prf_mission_subscription_update_dto.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_state.dart';
part 'withdraw_cubit.freezed.dart';

class WithdrawCubit extends Cubit<WithdrawState> {
  WithdrawCubit({
    required MissionSubscriptionService missionSubscriptionService,
    required HiveService hiveService,
  }) : super(const WithdrawState.initial()) {
    _missionSubscriptionService = missionSubscriptionService;
    _hiveService = hiveService;
  }

  late MissionSubscriptionService _missionSubscriptionService;
  late HiveService _hiveService;

  Future<void> withdraw({
    required String missionSubscriptionUlid,
    required String missionUlid,
  }) async {
    emit(const WithdrawState.loading());
    try {
      final member = _hiveService.retrieveMember()!;

      final missionSubscription = await _missionSubscriptionService.update(
        id: missionSubscriptionUlid,
        data: PRFMissionSubscriptionUpdateDTO(
          missionUlid: missionUlid,
          memberUlid: member.ulid,
          status: PRFMissionSubscriptionStatus.withdrawn,
        ).toJson(),
      );
      emit(WithdrawState.loaded(subscription: missionSubscription));
    } on Failure catch (e) {
      emit(WithdrawState.error(e.message));
    } catch (e) {
      emit(WithdrawState.error(e.toString()));
    }
  }
}
