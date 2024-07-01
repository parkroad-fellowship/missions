part of 'register_student_cubit.dart';

@freezed
class RegisterStudentState with _$RegisterStudentState {
  const factory RegisterStudentState.initial() = _Initial;
  const factory RegisterStudentState.loading() = _Loading;
  const factory RegisterStudentState.loaded({
    required PRFUser user,
  }) = _Loaded;
  const factory RegisterStudentState.error(String message) = _Error;
}
