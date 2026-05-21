import 'package:app/models/local/course/prf_course.dart';
import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/services/api/course_service.dart';
import 'package:app/utils/crud/single_resource_cubit.dart';

/// Dedicated cubit for course detail screens.
///
/// Keeping detail loading isolated prevents detail fetches from mutating
/// list-route state owned by [CourseResourceCubit].
class CourseDetailsResourceCubit
    extends SingleResourceCubit<PRFCourse, PRFLocalCourse> {
  CourseDetailsResourceCubit({
    required CourseService courseService,
    super.dbService,
  }) : super(service: courseService);

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
