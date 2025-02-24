import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_debrief_notes_state.dart';
part 'get_debrief_notes_cubit.freezed.dart';

class GetDebriefNotesCubit extends Cubit<GetDebriefNotesState> {
  GetDebriefNotesCubit({
    required DebriefService debriefService,
    required LocalDBService localDBService,
  }) : super(const GetDebriefNotesState.initial()) {
    _debriefService = debriefService;
    _localDBService = localDBService;
  }

  late DebriefService _debriefService;
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
      final debriefNotes = await _debriefService.getDebriefNotes(
        missionUlid: missionUlid,
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
