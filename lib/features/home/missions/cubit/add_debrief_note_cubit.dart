import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/models/remote/prf_debrief_note_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_debrief_note_state.dart';
part 'add_debrief_note_cubit.freezed.dart';

class AddDebriefNoteCubit extends Cubit<AddDebriefNoteState> {
  AddDebriefNoteCubit({
    required DebriefService debriefService,
    required LocalDBService localDBService,
  }) : super(const AddDebriefNoteState.initial()) {
    _debriefService = debriefService;
    _localDBService = localDBService;
  }

  late DebriefService _debriefService;
  late LocalDBService _localDBService;

  Future<void> addDebriefNote({
    required String missionUlid,
    required String note,
  }) async {
    emit(const AddDebriefNoteState.loading());
    try {
      final debriefNote = await _debriefService.addDebriefNote(
        debriefNoteDTO: PRFDebriefNoteDTO(missionUlid: missionUlid, note: note),
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
