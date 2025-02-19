import 'dart:convert';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/models/remote/prf_event_subscription_dto.dart';
import 'package:app/models/remote/prf_media.dart';
import 'package:app/utils/network.dart';

abstract class EventService {
  Future<List<PRFEvent>> getEvents();
  Future<List<PRFEventSubscription>> getSubscriptions({
    String? eventUlid,
    String? memberUlid,
    String? includes,
    bool? past,
    bool? upcoming,
  });
  Future<PRFEventSubscription> subscribe({
    required PRFEventSubscriptionDTO subscriptionDTO,
  });
  Future<PRFEventSubscription> updateSubscription({
    required String eventSubscriptionUlid,
    required PRFEventSubscriptionDTO subscriptionDTO,
  });
  Future<bool> unsubscribe({required String eventSubscriptionUlid});
   Future<List<PRFMedia>> getEventMedia({
    required String eventUlid,
    required PRFMediaModel model,
  });
}

class EventServiceImpl implements EventService {
  final _networkUtil = NetworkUtil();

  @override
  Future<List<PRFEvent>> getEvents() async {
    try {
      final res = await _networkUtil.getReq(
        '/events',
        queryParameters: {
          'include': 'weatherForecasts,eventSubscriptions,loggedInMemberEventSubscription,posters',
          'order_by': 'start_date',
          'order_direction': 'asc',
        },
      );

      return PRFEventResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFEventSubscription>> getSubscriptions({
    String? eventUlid,
    String? memberUlid,
    String? includes,
    bool? past,
    bool? upcoming,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/event-subscriptions',
        queryParameters: {
          if (memberUlid != null) 'filter[member_ulid]': memberUlid,
          if (eventUlid != null) 'filter[event_ulid]': eventUlid,
          if (includes != null) 'include': includes,
          if (past != null) 'filter[past]': true,
          if (upcoming != null) 'filter[upcoming]': true,
        },
      );

      return PRFEventSubscriptionResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFEventSubscription> subscribe({
    required PRFEventSubscriptionDTO subscriptionDTO,
  }) async {
    try {
      final res = await _networkUtil.postReq(
        '/event-subscriptions',
        body: json.encode(subscriptionDTO.toJson()),
        queryParameters: {},
      );

      return PRFEventSubscription.fromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> unsubscribe({required String eventSubscriptionUlid}) async {
    try {
      await _networkUtil.deleteReq(
        '/event-subscriptions/$eventSubscriptionUlid',
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFEventSubscription> updateSubscription({
    required String eventSubscriptionUlid,
    required PRFEventSubscriptionDTO subscriptionDTO,
  }) async {
    try {
      final res = await _networkUtil.putReq(
        '/event-subscriptions/$eventSubscriptionUlid',
        body: json.encode(subscriptionDTO.toJson()),
        queryParameters: {},
      );

      return PRFEventSubscription.fromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFMedia>> getEventMedia({
    required String eventUlid,
    required PRFMediaModel model,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/events/$eventUlid/media',
        queryParameters: {'collection': model.collection},
      );

      return PRFMediaResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }
}
