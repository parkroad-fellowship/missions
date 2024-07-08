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
  }) : super(const GetMissionQuestionsState.initial()) {
    _debriefService = debriefService;
  }

  late DebriefService _debriefService;

  Future<void> getMissionQuestions({
    required String missionUlid,
  }) async {
    emit(const GetMissionQuestionsState.loading());
    try {
      final missionQuestions = await _debriefService.getMissionQuestions(
        missionUlid: missionUlid,
      );
      emit(GetMissionQuestionsState.loaded(missionQuestions: missionQuestions));
    } on Failure catch (e) {
      emit(GetMissionQuestionsState.error(e.message));
    } catch (e) {
      emit(GetMissionQuestionsState.error(e.toString()));
    }
  }
}
