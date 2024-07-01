part of 'create_student_enquiry_reply_cubit.dart';

@freezed
class CreateEnquiryReplyState with _$CreateEnquiryReplyState {
  const factory CreateEnquiryReplyState.initial() = _Initial;
  const factory CreateEnquiryReplyState.loading() = _Loading;
  const factory CreateEnquiryReplyState.loaded() = _Loaded;
  const factory CreateEnquiryReplyState.error(String message) = _Error;
}
