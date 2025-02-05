import 'dart:convert';

import 'package:app/enums/prf_mission_ground_suggestion_status.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion_dto.dart';
import 'package:app/utils/_index.dart';

abstract class MissionGroundsService {
  Future<List<PRFMissionGroundSuggestion>> getMissionGroundSuggestions({
    String? suggestorUlid,
    PRFMissionGroundSuggestionStatus? status,
    List<PRFMissionGroundSuggestionStatus>? statuses,
  });
  Future<PRFMissionGroundSuggestion> createMissionGroundSuggestion({
    required PRFMissionGroundSuggestionDTO missionGroundSuggestionDTO,
  });
  Future<PRFMissionGroundSuggestion> updateMissionGroundSuggestion({
    required PRFMissionGroundSuggestionDTO missionGroundSuggestionDTO,
    required String missionGroundSuggestionUlid,
  });
}

class MissionGroundsServiceImpl implements MissionGroundsService {
  final _networkUtil = NetworkUtil();

  @override
  Future<PRFMissionGroundSuggestion> createMissionGroundSuggestion({
    required PRFMissionGroundSuggestionDTO missionGroundSuggestionDTO,
  }) async {
    try {
      final res = await _networkUtil.postReq(
        '/mission-ground-suggestions',
        queryParameters: {
          'include': 'suggestor',
        },
        body: json.encode(missionGroundSuggestionDTO.toJson()),
      );

      return PRFMissionGroundSuggestion.fromJson(
        res['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFMissionGroundSuggestion>> getMissionGroundSuggestions({
    String? suggestorUlid,
    PRFMissionGroundSuggestionStatus? status,
    List<PRFMissionGroundSuggestionStatus>? statuses,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/mission-ground-suggestions',
        queryParameters: {
          'include': 'suggestor',
          if (suggestorUlid != null) 'filter[suggestor_ulid]': suggestorUlid,
          if (status != null) 'filter[status_key]': status.apiKey,
          if (statuses != null)
            'filter[status_keys]':
                statuses.map((status) => status.apiKey).toList().join(','),
        },
      );

      return PRFMissionGroundSuggestionResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFMissionGroundSuggestion> updateMissionGroundSuggestion({
    required PRFMissionGroundSuggestionDTO missionGroundSuggestionDTO,
    required String missionGroundSuggestionUlid,
  }) async {
    try {
      final res = await _networkUtil.putReq(
        '/mission-ground-suggestions/$missionGroundSuggestionUlid',
        queryParameters: {
          'include': 'suggestor',
        },
        body: json.encode(missionGroundSuggestionDTO.toJson()),
      );

      return PRFMissionGroundSuggestion.fromJson(
        res['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }
}
