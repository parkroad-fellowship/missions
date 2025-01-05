import 'dart:convert';

import 'package:app/enums/prf_mission_status.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/remote/prf_announcement.dart';
import 'package:app/models/remote/prf_expense.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/models/remote/prf_expense_dto.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/models/remote/prf_mission_expense.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/models/remote/prf_mission_subscription_dto.dart';
import 'package:app/models/remote/prf_mission_subscription_update_dto.dart';
import 'package:app/models/remote/prf_prayer_prompt.dart';
import 'package:app/models/remote/prf_prayer_response.dart';
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
  Future<List<PRFAnnouncement>> getAnnouncements({
    List<String> groups = const <String>[],
    String? includes,
    bool? past,
    bool? upcoming,
  });
  Future<List<PRFPrayerPrompt>> getPrayerPrompts();
  Future<PRFPrayerResponse> respondToPrayerPrompt({
    required PRFPrayerResponseDTO prayerResponse,
  });
  Future<List<PRFExpenseCategory>> getExpenseCategories();
  Future<PRFMissionExpense> getMissionExpense({required String missionUlid});
  Future<PRFExpense> addExpense({required PRFExpenseDTO expenseDTO});
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

  @override
  Future<List<PRFAnnouncement>> getAnnouncements({
    List<String> groups = const <String>[],
    String? includes,
    bool? past,
    bool? upcoming,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/announcements',
        queryParameters: {
          if (includes != null) 'include': includes,
          'filter[group_ulids]': groups.join(','),
          if (past != null) 'filter[past]': true,
          if (upcoming != null) 'filter[upcoming]': true,
          'order_by': 'published_at',
          'order_direction': 'desc',
        },
      );

      return PRFAnnouncementResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFPrayerPrompt>> getPrayerPrompts() async {
    try {
      final res = await _networkUtil.getReq(
        '/prayer-prompts',
        queryParameters: {
          'limit': 100,
          'filter[is_active]': 2,
        },
      );

      return PRFPrayerPromptResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFPrayerResponse> respondToPrayerPrompt({
    required PRFPrayerResponseDTO prayerResponse,
  }) async {
    try {
      final res = await _networkUtil.postReq(
        '/prayer-responses',
        queryParameters: {
          'include': 'prayerPrompt',
        },
        body: json.encode(prayerResponse.toJson()),
      );

      return PRFPrayerResponse.fromJson(
        res['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFExpenseCategory>> getExpenseCategories() async {
    try {
      final res = await _networkUtil.getReq(
        '/expense-categories',
        queryParameters: {
          'limit': 100,
        },
      );

      return PRFExpenseCategoryResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFMissionExpense> getMissionExpense({
    required String missionUlid,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/mission-expenses/$missionUlid',
        queryParameters: {
          'include': 'expenses.expenseCategory',
        },
      );

      return PRFMissionExpense.fromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFExpense> addExpense({required PRFExpenseDTO expenseDTO}) async {
    try {
      final res = await _networkUtil.postReq('/expenses',
          body: json.encode(expenseDTO.toJson()));

      return PRFExpense.fromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  
}
