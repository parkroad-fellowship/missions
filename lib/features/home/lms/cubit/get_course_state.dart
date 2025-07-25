part of 'get_course_cubit.dart';

@freezed
class GetCourseState with _$GetCourseState {
  const factory GetCourseState.initial() = _Initial;
  const factory GetCourseState.loading() = _Loading;
  const factory GetCourseState.loaded() = _Loaded;
  const factory GetCourseState.error(String message) = _Error;
}
