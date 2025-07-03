import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/services/local_storage/hive/_base_hive_service.dart';
import 'package:app/utils/_index.dart';

class ClassGroupHiveService extends BaseHiveService {
  @override
  String get boxName => PRFSuperAppConfig.instance!.values.hiveBox;

  void persistClassGroups(PRFClassGroupResponse classGroups) {
    put('classGroups', classGroups);
  }

  List<PRFClassGroup> retrieveClassGroups() {
    final classGroups = get<PRFClassGroupResponse>('classGroups');
    if (classGroups == null) return [];
    return classGroups.data;
  }

  void clearClassGroups() {
    delete('classGroups');
  }
}
