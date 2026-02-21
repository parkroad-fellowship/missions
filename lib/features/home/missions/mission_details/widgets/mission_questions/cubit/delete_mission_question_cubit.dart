import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/mission_question_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_mission_question_cubit.freezed.dart';
part 'delete_mission_question_state.dart';

class DeleteMissionQuestionCubit
    extends Cubit<DeleteMissionQuestionState> {
  DeleteMissionQuestionCubit({
    required MissionQuestionService missionQuestionService,
    required IsarService isarService,
  }) : super(const DeleteMissionQuestionState.initial()) {
    _missionQuestionService = missionQuestionService;
    _isarService = isarService;
  }

  late MissionQuestionService _missionQuestionService;
  late IsarService _isarService;

  Future<void> deleteMissionQuestion({
    required String missionQuestionUlid,
  }) async {
    emit(const DeleteMissionQuestionState.loading());
    try {
      await _missionQuestionService.delete(
        ulid: missionQuestionUlid,
      );
      await _isarService.missionQuestions.deleteByKey(
        missionQuestionUlid,
      );
      emit(const DeleteMissionQuestionState.loaded());
    } on Failure catch (e) {
      emit(DeleteMissionQuestionState.error(e.message));
    } catch (e) {
      emit(DeleteMissionQuestionState.error(e.toString()));
    }
  }
}
