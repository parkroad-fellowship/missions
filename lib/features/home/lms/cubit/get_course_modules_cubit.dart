import 'package:app/models/remote/prf_course_module.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_course_modules_state.dart';
part 'get_course_modules_cubit.freezed.dart';

class GetCourseModulesCubit extends Cubit<GetCourseModulesState> {
  GetCourseModulesCubit({
    required LMSService lmsService,
  }) : super(const GetCourseModulesState.initial()) {
    _lmsService = lmsService;
  }

  late LMSService _lmsService;

  Future<void> getCourseModules({
    required String courseUlid,
  }) async {
    emit(const GetCourseModulesState.loading());

    try {
      final courseModules = await _lmsService.getCourseModules(
        courseUlid: courseUlid,
        includes: 'course.thumbnail,course.courseMember,module.thumbnail,'
            'module.memberModule,module.lessonModules.lesson,'
            'module.lessonModules.lessonMember',
      );
      emit(GetCourseModulesState.loaded(courseModules: courseModules));
    } catch (e) {
      emit(GetCourseModulesState.error(e.toString()));
    }
  }
}
