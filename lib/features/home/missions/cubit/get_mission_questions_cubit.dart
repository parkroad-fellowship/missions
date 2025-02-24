import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_question.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_questions_state.dart';
part 'get_mission_questions_cubit.freezed.dart';

class GetMissionQuestionsCubit extends Cubit<GetMissionQuestionsState> {
  GetMissionQuestionsCubit({
    required DebriefService debriefService,
    required LocalDBService localDBService,
  }) : super(const GetMissionQuestionsState.initial()) {
    _debriefService = debriefService;
    _localDBService = localDBService;
  }

  late DebriefService _debriefService;
  late LocalDBService _localDBService;

  Future<void> getMissionQuestions({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetMissionQuestionsState.loading());
    try {
      if (!refresh) {
        emit(GetMissionQuestionsState.loaded());
        return;
      }

      final missionQuestions = await _debriefService.getMissionQuestions(
        missionUlid: missionUlid,
      );
      await _localDBService.persistMissionQuestions(
        missionQuestions: missionQuestions,
        missionUlid: missionUlid,
      );
      emit(GetMissionQuestionsState.loaded());
    } on Failure catch (e) {
      emit(GetMissionQuestionsState.error(e.message));
    } catch (e) {
      emit(GetMissionQuestionsState.error(e.toString()));
    }
  }
}
