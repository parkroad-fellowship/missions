import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_faq_category.freezed.dart';
part 'prf_faq_category.g.dart';

@freezed
class PRFFaqCategory with _$PRFFaqCategory {
  factory PRFFaqCategory(
    String ulid,
    String name,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  ) = _PRFFaqCategory;

  factory PRFFaqCategory.fromJson(Map<String, dynamic> json) =>
      _$PRFFaqCategoryFromJson(json);
}

@freezed
class PRFFaqCategoryResponse with _$PRFFaqCategoryResponse {
  const factory PRFFaqCategoryResponse({
    required List<PRFFaqCategory> data,
  }) = _PRFFaqCategoryResponse;

  factory PRFFaqCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFFaqCategoryResponseFromJson(json);
}
