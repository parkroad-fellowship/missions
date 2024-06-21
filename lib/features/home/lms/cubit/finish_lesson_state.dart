part of 'finish_lesson_cubit.dart';

@freezed
class FinishLessonState with _$FinishLessonState {
  const factory FinishLessonState.initial() = _Initial;
  const factory FinishLessonState.loading() = _Loading;
  const factory FinishLessonState.loaded() = _Loaded;
  const factory FinishLessonState.error(String message) = _Error;
}
