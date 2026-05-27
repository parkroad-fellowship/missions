import 'package:app/features/lms/cubit/course_resource_cubit.dart';
import 'package:app/features/lms/cubit/lesson_resource_cubit.dart';
import 'package:app/features/lms/cubit/module_resource_cubit.dart';
import 'package:app/services/api/course_module_service.dart';
import 'package:app/services/api/course_service.dart';
import 'package:app/services/api/lesson_member_service.dart';
import 'package:app/services/api/lesson_module_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Feature-owned LMS registrations.
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
