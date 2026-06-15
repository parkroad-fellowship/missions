import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/models/remote/mission/prf_mission_subscription_dto.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'subscribe_state.dart';
part 'subscribe_cubit.freezed.dart';

class SubscribeCubit extends Cubit<SubscribeState> {
  SubscribeCubit({
    required MissionSubscriptionService missionSubscriptionService,
    required HiveService hiveService,
  }) : super(const SubscribeState.initial()) {
    _missionSubscriptionService = missionSubscriptionService;
    _hiveService = hiveService;
  }

  late MissionSubscriptionService _missionSubscriptionService;
  late HiveService _hiveService;

  Future<void> subscribe({required String missionUlid}) async {
    emit(const SubscribeState.loading());
    try {
      final member = _hiveService.retrieveMember()!;
      final missionSubscription = await _missionSubscriptionService.create(
        data: PRFMissionSubscriptionDTO(
          missionUlid: missionUlid,
          memberUlid: member.ulid,
        ).toJson(),
        includes: ['mission', 'member.profilePicture'],
      );
      await _hiveService.missionSubscriptions.persistEntity(
        missionSubscription,
      );

      emit(SubscribeState.loaded(subscription: missionSubscription));
    } on Failure catch (e) {
      emit(SubscribeState.error(e.message));
    } catch (e, s) {
      Logger().e(e.toString(), stackTrace: s);
      emit(SubscribeState.error(e.toString()));
    }
  }
}
