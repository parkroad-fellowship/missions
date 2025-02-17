import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' as collection;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_sessions_cubit.freezed.dart';
part 'get_mission_sessions_state.dart';

class GetMissionSessionsCubit extends Cubit<GetMissionSessionsState> {
  GetMissionSessionsCubit({required MissionService missionService})
    : super(const GetMissionSessionsState.initial()) {
    _missionService = missionService;
  }

  late MissionService _missionService;

  Future<void> getMissionSessions({required String missionUlid}) async {
    emit(const GetMissionSessionsState.loading());
    try {
      final missionSessions = await _missionService.getMissionSessions(
        missionUlid: missionUlid,
      );

      final groupedSessions = collection.groupBy<PRFMissionSession, DateTime>(
        missionSessions,
        (session) => DateTime(
          session.startsAt.year,
          session.startsAt.month,
          session.startsAt.day,
        ),
      );

      if (missionSessions.isEmpty) {
        emit(const GetMissionSessionsState.empty());
        return;
      }

      emit(GetMissionSessionsState.loaded(groupedSessions: groupedSessions));
    } catch (e) {
      emit(GetMissionSessionsState.error(e.toString()));
    }
  }
}
