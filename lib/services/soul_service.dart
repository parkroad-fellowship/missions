import 'dart:convert';

import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:app/models/remote/prf_soul_dto.dart';
import 'package:app/utils/_index.dart';

abstract class SoulService {
  Future<List<PRFClassGroup>> getClassGroups();
  Future<List<PRFSoul>> getSouls({
    required String missionUlid,
  });
  Future<PRFSoul> addSoul({
    required PRFSoulDTO soulDTO,
  });
}

class SoulServiceImpl implements SoulService {
  final _networkUtil = NetworkUtil();
  @override
  Future<List<PRFClassGroup>> getClassGroups() async {
    try {
      final res = await _networkUtil.getReq(
        '/class-groups',
      );

      return PRFClassGroupResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFSoul>> getSouls({
    required String missionUlid,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/souls',
        queryParameters: {
          'filter[mission_ulid]': missionUlid,
          'include': 'classGroup',
        },
      );

      return PRFSoulResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFSoul> addSoul({required PRFSoulDTO soulDTO}) async {
    try {
      final res = await _networkUtil.postReq(
        '/souls',
        body: json.encode(soulDTO.toJson()),
        queryParameters: {
          'include': 'classGroup',
        },
      );

      return PRFSoul.fromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
