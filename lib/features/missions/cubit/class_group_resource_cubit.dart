import 'package:app/enums/member/prf_institution_type.dart';
import 'package:app/enums/prf_active_status.dart';
import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/services/api/class_group_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class ClassGroupResourceCubit extends ResourceCubit<PRFClassGroup> {
  ClassGroupResourceCubit({
    required ClassGroupService classGroupService,
    required HiveService hiveService,
  }) : super(service: classGroupService, dbService: hiveService.classGroups);

  Future<void> loadActiveForInstitutionType(
    PRFInstitutionType institutionType,
  ) {
    return loadAll(
      filters: {
        'status_key': PRFActiveStatus.active.apiKey,
        'institution_type': institutionType.value,
      },
      sortBy: 'name',
      limit: 500,
    );
  }

  @override
  Future<List<PRFClassGroup>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    return dbService.list();
  }
}
