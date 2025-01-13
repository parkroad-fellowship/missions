import 'package:app/enums/prf_media_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_image_dto.freezed.dart';
part 'prf_image_dto.g.dart';

@freezed
class PRFImageDTO with _$PRFImageDTO {
  const factory PRFImageDTO({
    required PRFMediaModel model,
    required String modelUlid,
    required String path,
  }) = _PRFImageDTO;

  factory PRFImageDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFImageDTOFromJson(json);
}
