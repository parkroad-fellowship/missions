import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/mission/prf_mission_question_dto.dart';
import 'package:app/services/api/mission_question_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_mission_question_state.dart';
part 'update_mission_question_cubit.freezed.dart';

class UpdateMissionQuestionCubit
    extends Cubit<UpdateMissionQuestionState> {
  UpdateMissionQuestionCubit({
    required MissionQuestionService missionQuestionService,
    required IsarService isarService,
  }) : super(const UpdateMissionQuestionState.initial()) {
    _missionQuestionService = missionQuestionService;
    _isarService = isarService;
  }

  late MissionQuestionService _missionQuestionService;
  late IsarService _isarService;

  Future<void> updateMissionQuestion({
    required String missionQuestionUlid,
    required String missionUlid,
    required String question,
  }) async {
    emit(const UpdateMissionQuestionState.loading());
    try {
      final updatedQuestion = await _missionQuestionService.update(
        id: missionQuestionUlid,
        data: PRFMissionQuestionDTO(
          missionUlid: missionUlid,
          question: question,
        ).toJson(),
        includes: ['mission'],
      );

      await _isarService.missionQuestions.persistEntities(
        [updatedQuestion],
      );

      emit(const UpdateMissionQuestionState.loaded());
    } on Failure catch (e) {
      emit(UpdateMissionQuestionState.error(e.message));
    } catch (e) {
      emit(UpdateMissionQuestionState.error(e.toString()));
    }
  }
}
