part of 'update_debrief_note_cubit.dart';

@freezed
class UpdateDebriefNoteState with _$UpdateDebriefNoteState {
  const factory UpdateDebriefNoteState.initial() = _Initial;
  const factory UpdateDebriefNoteState.loading() = _Loading;
  const factory UpdateDebriefNoteState.loaded() = _Loaded;
  const factory UpdateDebriefNoteState.error(String message) = _Error;
}
