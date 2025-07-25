part of 'get_lesson_cubit.dart';

@freezed
class GetLessonState with _$GetLessonState {
  const factory GetLessonState.initial() = _Initial;
  const factory GetLessonState.loading() = _Loading;
  const factory GetLessonState.loaded() = _Loaded;
  const factory GetLessonState.error(String message) = _Error;
}
