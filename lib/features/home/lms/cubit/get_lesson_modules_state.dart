part of 'get_lesson_modules_cubit.dart';

@freezed
class GetLessonModulesState with _$GetLessonModulesState {
  const factory GetLessonModulesState.initial() = _Initial;
  const factory GetLessonModulesState.loading() = _Loading;
  const factory GetLessonModulesState.loaded() = _Loaded;
  const factory GetLessonModulesState.error(String message) = _Error;
}
