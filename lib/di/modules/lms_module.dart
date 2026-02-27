import 'package:app/features/home/lms/cubit/finish_lesson_cubit.dart';
import 'package:app/features/home/lms/cubit/get_course_cubit.dart';
import 'package:app/features/home/lms/cubit/get_course_modules_cubit.dart';
import 'package:app/features/home/lms/cubit/get_courses_cubit.dart';
import 'package:app/features/home/lms/cubit/get_lesson_cubit.dart';
import 'package:app/features/home/lms/cubit/get_lesson_modules_cubit.dart';
import 'package:app/features/home/lms/cubit/get_module_cubit.dart';
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
      BlocProvider<GetCoursesCubit>(
        create: (context) => GetCoursesCubit(
          courseService: getIt(),
          isarService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetCourseCubit>(
        create: (context) => GetCourseCubit(
          courseService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetCourseModulesCubit>(
        create: (context) => GetCourseModulesCubit(
          courseModuleService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetModuleCubit>(
        create: (context) => GetModuleCubit(isarService: getIt()),
      ),
      BlocProvider<GetLessonModulesCubit>(
        create: (context) => GetLessonModulesCubit(
          lessonModuleService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetLessonCubit>(
        create: (context) => GetLessonCubit(isarService: getIt()),
      ),
      BlocProvider<FinishLessonCubit>(
        create: (context) => FinishLessonCubit(
          lessonMemberService: getIt(),
          hiveService: getIt(),
          isarService: getIt(),
        ),
      ),
    ];
  }
}
