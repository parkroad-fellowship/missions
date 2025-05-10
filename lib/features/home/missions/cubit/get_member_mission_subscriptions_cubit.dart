import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'get_member_mission_subscriptions_state.dart';
part 'get_member_mission_subscriptions_cubit.freezed.dart';

class GetMemberMissionSubscriptionsCubit
    extends Cubit<GetMemberMissionSubscriptionsState> {
  GetMemberMissionSubscriptionsCubit({
    required MissionService missionService,
    required HiveService hiveService,
    required LocalDBService localDBService,
  }) : super(const GetMemberMissionSubscriptionsState.initial()) {
    _missionService = missionService;
    _hiveService = hiveService;
    _localDBService = localDBService;
  }

  late MissionService _missionService;
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
      final missionSubscriptions = await _missionService.getSubscriptions(
        includes:
            'mission.missionType,mission.school,'
            'mission.school.schoolContacts.contactType,'
            'mission.weatherForecasts',
        memberUlid: member.ulid,
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
