part of 'create_enquiry_cubit.dart';

@freezed
class CreateEnquiryState with _$CreateEnquiryState {
  const factory CreateEnquiryState.initial() = _Initial;
  const factory CreateEnquiryState.loading() = _Loading;
  const factory CreateEnquiryState.loaded() = _Loaded;
  const factory CreateEnquiryState.error(String message) = _Error;
}
