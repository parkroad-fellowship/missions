import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/models/remote/mission/prf_mission.dart';

/// Mission-related business logic utilities.
class MissionHelper {
  // Private constructor to prevent instantiation
  MissionHelper._();

  /// Check if member has subscribed to a mission
  static bool memberHasSubscribed(PRFMission mission) {
    final subscription = mission.loggedInMemberMissionSubscription;
    if (subscription == null) return false;

    return {
      PRFMissionSubscriptionStatus.approved,
      PRFMissionSubscriptionStatus.pending,
    }.contains(subscription.status);
  }

  /// Check if member can subscribe to a mission
  static bool canSubscribeToMission(PRFMission mission) {
    return mission.status == PRFMissionStatus.approved &&
        mission.missionSubscriptionsNeeded > 0 &&
        !memberHasSubscribed(mission);
  }
}
