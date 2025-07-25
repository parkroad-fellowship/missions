import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/models/remote/prf_debrief_note_dto.dart';
import 'package:app/services/api/debrief_note_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_debrief_note_state.dart';
part 'add_debrief_note_cubit.freezed.dart';

class AddDebriefNoteCubit extends Cubit<AddDebriefNoteState> {
  AddDebriefNoteCubit({
    required DebriefNoteService debriefNoteService,
    required IsarService isarService,
  }) : super(const AddDebriefNoteState.initial()) {
    _debriefNoteService = debriefNoteService;
    _isarService = isarService;
  }

  late DebriefNoteService _debriefNoteService;
  late IsarService _isarService;

  Future<void> addDebriefNote({
    required String missionUlid,
    required String note,
  }) async {
    emit(const AddDebriefNoteState.loading());
    try {
      final debriefNote = await _debriefNoteService.create(
        data: PRFDebriefNoteDTO(missionUlid: missionUlid, note: note).toJson(),
        includes: const ['mission'],
      );

      await _isarService.debriefNotes.persistEntity(debriefNote);

      emit(AddDebriefNoteState.loaded(debriefNote: debriefNote));
    } on Failure catch (e) {
      emit(AddDebriefNoteState.error(e.message));
    } catch (e) {
      emit(AddDebriefNoteState.error(e.toString()));
    }
  }
}
