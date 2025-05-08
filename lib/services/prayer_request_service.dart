import 'dart:convert';

import 'package:app/models/remote/prf_prayer_request.dart' as request;
import 'package:app/models/remote/prf_prayer_request_dto.dart';
import 'package:app/models/remote/prf_prayer_request_response.dart' as response;
import 'package:app/utils/_index.dart';

abstract class PrayerRequestService {
  Future<List<request.PRFPrayerRequest>> getPrayerRequests({
    required String memberUlid,
  });
  Future<request.PRFPrayerRequest> addPrayerRequest({
    required PRFPrayerRequestDTO dto,
  });
}

class PrayerRequestServiceImpl implements PrayerRequestService {
  final _networkUtil = NetworkUtil();

  @override
  Future<List<request.PRFPrayerRequest>> getPrayerRequests({
    required String memberUlid,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/prayer-requests',
        queryParameters: {
          'include': 'member',
          'filter[member_ulid]': memberUlid,
        },
      );

      return response.PRFPrayerRequestResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<request.PRFPrayerRequest> addPrayerRequest({
    required PRFPrayerRequestDTO dto,
  }) async {
    try {
      final res = await _networkUtil.postReq(
        '/prayer-requests',
        body: json.encode(dto.toJson()),
        queryParameters: {'include': 'member'},
      );

      return request.PRFPrayerRequest.fromJson(
        res['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }
}
