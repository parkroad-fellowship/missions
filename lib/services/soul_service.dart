import 'package:app/models/prf_class_group.dart';
import 'package:app/models/prf_soul.dart';
import 'package:app/utils/_index.dart';

abstract class SoulService {
  Future<List<PRFClassGroup>> getClassGroups();
  Future<List<PRFSoul>> getSouls({
    required String missionUlid,
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
          'include': 'mission,classGroup',
        },
      );

      return PRFSoulResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }
}
