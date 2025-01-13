import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart' as collection;

part 'get_mission_sessions_state.dart';
part 'get_mission_sessions_cubit.freezed.dart';

class GetMissionSessionsCubit extends Cubit<GetMissionSessionsState> {
  GetMissionSessionsCubit({
    required MissionService missionService,
  }) : super(GetMissionSessionsState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

  Future<void> getMissionSessions({
    required String missionUlid,
  }) async {
    emit(GetMissionSessionsState.loading());
    try {
      final missionSessions =
          await _missionService.getMissionSessions(missionUlid: missionUlid);

      // // Sort the mission sessions by start date
      // final copy = List<PRFMissionSession>.from(missionSessions)
      //   ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

      final groupedSessions = collection.groupBy<PRFMissionSession, DateTime>(
        missionSessions,
        (session) => DateTime(session.startsAt.year, session.startsAt.month,
            session.startsAt.day),
      );

      if (missionSessions.isEmpty) {
        emit(GetMissionSessionsState.empty());
        return;
      }

      emit(GetMissionSessionsState.loaded(groupedSessions: groupedSessions));
    } catch (e) {
      emit(GetMissionSessionsState.error(e.toString()));
    }
  }
}
