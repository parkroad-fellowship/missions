import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/debrief_note_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_debrief_note_cubit.freezed.dart';
part 'delete_debrief_note_state.dart';

class DeleteDebriefNoteCubit extends Cubit<DeleteDebriefNoteState> {
  DeleteDebriefNoteCubit({
    required DebriefNoteService debriefNoteService,
    required IsarService isarService,
  }) : super(const DeleteDebriefNoteState.initial()) {
    _debriefNoteService = debriefNoteService;
    _isarService = isarService;
  }

  late DebriefNoteService _debriefNoteService;
  late IsarService _isarService;

  Future<void> deleteDebriefNote({
    required String debriefNoteUlid,
  }) async {
    emit(const DeleteDebriefNoteState.loading());
    try {
      await _debriefNoteService.delete(ulid: debriefNoteUlid);
      await _isarService.debriefNotes.deleteByKey(debriefNoteUlid);
      emit(const DeleteDebriefNoteState.loaded());
    } on Failure catch (e) {
      emit(DeleteDebriefNoteState.error(e.message));
    } catch (e) {
      emit(DeleteDebriefNoteState.error(e.toString()));
    }
  }
}
