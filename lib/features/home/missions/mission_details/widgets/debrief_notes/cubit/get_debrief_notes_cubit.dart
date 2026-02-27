import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/debrief_note_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_debrief_notes_state.dart';
part 'get_debrief_notes_cubit.freezed.dart';

class GetDebriefNotesCubit extends Cubit<GetDebriefNotesState> {
  GetDebriefNotesCubit({
    required DebriefNoteService debriefNoteService,
    required IsarService isarService,
  }) : super(const GetDebriefNotesState.initial()) {
    _debriefNoteService = debriefNoteService;
    _isarService = isarService;
  }

  late DebriefNoteService _debriefNoteService;
  late IsarService _isarService;

  Future<void> getDebriefNotes({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetDebriefNotesState.loading());
    try {
      if (!refresh) {
        await _isarService.debriefNotes.refreshParentStream(missionUlid);
        emit(const GetDebriefNotesState.loaded());
        return;
      }
      final debriefNotes = await _debriefNoteService.list(
        filters: {'mission_ulid': missionUlid},
        includes: const ['mission'],
      );

      await _isarService.debriefNotes.persistEntities(
        debriefNotes,
      );
      await _isarService.debriefNotes.refreshParentStream(missionUlid);

      emit(const GetDebriefNotesState.loaded());
    } on Failure catch (e) {
      emit(GetDebriefNotesState.error(e.message));
    } catch (e) {
      emit(GetDebriefNotesState.error(e.toString()));
    }
  }
}
