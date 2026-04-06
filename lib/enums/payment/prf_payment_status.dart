import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFPaymentStatus {
  @JsonValue(1)
  pending,
  @JsonValue(2)
  initialised,
  @JsonValue(3)
  success,
  @JsonValue(4)
  cancelled,
  @JsonValue(5)
  failed
  ;

  String get name {
    switch (this) {
      case PRFPaymentStatus.pending:
        return 'Pending';
      case PRFPaymentStatus.initialised:
        return 'Initialised';
      case PRFPaymentStatus.success:
        return 'Success';
      case PRFPaymentStatus.cancelled:
        return 'Cancelled';
      case PRFPaymentStatus.failed:
        return 'Failed';
    }
  }
}
