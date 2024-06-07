import 'package:app/utils/_index.dart';
import 'package:flutter/widgets.dart';

enum PRFMissionStatus { pending, approved, rejected, cancelled, serviced }

extension PRFMissionStatusExtension on PRFMissionStatus {
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

  static PRFMissionStatus fromIndex(int index) {
    switch (index) {
      case 1:
        return PRFMissionStatus.pending;
      case 2:
        return PRFMissionStatus.approved;
      case 3:
        return PRFMissionStatus.rejected;
      case 4:
        return PRFMissionStatus.cancelled;
      case 5:
        return PRFMissionStatus.serviced;
      default:
        return PRFMissionStatus.pending;
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
