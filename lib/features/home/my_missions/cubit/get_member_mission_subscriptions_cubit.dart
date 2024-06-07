import 'package:app/models/prf_mission_subscription.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_member_mission_subscriptions_state.dart';
part 'get_member_mission_subscriptions_cubit.freezed.dart';

class GetMemberMissionSubscriptionsCubit
    extends Cubit<GetMemberMissionSubscriptionsState> {
  GetMemberMissionSubscriptionsCubit({
    required MissionService missionService,
    required HiveService hiveService,
  }) : super(const GetMemberMissionSubscriptionsState.initial()) {
    _missionService = missionService;
    _hiveService = hiveService;
  }

  late MissionService _missionService;
  late HiveService _hiveService;

  Future<void> getUpcomingMissions() async {
    emit(const GetMemberMissionSubscriptionsState.loading());
    try {
      final member = _hiveService.retrieveMember()!;
      final missionSubscriptions = await _missionService.getSubscriptions(
        includes: 'mission.missionType,mission.school',
        memberUlid: member.ulid,
        upcoming: true,
      );
      emit(
        GetMemberMissionSubscriptionsState.loaded(
          missionSubscriptions: missionSubscriptions,
        ),
      );
    } catch (e) {
      emit(GetMemberMissionSubscriptionsState.error(e.toString()));
    }
  }
}
