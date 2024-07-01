import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_faq.freezed.dart';
part 'prf_faq.g.dart';

@freezed
class PRFFaq with _$PRFFaq {
  factory PRFFaq(
    String ulid,
    String question,
    String answer,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  ) = _PRFFaq;

  factory PRFFaq.fromJson(Map<String, dynamic> json) => _$PRFFaqFromJson(json);
}

@freezed
class PRFFaqResponse with _$PRFFaqResponse {
  const factory PRFFaqResponse({
    required List<PRFFaq> data,
  }) = _PRFFaqResponse;

  factory PRFFaqResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFFaqResponseFromJson(json);
}
