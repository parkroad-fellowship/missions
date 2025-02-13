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
        return PRFApp.theme().kPrimaryColorV2;
      case PRFMissionStatus.serviced:
        return PRFApp.theme().kGreenColor;
      case PRFMissionStatus.pending:
        return PRFApp.theme().kYellowColor;
      case PRFMissionStatus.rejected:
      case PRFMissionStatus.cancelled:
        return PRFApp.theme().kRedColor;
    }
  }

  int get apiKey {
    switch (this) {
      case PRFMissionStatus.pending:
        return 1;
      case PRFMissionStatus.approved:
        return 2;
      case PRFMissionStatus.rejected:
        return 3;
      case PRFMissionStatus.cancelled:
        return 4;
      case PRFMissionStatus.serviced:
        return 5;
    }
  }
}
