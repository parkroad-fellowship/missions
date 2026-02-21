import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/content/prf_debrief_note_dto.dart';
import 'package:app/services/api/debrief_note_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_debrief_note_state.dart';
part 'update_debrief_note_cubit.freezed.dart';

class UpdateDebriefNoteCubit extends Cubit<UpdateDebriefNoteState> {
  UpdateDebriefNoteCubit({
    required DebriefNoteService debriefNoteService,
    required IsarService isarService,
  }) : super(const UpdateDebriefNoteState.initial()) {
    _debriefNoteService = debriefNoteService;
    _isarService = isarService;
  }

  late DebriefNoteService _debriefNoteService;
  late IsarService _isarService;

  Future<void> updateDebriefNote({
    required String debriefNoteUlid,
    required String missionUlid,
    required String note,
  }) async {
    emit(const UpdateDebriefNoteState.loading());
    try {
      final updatedNote = await _debriefNoteService.update(
        id: debriefNoteUlid,
        data: PRFDebriefNoteDTO(
          missionUlid: missionUlid,
          note: note,
        ).toJson(),
        includes: ['mission'],
      );

      await _isarService.debriefNotes.persistEntities([updatedNote]);

      emit(const UpdateDebriefNoteState.loaded());
    } on Failure catch (e) {
      emit(UpdateDebriefNoteState.error(e.message));
    } catch (e) {
      emit(UpdateDebriefNoteState.error(e.toString()));
    }
  }
}
