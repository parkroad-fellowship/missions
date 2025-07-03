import 'package:app/enums/prf_payment_status.dart';
import 'package:app/models/remote/prf_payment_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_payment.freezed.dart';
part 'prf_payment.g.dart';

@freezed
abstract class PRFPayment with _$PRFPayment {
  factory PRFPayment(
    String ulid,
    int amount,
    @JsonKey(name: 'payment_status') PRFPaymentStatus paymentStatus,

    @JsonKey(name: 'created_at') DateTime createdAt, {
    @JsonKey(name: 'authorization_url') String? authorizationUrl,
    String? reference,
    @JsonKey(name: 'payment_type') PRFPaymentType? paymentType,
  }) = _PRFPayment;

  factory PRFPayment.fromJson(Map<String, dynamic> json) =>
      _$PRFPaymentFromJson(json);
}

@freezed
abstract class PRFPaymentResponse with _$PRFPaymentResponse {
  factory PRFPaymentResponse(List<PRFPayment> data) = _PRFPaymentResponse;

  factory PRFPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFPaymentResponseFromJson(json);
}
