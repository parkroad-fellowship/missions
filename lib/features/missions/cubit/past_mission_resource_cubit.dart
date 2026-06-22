import 'package:app/features/missions/cubit/mission_resource_cubit.dart'
    show MissionResourceCubit;
import 'package:app/models/remote/course/prf_school.dart';
import 'package:app/services/api/school_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

/// Cubit for loading past/completed missions.
/// Separate from [MissionResourceCubit] so the "All" and "Past" tabs
/// maintain independent state without overwriting each other.
class PastMissionResourceCubit extends ResourceCubit<PRFSchool> {
  PastMissionResourceCubit({
    required SchoolService schoolService,
    required HiveService hiveService,
  }) : super(service: schoolService, dbService: hiveService.schools);

  @override
  List<String> get defaultIncludes => [
    'missions.school',
    'missions.schoolTerm',
    'missions.missionType',
  ];

  @override
  Map<String, dynamic> get defaultFilters => {};

  @override
  String? get defaultSortBy => 'name';

  @override
  Future<List<PRFSchool>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    return dbService.filterBy(
      (school) => [
        filters?['search'] == null ||
            (school.name.toLowerCase().contains(
              (filters!['search'] as String).toLowerCase(),
            )),
      ],
    );
  }
}
