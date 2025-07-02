import 'package:app/services/_index.dart';
import 'package:app/services/api/course_module_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_course_modules_state.dart';
part 'get_course_modules_cubit.freezed.dart';

class GetCourseModulesCubit extends Cubit<GetCourseModulesState> {
  GetCourseModulesCubit({
    required CourseModuleService courseModuleService,
    required LocalDBService localDBService,
  }) : super(const GetCourseModulesState.initial()) {
    _courseModuleService = courseModuleService;
    _localDBService = localDBService;
  }

  late CourseModuleService _courseModuleService;
  late LocalDBService _localDBService;

  Future<void> getCourseModules({required String courseUlid}) async {
    emit(const GetCourseModulesState.loading());

    try {
      final courseModules = await _courseModuleService.list(
        filters: {
          'filter[course_ulid]': courseUlid,
        },
        includes: [
          'course.thumbnail',
          'course.courseMember',
          'module.thumbnail',
          'memberModule',
          'module.lessonModules.lesson',
          'module.lessonModules.lessonMember',
          'module.lessonModules.module',
        ],
      );

      await _localDBService.persistCourseModules(
        courseModules: courseModules,
        courseUlid: courseUlid,
      );

      emit(const GetCourseModulesState.loaded());
    } catch (e) {
      emit(GetCourseModulesState.error(e.toString()));
    }
  }
}
