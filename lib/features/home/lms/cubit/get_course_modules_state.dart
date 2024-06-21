part of 'get_course_modules_cubit.dart';

@freezed
class GetCourseModulesState with _$GetCourseModulesState {
  const factory GetCourseModulesState.initial() = _Initial;
  const factory GetCourseModulesState.loading() = _Loading;
  const factory GetCourseModulesState.loaded({
    required List<PRFCourseModule> courseModules,
  }) = _Loaded;
  const factory GetCourseModulesState.error(String message) = _Error;
}
