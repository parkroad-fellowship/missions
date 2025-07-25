import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_question_dto.dart';
import 'package:app/services/api/mission_question_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_mission_question_state.dart';
part 'add_mission_question_cubit.freezed.dart';

class AddMissionQuestionCubit extends Cubit<AddMissionQuestionState> {
  AddMissionQuestionCubit({
    required MissionQuestionService missionQuestionService,
    required IsarService isarService,
  }) : super(const AddMissionQuestionState.initial()) {
    _missionQuestionService = missionQuestionService;
    _isarService = isarService;
  }

  late MissionQuestionService _missionQuestionService;
  late IsarService _isarService;

  Future<void> addMissionQuestion({
    required String missionUlid,
    required String question,
  }) async {
    emit(const AddMissionQuestionState.loading());
    try {
      final missionQuestion = await _missionQuestionService.create(
        data: PRFMissionQuestionDTO(
          question: question,
          missionUlid: missionUlid,
        ).toJson(),
        includes: const ['mission'],
      );

      await _isarService.missionQuestions.persistEntity(
        missionQuestion,
      );
      emit(const AddMissionQuestionState.loaded());
    } on Failure catch (e) {
      emit(AddMissionQuestionState.error(e.message));
    } catch (e) {
      emit(AddMissionQuestionState.error(e.toString()));
    }
  }
}
