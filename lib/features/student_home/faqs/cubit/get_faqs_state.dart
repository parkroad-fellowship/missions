part of 'get_faqs_cubit.dart';

@freezed
class GetFaqsState with _$GetFaqsState {
  const factory GetFaqsState.initial() = _Initial;
  const factory GetFaqsState.loading() = _Loading;
  const factory GetFaqsState.loaded({
    required List<PRFLocalFaq> faqs,
  }) = _Loaded;
  const factory GetFaqsState.error(String message) = _Error;
}
