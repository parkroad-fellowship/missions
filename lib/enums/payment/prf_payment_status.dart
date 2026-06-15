import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFPaymentStatus {
  @JsonValue(1)
  pending(1, 'Pending'),
  @JsonValue(2)
  initialised(2, 'Initialised'),
  @JsonValue(3)
  success(3, 'Success'),
  @JsonValue(4)
  cancelled(4, 'Cancelled'),
  @JsonValue(5)
  failed(5, 'Failed')
  ;

  const PRFPaymentStatus(this.apiKey, this.name);

  final int apiKey;
  final String name;
}
