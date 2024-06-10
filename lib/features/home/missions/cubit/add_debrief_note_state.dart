part of 'add_debrief_note_cubit.dart';

@freezed
class AddDebriefNoteState with _$AddDebriefNoteState {
  const factory AddDebriefNoteState.initial() = _Initial;
  const factory AddDebriefNoteState.loading() = _Loading;
  const factory AddDebriefNoteState.loaded({
    required PRFDebriefNote debriefNote,
  }) = _Loaded;
  const factory AddDebriefNoteState.error(String message) = _Error;
}
