import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/models/remote/prf_debrief_note_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/debrief_note_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_debrief_note_state.dart';
part 'add_debrief_note_cubit.freezed.dart';

class AddDebriefNoteCubit extends Cubit<AddDebriefNoteState> {
  AddDebriefNoteCubit({
    required DebriefNoteService debriefNoteService,
    required LocalDBService localDBService,
  }) : super(const AddDebriefNoteState.initial()) {
    _debriefNoteService = debriefNoteService;
    _localDBService = localDBService;
  }

  late DebriefNoteService _debriefNoteService;
  late LocalDBService _localDBService;

  Future<void> addDebriefNote({
    required String missionUlid,
    required String note,
  }) async {
    emit(const AddDebriefNoteState.loading());
    try {
      final debriefNote = await _debriefNoteService.create(
        data: PRFDebriefNoteDTO(missionUlid: missionUlid, note: note).toJson(),
      );
      await _localDBService.persistDebriefNotes(
        debriefNotes: [debriefNote],
        missionUlid: missionUlid,
      );
      emit(AddDebriefNoteState.loaded(debriefNote: debriefNote));
    } on Failure catch (e) {
      emit(AddDebriefNoteState.error(e.message));
    } catch (e) {
      emit(AddDebriefNoteState.error(e.toString()));
    }
  }
}
