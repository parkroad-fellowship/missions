import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_prayer_request_dto.freezed.dart';
part 'prf_prayer_request_dto.g.dart';

@freezed
abstract class PRFPrayerRequestDTO with _$PRFPrayerRequestDTO {
  factory PRFPrayerRequestDTO({
    @JsonKey(name: 'member_ulid') required String memberUlid,
    required String title,
    required String description,
  }) = _PRFPrayerRequestDTO;

  factory PRFPrayerRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFPrayerRequestDTOFromJson(json);
}
