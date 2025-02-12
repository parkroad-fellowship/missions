part of 'get_faq_categories_cubit.dart';

@freezed
class GetFaqCategoriesState with _$GetFaqCategoriesState {
  const factory GetFaqCategoriesState.initial() = _Initial;
  const factory GetFaqCategoriesState.loading() = _Loading;
  const factory GetFaqCategoriesState.loaded({
    required List<PRFLocalFaqCategory> faqCategories,
  }) = _Loaded;
  const factory GetFaqCategoriesState.error(String message) = _Error;
}
