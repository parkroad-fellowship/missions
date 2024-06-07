enum PRFMissionSubscriptionStatus { pending, approved, withdrawn }

extension PRFMissionSubscriptionStatusExtension
    on PRFMissionSubscriptionStatus {
  int get apiKey {
    switch (this) {
      case PRFMissionSubscriptionStatus.pending:
        return 1;
      case PRFMissionSubscriptionStatus.approved:
        return 2;
      case PRFMissionSubscriptionStatus.withdrawn:
        return 3;
    }
  }

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

  static PRFMissionSubscriptionStatus fromIndex(int index) {
    switch (index) {
      case 1:
        return PRFMissionSubscriptionStatus.pending;
      case 2:
        return PRFMissionSubscriptionStatus.approved;
      case 3:
        return PRFMissionSubscriptionStatus.withdrawn;
      default:
        return PRFMissionSubscriptionStatus.pending;
    }
  }
}
