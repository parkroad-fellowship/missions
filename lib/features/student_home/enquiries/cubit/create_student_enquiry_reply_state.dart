part of 'create_student_enquiry_reply_cubit.dart';

@freezed
class CreateStudentEnquiryReplyState with _$CreateStudentEnquiryReplyState {
  const factory CreateStudentEnquiryReplyState.initial() = _Initial;
  const factory CreateStudentEnquiryReplyState.loading() = _Loading;
  const factory CreateStudentEnquiryReplyState.loaded() = _Loaded;
  const factory CreateStudentEnquiryReplyState.error(String message) = _Error;
}
