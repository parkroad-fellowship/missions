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
}
