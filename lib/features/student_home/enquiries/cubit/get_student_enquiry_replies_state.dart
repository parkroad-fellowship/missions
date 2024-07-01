part of 'get_student_enquiry_replies_cubit.dart';

@freezed
class GetStudentEnquiryRepliesState with _$GetStudentEnquiryRepliesState {
  const factory GetStudentEnquiryRepliesState.initial() = _Initial;
  const factory GetStudentEnquiryRepliesState.loading() = _Loading;
  const factory GetStudentEnquiryRepliesState.loaded() = _Loaded;
  const factory GetStudentEnquiryRepliesState.error(String message) = _Error;
}
