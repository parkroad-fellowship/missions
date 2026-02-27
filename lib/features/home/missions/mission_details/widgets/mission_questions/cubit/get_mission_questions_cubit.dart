import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/mission_question_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_mission_questions_state.dart';
part 'get_mission_questions_cubit.freezed.dart';

class GetMissionQuestionsCubit extends Cubit<GetMissionQuestionsState> {
  GetMissionQuestionsCubit({
    required MissionQuestionService missionQuestionService,
    required IsarService isarService,
  }) : super(const GetMissionQuestionsState.initial()) {
    _missionQuestionService = missionQuestionService;
    _isarService = isarService;
  }

  late MissionQuestionService _missionQuestionService;
  late IsarService _isarService;

  Future<void> getMissionQuestions({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetMissionQuestionsState.loading());
    try {
      if (!refresh) {
        await _isarService.missionQuestions.refreshParentStream(missionUlid);
        emit(const GetMissionQuestionsState.loaded());
        return;
      }

      final missionQuestions = await _missionQuestionService.list(
        filters: {'mission_ulid': missionUlid},
        includes: const ['mission'],
      );
      await _isarService.missionQuestions.persistEntities(
        missionQuestions,
      );
      await _isarService.missionQuestions.refreshParentStream(missionUlid);
      emit(const GetMissionQuestionsState.loaded());
    } on Failure catch (e) {
      emit(GetMissionQuestionsState.error(e.message));
    } catch (e) {
      emit(GetMissionQuestionsState.error(e.toString()));
    }
  }
}
