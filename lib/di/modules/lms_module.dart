import 'package:app/features/home/lms/cubit/course_resource_cubit.dart';
import 'package:app/features/home/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/home/lms/cubit/module_resource_cubit.dart';
import 'package:app/services/_index.dart';
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
        create: (context) => CourseResourceCubit(
          courseService: getIt(),
          dbService: getIt<IsarService>().courses,
        ),
      ),
      BlocProvider<ModuleResourceCubit>(
        create: (context) => ModuleResourceCubit(
          courseModuleService: getIt(),
          dbService: getIt<IsarService>().courseModules,
        ),
      ),
      BlocProvider<LessonResourceCubit>(
        create: (context) => LessonResourceCubit(
          lessonModuleService: getIt(),
          hiveService: getIt(),
          lessonMemberService: getIt(),
          dbService: getIt<IsarService>().lessonModules,
        ),
      ),
    ];
  }
}
