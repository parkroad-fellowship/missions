part of 'delete_debrief_note_cubit.dart';

@freezed
class DeleteDebriefNoteState with _$DeleteDebriefNoteState {
  const factory DeleteDebriefNoteState.initial() = _Initial;
  const factory DeleteDebriefNoteState.loading() = _Loading;
  const factory DeleteDebriefNoteState.loaded() = _Loaded;
  const factory DeleteDebriefNoteState.error(String message) = _Error;
}
