import 'package:app/features/lms/cubit/course_resource_cubit.dart';
import 'package:app/features/lms/cubit/course_resource_cubit.dart'
    show CourseResourceCubit;
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/services/api/course_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/single_resource_cubit.dart';

/// Dedicated cubit for course detail screens.
///
/// Keeping detail loading isolated prevents detail fetches from mutating
/// list-route state owned by [CourseResourceCubit].
class CourseDetailsResourceCubit extends SingleResourceCubit<PRFCourse> {
  CourseDetailsResourceCubit({
    required CourseService courseService,
    required HiveService hiveService,
  }) : super(service: courseService, dbService: hiveService.courses);

  @override
  List<String> get defaultIncludes => ['thumbnail', 'courseMember'];

  Future<void> loadCourse({
    required String courseUlid,
    bool refresh = false,
  }) async {
    await loadOne(
      id: courseUlid,
      refresh: refresh,
      matchById: (course) => course.ulid == courseUlid,
    );
  }
}
