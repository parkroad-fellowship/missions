import 'package:app/models/remote/prf_soul.dart';
import 'package:app/services/local_storage/hive/_base_hive_service.dart';
import 'package:app/utils/_index.dart';

class SoulHiveService extends BaseHiveService {
  @override
  String get boxName => PRFSuperAppConfig.instance!.values.hiveBox;

  void persistSouls(PRFSoulResponse souls, String missionUlid) {
    putCollection('souls', missionUlid, souls);
  }

  void persistSoul(PRFSoul soul, String missionUlid) {
    final souls = getCollection<PRFSoulResponse>('souls', missionUlid);
    if (souls == null) return;

    final modified = List<PRFSoul>.from(souls.data)..add(soul);
    putCollection('souls', missionUlid, PRFSoulResponse(data: modified));
  }

  List<PRFSoul> retrieveSouls(String missionUlid) {
    final souls = getCollection<PRFSoulResponse>('souls', missionUlid);
    if (souls == null) return [];
    return souls.data.reversed.toList();
  }

  void clearSouls(String missionUlid) {
    deleteCollection('souls', missionUlid);
  }

  void clearAllSouls() {
    // Clear all soul-related data
    final keys = box.keys.where((key) => key.toString().startsWith('souls-'));
    deleteAll(keys.map((key) => key.toString()).toList());
  }
}
