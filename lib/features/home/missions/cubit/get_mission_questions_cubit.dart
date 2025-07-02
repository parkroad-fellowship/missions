import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/mission_question_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_questions_state.dart';
part 'get_mission_questions_cubit.freezed.dart';

class GetMissionQuestionsCubit extends Cubit<GetMissionQuestionsState> {
  GetMissionQuestionsCubit({
    required MissionQuestionService missionQuestionService,
    required LocalDBService localDBService,
  }) : super(const GetMissionQuestionsState.initial()) {
    _missionQuestionService = missionQuestionService;
    _localDBService = localDBService;
  }

  late MissionQuestionService _missionQuestionService;
  late LocalDBService _localDBService;

  Future<void> getMissionQuestions({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetMissionQuestionsState.loading());
    try {
      if (!refresh) {
        emit(const GetMissionQuestionsState.loaded());
        return;
      }

      final missionQuestions = await _missionQuestionService.list(
        filters: {'filter[mission_ulid]': missionUlid},
      );
      await _localDBService.persistMissionQuestions(
        missionQuestions: missionQuestions,
        missionUlid: missionUlid,
      );
      emit(const GetMissionQuestionsState.loaded());
    } on Failure catch (e) {
      emit(GetMissionQuestionsState.error(e.message));
    } catch (e) {
      emit(GetMissionQuestionsState.error(e.toString()));
    }
  }
}
