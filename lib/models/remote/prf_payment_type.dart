import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_payment_type.freezed.dart';
part 'prf_payment_type.g.dart';

@freezed
class PRFPaymentType with _$PRFPaymentType {
  factory PRFPaymentType(
    String ulid,
    String name,
    String description,
  ) = _PRFPaymentType;

  factory PRFPaymentType.fromJson(Map<String, dynamic> json) =>
      _$PRFPaymentTypeFromJson(json);
}

@freezed
class PRFPaymentTypeResponse with _$PRFPaymentTypeResponse {
  factory PRFPaymentTypeResponse(
    List<PRFPaymentType> data,
  ) = _PRFPaymentTypeResponse;

  factory PRFPaymentTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFPaymentTypeResponseFromJson(json);
}
