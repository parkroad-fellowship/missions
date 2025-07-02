import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/mission_subscription_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'get_member_mission_subscriptions_state.dart';
part 'get_member_mission_subscriptions_cubit.freezed.dart';

class GetMemberMissionSubscriptionsCubit
    extends Cubit<GetMemberMissionSubscriptionsState> {
  GetMemberMissionSubscriptionsCubit({
    required MissionSubscriptionService missionSubscriptionService,
    required HiveService hiveService,
    required LocalDBService localDBService,
  }) : super(const GetMemberMissionSubscriptionsState.initial()) {
    _missionSubscriptionService = missionSubscriptionService;
    _hiveService = hiveService;
    _localDBService = localDBService;
  }

  late MissionSubscriptionService _missionSubscriptionService;
  late HiveService _hiveService;
  late LocalDBService _localDBService;

  Future<void> getSubscriptions({bool refresh = false}) async {
    emit(const GetMemberMissionSubscriptionsState.loading());
    try {
      if (!refresh) {
        await _localDBService.refreshMemberMissions();
        emit(const GetMemberMissionSubscriptionsState.loaded());
        return;
      }

      final member = _hiveService.retrieveMember()!;
      final missionSubscriptions = await _missionSubscriptionService.list(
        includes: [
          'mission.missionType,mission.school',
          'mission.school.schoolContacts.contactType',
          'mission.weatherForecasts',
        ],
        filters: {
          'filter[member_ulid]': member.ulid,
          'filter[status_keys]': [
            PRFMissionSubscriptionStatus.approved.apiKey,
            PRFMissionSubscriptionStatus.withdrawn.apiKey,
            PRFMissionSubscriptionStatus.pending.apiKey,
            PRFMissionSubscriptionStatus.fullySubscribed.apiKey,
            PRFMissionSubscriptionStatus.conflict.apiKey,
          ].join(','),
        },
      );

      await _localDBService.persistMemberMissions(
        missionSubscriptions: missionSubscriptions,
      );
      await _localDBService.refreshMemberMissions();
      emit(const GetMemberMissionSubscriptionsState.loaded());
    } on Failure catch (e) {
      emit(GetMemberMissionSubscriptionsState.error(e.message));
    } catch (e, s) {
      Logger().e(e.toString(), stackTrace: s);
      emit(GetMemberMissionSubscriptionsState.error(e.toString()));
    }
  }
}
