import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFMissionSubscriptionStatus {
  @JsonValue(1)
  pending,
  @JsonValue(2)
  approved,
  @JsonValue(3)
  withdrawn;

  String get name {
    switch (this) {
      case PRFMissionSubscriptionStatus.pending:
        return 'Pending';
      case PRFMissionSubscriptionStatus.approved:
        return 'Approved';
      case PRFMissionSubscriptionStatus.withdrawn:
        return 'Withdrawn';
    }
  }
}
