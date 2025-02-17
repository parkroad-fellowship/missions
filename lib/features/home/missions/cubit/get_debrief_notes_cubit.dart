import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_debrief_note.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_debrief_notes_state.dart';
part 'get_debrief_notes_cubit.freezed.dart';

class GetDebriefNotesCubit extends Cubit<GetDebriefNotesState> {
  GetDebriefNotesCubit({required DebriefService debriefService})
    : super(const GetDebriefNotesState.initial()) {
    _debriefService = debriefService;
  }

  late DebriefService _debriefService;

  Future<void> getDebriefNotes({required String missionUlid}) async {
    emit(const GetDebriefNotesState.loading());
    try {
      final debriefNotes = await _debriefService.getDebriefNotes(
        missionUlid: missionUlid,
      );
      emit(GetDebriefNotesState.loaded(debriefNotes: debriefNotes));
    } on Failure catch (e) {
      emit(GetDebriefNotesState.error(e.message));
    } catch (e) {
      emit(GetDebriefNotesState.error(e.toString()));
    }
  }
}
