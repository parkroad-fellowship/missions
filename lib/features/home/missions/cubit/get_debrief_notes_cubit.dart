import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/debrief_note_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_debrief_notes_state.dart';
part 'get_debrief_notes_cubit.freezed.dart';

class GetDebriefNotesCubit extends Cubit<GetDebriefNotesState> {
  GetDebriefNotesCubit({
    required DebriefNoteService debriefNoteService,
    required LocalDBService localDBService,
  }) : super(const GetDebriefNotesState.initial()) {
    _debriefNoteService = debriefNoteService;
    _localDBService = localDBService;
  }

  late DebriefNoteService _debriefNoteService;
  late LocalDBService _localDBService;

  Future<void> getDebriefNotes({
    required String missionUlid,
    bool refresh = false,
  }) async {
    emit(const GetDebriefNotesState.loading());
    try {
      if (!refresh) {
        emit(const GetDebriefNotesState.loaded());
        return;
      }
      final debriefNotes = await _debriefNoteService.list(
        filters: {'filter[mission_ulid]': missionUlid}
      );
      await _localDBService.persistDebriefNotes(
        debriefNotes: debriefNotes,
        missionUlid: missionUlid,
      );
      emit(const GetDebriefNotesState.loaded());
    } on Failure catch (e) {
      emit(GetDebriefNotesState.error(e.message));
    } catch (e) {
      emit(GetDebriefNotesState.error(e.toString()));
    }
  }
}
