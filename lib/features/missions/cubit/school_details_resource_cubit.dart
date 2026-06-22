import 'package:app/models/remote/course/prf_school.dart';
import 'package:app/services/api/school_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/single_resource_cubit.dart';

class SchoolDetailsResourceCubit extends SingleResourceCubit<PRFSchool> {
  SchoolDetailsResourceCubit({
    required SchoolService schoolService,
    required HiveService hiveService,
  }) : super(service: schoolService, dbService: hiveService.schools);

  @override
  List<String> get defaultIncludes => [
    'missions.school',
    'missions.schoolTerm',
    'missions.missionType',
  ];

  Future<void> loadSchool({
    required String schoolUlid,
    bool refresh = false,
  }) async {
    await loadOne(
      id: schoolUlid,
      refresh: refresh,
      matchById: (school) => school.ulid == schoolUlid,
    );
  }
}
