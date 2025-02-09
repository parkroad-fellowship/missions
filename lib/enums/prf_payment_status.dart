import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFPaymentStatus {
  @JsonValue(1)
  pending,
  @JsonValue(2)
  success,
  @JsonValue(3)
  cancelled,
  @JsonValue(4)
  failed;

  String get name {
    switch (this) {
      case PRFPaymentStatus.pending:
        return 'Pending';
      case PRFPaymentStatus.success:
        return 'Success';
      case PRFPaymentStatus.cancelled:
        return 'Cancelled';
      case PRFPaymentStatus.failed:
        return 'Failied';
    }
  }
}
