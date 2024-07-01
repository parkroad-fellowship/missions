part of 'get_student_enquiries_cubit.dart';

@freezed
class GetStudentEnquiriesState with _$GetStudentEnquiriesState {
  const factory GetStudentEnquiriesState.initial() = _Initial;
  const factory GetStudentEnquiriesState.loading() = _Loading;
  const factory GetStudentEnquiriesState.loaded({
    required List<PRFStudentEnquiry> enquiries,
  }) = _Loaded;
  const factory GetStudentEnquiriesState.error(String message) = _Error;
}
