import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_mission_question_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_mission_question_state.dart';
part 'add_mission_question_cubit.freezed.dart';

class AddMissionQuestionCubit extends Cubit<AddMissionQuestionState> {
  AddMissionQuestionCubit({
    required DebriefService debriefService,
  }) : super(const AddMissionQuestionState.initial()) {
    _debriefService = debriefService;
  }

  late DebriefService _debriefService;

  Future<void> addMissionQuestion({
    required String missionUlid,
    required String question,
  }) async {
    emit(const AddMissionQuestionState.loading());
    try {
      await _debriefService.addMissionQuestion(
        missionQuestionDTO: PRFMissionQuestionDTO(
          question: question,
          missionUlid: missionUlid,
        ),
      );
      emit(const AddMissionQuestionState.loaded());
    } on Failure catch (e) {
      emit(AddMissionQuestionState.error(e.message));
    } catch (e) {
      emit(AddMissionQuestionState.error(e.toString()));
    }
  }
}
