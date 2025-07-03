import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_payment_dto.freezed.dart';
part 'prf_payment_dto.g.dart';

@freezed
abstract class PRFPaymentDTO with _$PRFPaymentDTO {
  factory PRFPaymentDTO({
    @JsonKey(name: 'payment_type_ulid') required String paymentTypeUlid,
    @JsonKey(name: 'member_ulid') required String memberUlid,
    required int amount,
  }) = _PRFPaymentDTO;

  factory PRFPaymentDTO.fromJson(Map<String, dynamic> json) =>
      _$PRFPaymentDTOFromJson(json);
}
