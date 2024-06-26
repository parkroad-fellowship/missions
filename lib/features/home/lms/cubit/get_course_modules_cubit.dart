import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_course_modules_state.dart';
part 'get_course_modules_cubit.freezed.dart';

class GetCourseModulesCubit extends Cubit<GetCourseModulesState> {
  GetCourseModulesCubit({
    required LMSService lmsService,
    required LocalDBService localDBService,
  }) : super(const GetCourseModulesState.initial()) {
    _lmsService = lmsService;
    _localDBService = localDBService;
  }

  late LMSService _lmsService;
  late LocalDBService _localDBService;

  Future<void> getCourseModules({
    required String courseUlid,
  }) async {
    emit(const GetCourseModulesState.loading());

    try {
      final courseModules = await _lmsService.getCourseModules(
        courseUlid: courseUlid,
        includes: 'course.thumbnail,course.courseMember,module.thumbnail,'
            'memberModule,module.lessonModules.lesson,'
            'module.lessonModules.lessonMember,module.lessonModules.module',
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
