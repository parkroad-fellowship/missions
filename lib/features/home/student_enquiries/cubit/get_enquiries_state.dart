part of 'get_enquiries_cubit.dart';

@freezed
class GetEnquiriesState with _$GetEnquiriesState {
  const factory GetEnquiriesState.initial() = _Initial;
  const factory GetEnquiriesState.loading() = _Loading;
  const factory GetEnquiriesState.loaded() = _Loaded;
  const factory GetEnquiriesState.error(String message) = _Error;
}
