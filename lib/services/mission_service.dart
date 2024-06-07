import 'dart:convert';

import 'package:app/models/prf_mission.dart';
import 'package:app/models/prf_mission_subscription.dart';
import 'package:app/models/prf_mission_subscription_dto.dart';
import 'package:app/utils/_index.dart';

abstract class MissionService {
  Future<List<PRFMission>> getMissions();
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
        queryParameters: {},
      );

      return PRFMissionsResponse.fromJson(res).data;
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
