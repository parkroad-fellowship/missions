import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/models/remote/prf_mission_subscription_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscribe_state.dart';
part 'subscribe_cubit.freezed.dart';

class SubscribeCubit extends Cubit<SubscribeState> {
  SubscribeCubit({
    required MissionService missionService,
    required HiveService hiveService,
  }) : super(const SubscribeState.initial()) {
    _missionService = missionService;
    _hiveService = hiveService;
  }

  late MissionService _missionService;
  late HiveService _hiveService;

  Future<void> subscribe({required String missionUlid}) async {
    emit(const SubscribeState.loading());
    try {
      final member = _hiveService.retrieveMember()!;
      final missionSubscription = await _missionService.subscribe(
        subscriptionDTO: PRFMissionSubscriptionDTO(
          missionUlid: missionUlid,
          memberUlid: member.ulid,
        ),
      );
      emit(SubscribeState.loaded(subscription: missionSubscription));
    } on Failure catch (e) {
      emit(SubscribeState.error(e.message));
    } catch (e) {
      emit(SubscribeState.error(e.toString()));
    }
  }
}
