import 'dart:convert';

import 'package:app/enums/prf_mission_status.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/prf_mission.dart';
import 'package:app/models/prf_mission_subscription.dart';
import 'package:app/models/prf_mission_subscription_dto.dart';
import 'package:app/utils/_index.dart';

abstract class MissionService {
  Future<List<PRFMission>> getMissions();
  Future<List<PRFMissionSubscription>> getSubscriptions({
    String? missionUlid,
    String? memberUlid,
    String? includes,
    PRFMissionSubscriptionStatus? subscriptionStatus,
  });
  Future<PRFMissionSubscription> subscribe({
    required PRFMissionSubscriptionDTO subscriptionDTO,
  });
}

class MissionServiceImpl implements MissionService {
  final _networkUtil = NetworkUtil();

  @override
  Future<List<PRFMission>> getMissions() async {
    try {
      final res = await _networkUtil.getReq(
        '/missions',
        queryParameters: {
          'include': 'school,missionType',
          'filter[status_key]': PRFMissionStatus.approved.apiKey,
          'order_by': 'start_date',
          'order_direction': 'asc',
        },
      );

      return PRFMissionsResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFMissionSubscription>> getSubscriptions({
    String? missionUlid,
    String? memberUlid,
    String? includes,
    PRFMissionSubscriptionStatus? subscriptionStatus,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/mission-subscriptions',
        queryParameters: {
          if (memberUlid != null) 'filter[member_ulid]': memberUlid,
          if (missionUlid != null) 'filter[mission_ulid]': missionUlid,
          if (includes != null) 'include': includes,
          if (subscriptionStatus != null)
            'filter[status_key]': subscriptionStatus.apiKey,
        },
      );

      return PRFMissionSubscriptionsResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFMissionSubscription> subscribe({
    required PRFMissionSubscriptionDTO subscriptionDTO,
  }) async {
    try {
      final res = await _networkUtil.postReq(
        '/mission-subscriptions',
        body: json.encode(subscriptionDTO.toJson()),
        queryParameters: {},
      );

      return PRFMissionSubscription.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }
}
