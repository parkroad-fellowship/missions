import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/services/api/course_module_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class ModuleResourceCubit extends ResourceCubit<PRFCourseModule> {
  ModuleResourceCubit({
    required CourseModuleService courseModuleService,
    super.dbService,
  }) : super(service: courseModuleService) {
    subscribeToIsarUpdates();
  }

  @override
  List<String> get defaultIncludes => [
    'course.thumbnail',
    'course.courseMember',
    'module.thumbnail',
    'memberModule',
    'module.lessonModules.lesson',
    'module.lessonModules.lessonMember',
    'module.lessonModules.module',
  ];
}
