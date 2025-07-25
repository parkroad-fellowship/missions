part of 'get_student_enquiry_cubit.dart';

@freezed
class GetStudentEnquiryState with _$GetStudentEnquiryState {
  const factory GetStudentEnquiryState.initial() = _Initial;
  const factory GetStudentEnquiryState.loading() = _Loading;
  const factory GetStudentEnquiryState.loaded() = _Loaded;
  const factory GetStudentEnquiryState.error(String message) = _Error;
}
