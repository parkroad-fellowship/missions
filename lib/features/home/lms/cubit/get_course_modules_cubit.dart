import 'package:app/services/api/course_module_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_course_modules_state.dart';
part 'get_course_modules_cubit.freezed.dart';

class GetCourseModulesCubit extends Cubit<GetCourseModulesState> {
  GetCourseModulesCubit({
    required CourseModuleService courseModuleService,
    required IsarService isarService,
  }) : super(const GetCourseModulesState.initial()) {
    _courseModuleService = courseModuleService;
    _isarService = isarService;
  }

  late CourseModuleService _courseModuleService;
  late IsarService _isarService;

  Future<void> getCourseModules({required String courseUlid}) async {
    emit(const GetCourseModulesState.loading());

    try {
      final localCourseModules = await _isarService.courseModules
          .listParentModules(courseUlid);
      if (localCourseModules.isEmpty) {
        final courseModules = await _courseModuleService.list(
          filters: {
            'course_ulid': courseUlid,
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

        await _isarService.courseModules.persistEntities(courseModules);
        for (final courseModule in courseModules) {
          await _isarService.lessonModules.persistEntities(
            courseModule.module!.lessonModules!,
          );
        }
      }
      await _isarService.courseModules.refreshParentStream(courseUlid);

      emit(const GetCourseModulesState.loaded());
    } catch (e) {
      emit(GetCourseModulesState.error(e.toString()));
    }
  }
}
