part of 'get_courses_cubit.dart';

@freezed
class GetCoursesState with _$GetCoursesState {
  const factory GetCoursesState.initial() = _Initial;
  const factory GetCoursesState.loading() = _Loading;
  const factory GetCoursesState.loaded() = _Loaded;
  const factory GetCoursesState.error(String message) = _Error;
}
