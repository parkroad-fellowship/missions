import 'package:app/models/remote/course/prf_course_module.dart';
import 'package:app/services/api/course_module_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class ModuleResourceCubit extends ResourceCubit<PRFCourseModule> {
  ModuleResourceCubit({
    required CourseModuleService courseModuleService,
    BaseLocalDBService<PRFCourseModule, dynamic>? dbService,
  }) : super(service: courseModuleService, dbService: dbService);

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
