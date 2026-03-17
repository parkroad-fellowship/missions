import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/services/api/course_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class CourseResourceCubit extends ResourceCubit<PRFCourse> {
  CourseResourceCubit({
    required CourseService courseService,
    BaseLocalDBService<PRFCourse, dynamic>? dbService,
  }) : super(service: courseService, dbService: dbService);

  @override
  List<String> get defaultIncludes => ['thumbnail', 'courseMember'];
}
