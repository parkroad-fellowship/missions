import 'package:app/models/prf_mission_subscription.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_past_member_missions_state.dart';
part 'get_past_member_missions_cubit.freezed.dart';

class GetPastMemberMissionsCubit extends Cubit<GetPastMemberMissionsState> {
  GetPastMemberMissionsCubit({
    required MissionService missionService,
    required HiveService hiveService,
  }) : super(const GetPastMemberMissionsState.initial()) {
    _missionService = missionService;
    _hiveService = hiveService;
  }

  late MissionService _missionService;
  late HiveService _hiveService;

  Future<void> getPastMissions() async {
    emit(const GetPastMemberMissionsState.loading());
    try {
      final member = _hiveService.retrieveMember()!;
      final missionSubscriptions = await _missionService.getSubscriptions(
        includes: 'mission.missionType,mission.school',
        memberUlid: member.ulid,
        past: true,
      );
      emit(
        GetPastMemberMissionsState.loaded(
          missionSubscriptions: missionSubscriptions,
        ),
      );
    } catch (e) {
      emit(GetPastMemberMissionsState.error(e.toString()));
    }
  }
}
