import 'package:app/features/home/lms/cubit/course_resource_cubit.dart';
import 'package:app/features/home/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/home/lms/cubit/module_resource_cubit.dart';
import 'package:app/services/api/course_module_service.dart';
import 'package:app/services/api/course_service.dart';
import 'package:app/services/api/lesson_member_service.dart';
import 'package:app/services/api/lesson_module_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// LMS module for registering learning management services and cubits.
///
/// Includes:
/// - Course services
/// - Module services
/// - Lesson services
class LmsModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<CourseService>(CourseService())
      ..registerSingleton<CourseModuleService>(CourseModuleService())
      ..registerSingleton<LessonModuleService>(LessonModuleService())
      ..registerSingleton<LessonMemberService>(LessonMemberService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<CourseResourceCubit>(
        create: (context) => CourseResourceCubit(courseService: getIt()),
      ),
      BlocProvider<ModuleResourceCubit>(
        create: (context) => ModuleResourceCubit(
          courseModuleService: getIt(),
        ),
      ),
      BlocProvider<LessonResourceCubit>(
        create: (context) => LessonResourceCubit(
          lessonModuleService: getIt(),
          lessonMemberService: getIt(),
        ),
      ),
    ];
  }
}
