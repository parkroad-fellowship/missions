import 'package:app/utils/_index.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFMissionStatus {
  @JsonValue(1)
  pending,
  @JsonValue(2)
  approved,
  @JsonValue(3)
  rejected,
  @JsonValue(4)
  cancelled,
  @JsonValue(5)
  serviced;

  String get name {
    switch (this) {
      case PRFMissionStatus.pending:
        return 'Pending';
      case PRFMissionStatus.approved:
        return 'Approved';
      case PRFMissionStatus.rejected:
        return 'Rejected';
      case PRFMissionStatus.cancelled:
        return 'Cancelled';
      case PRFMissionStatus.serviced:
        return 'Serviced';
    }
  }


  static Color switchColor(PRFMissionStatus status) {
    switch (status) {
      case PRFMissionStatus.approved:
        return AppTheme.appTheme().kPrimaryColorV2;
      case PRFMissionStatus.serviced:
        return AppTheme.appTheme().kGreenColor;
      case PRFMissionStatus.pending:
        return AppTheme.appTheme().kYellowColor;
      case PRFMissionStatus.rejected:
      case PRFMissionStatus.cancelled:
        return AppTheme.appTheme().kRedColor;
    }
  }
}
