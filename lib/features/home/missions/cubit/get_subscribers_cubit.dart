import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_subscribers_state.dart';
part 'get_subscribers_cubit.freezed.dart';

class GetSubscribersCubit extends Cubit<GetSubscribersState> {
  GetSubscribersCubit({
    required MissionSubscriptionService missionSubscriptionService,
    required IsarService isarService,
  }) : super(const GetSubscribersState.initial()) {
    _missionSubscriptionService = missionSubscriptionService;
    _isarService = isarService;
  }

  late MissionSubscriptionService _missionSubscriptionService;
  late IsarService _isarService;

  Future<void> getSubscriptions({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetSubscribersState.loading());
    try {
      if (!refresh) {
        await _isarService.missionSubscriptions.refreshParentStream(
          missionUlid,
        );
        emit(const GetSubscribersState.loaded());
        return;
      }

      final missionSubscriptions = await _missionSubscriptionService.list(
        filters: {
          'mission_ulid': missionUlid,
          'status_key': PRFMissionSubscriptionStatus.approved.apiKey,
        },
        includes: ['member.profilePicture', 'mission'],
      );

      await _isarService.missionSubscriptions.persistEntities(
        missionSubscriptions,
      );
      await _isarService.missionSubscriptions.refreshParentStream(missionUlid);

      emit(const GetSubscribersState.loaded());
    } on Failure catch (e) {
      emit(GetSubscribersState.error(e.message));
    } catch (e) {
      emit(GetSubscribersState.error(e.toString()));
    }
  }
}
