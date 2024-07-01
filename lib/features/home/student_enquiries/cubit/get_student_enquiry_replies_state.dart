part of 'get_student_enquiry_replies_cubit.dart';

@freezed
class GetEnquiryRepliesState with _$GetEnquiryRepliesState {
  const factory GetEnquiryRepliesState.initial() = _Initial;
  const factory GetEnquiryRepliesState.loading() = _Loading;
  const factory GetEnquiryRepliesState.loaded() = _Loaded;
  const factory GetEnquiryRepliesState.error(String message) = _Error;
}
