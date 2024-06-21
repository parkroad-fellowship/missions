import 'package:app/models/remote/prf_course.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_courses_state.dart';
part 'get_courses_cubit.freezed.dart';

class GetCoursesCubit extends Cubit<GetCoursesState> {
  GetCoursesCubit({
    required LMSService lmsService,
  }) : super(const GetCoursesState.initial()) {
    _lmsService = lmsService;
  }

  late LMSService _lmsService;

  Future<void> getCourses() async {
    emit(const GetCoursesState.loading());

    try {
      final courses = await _lmsService.getCourses(
        includes: 'thumbnail,courseMember',
      );
      emit(GetCoursesState.loaded(courses: courses));
    } catch (e) {
      emit(GetCoursesState.error(e.toString()));
    }
  }
}
