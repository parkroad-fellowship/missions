import 'dart:convert';

import 'package:app/enums/prf_mission_status.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/models/remote/prf_mission_subscription_dto.dart';
import 'package:app/models/remote/prf_mission_subscription_update_dto.dart';
import 'package:app/utils/_index.dart';

abstract class MissionService {
  Future<List<PRFMission>> getMissions();
  Future<List<PRFMissionSubscription>> getSubscriptions({
    String? missionUlid,
    String? memberUlid,
    String? includes,
    bool? past,
    bool? upcoming,
    PRFMissionSubscriptionStatus? subscriptionStatus,
  });
  Future<PRFMissionSubscription> subscribe({
    required PRFMissionSubscriptionDTO subscriptionDTO,
  });
  Future<PRFMissionSubscription> updateSubscription({
    required String missionSubscriptionUlid,
    required PRFMissionSubscriptionUpdateDTO subscriptionDTO,
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
          'include': 'school,missionType,school.schoolContacts.contactType,'
              'loggedInMemberMissionSubscription',
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
    bool? past,
    bool? upcoming,
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
          if (past != null) 'filter[past]': true,
          if (upcoming != null) 'filter[upcoming]': true,
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

      return PRFMissionSubscription.fromJson(
        res['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFMissionSubscription> updateSubscription({
    required String missionSubscriptionUlid,
    required PRFMissionSubscriptionUpdateDTO subscriptionDTO,
  }) async {
    try {
      final res = await _networkUtil.putReq(
        '/mission-subscriptions/$missionSubscriptionUlid',
        body: json.encode(subscriptionDTO.toJson()),
        queryParameters: {},
      );

      return PRFMissionSubscription.fromJson(
        res['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }
}
