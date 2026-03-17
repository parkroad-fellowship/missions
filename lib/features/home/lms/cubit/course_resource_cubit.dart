import 'package:app/models/remote/course/prf_course.dart';
import 'package:app/services/api/course_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class CourseResourceCubit extends ResourceCubit<PRFCourse> {
  CourseResourceCubit({
    required CourseService courseService,
    super.dbService,
  }) : super(service: courseService);

  @override
  List<String> get defaultIncludes => ['thumbnail', 'courseMember'];
}
