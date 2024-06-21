import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_courses_state.dart';
part 'get_courses_cubit.freezed.dart';

class GetCoursesCubit extends Cubit<GetCoursesState> {
  GetCoursesCubit({
    required LMSService lmsService,
    required LocalDBService localDBService,
  }) : super(const GetCoursesState.initial()) {
    _lmsService = lmsService;
    _localDBService = localDBService;
  }

  late LMSService _lmsService;
  late LocalDBService _localDBService;

  Future<void> getCourses() async {
    emit(const GetCoursesState.loading());

    try {
      final courses = await _lmsService.getCourses(
        includes: 'thumbnail,courseMember',
      );

      await _localDBService.persistCourses(courses: courses);

      emit(const GetCoursesState.loaded());
    } catch (e) {
      emit(GetCoursesState.error(e.toString()));
    }
  }
}
